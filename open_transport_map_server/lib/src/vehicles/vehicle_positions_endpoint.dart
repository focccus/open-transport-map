import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Relays the Västtrafik vehicle-positions SSE feed to clients as a
/// [Stream] of [VehicleDelta].
///
/// Upstream emits `snapshot` (full vehicle list) then `delta`
/// (`{updated, removed}`) events. Each SSE event becomes one [VehicleDelta].
class VehiclePositionsEndpoint extends Endpoint {
  static const _upstreamHost = 'labs-api.vasttrafik.se';
  static const _upstreamPath = '/api/vehicle-positions/stream';
  static const _linesHost = 'labs.vasttrafik.se';
  static const _linesPath = '/api/vehicle-positions-map/lines';

  /// Line metadata by line gid, fetched once per stream subscription.
  /// Maps to shortName + background/foreground colors for marker icons.
  Map<String, _LineInfo> _lines = const {};

  Stream<VehicleDelta> watchVehicles(
    Session session, {
    required double north,
    required double south,
    required double east,
    required double west,
  }) async* {
    _lines = await _fetchLines(session);
    final httpClient = HttpClient();
    try {
      final uri = Uri.https(_upstreamHost, _upstreamPath, {
        'north': '$north',
        'south': '$south',
        'east': '$east',
        'west': '$west',
      });
      final request = await httpClient.getUrl(uri);
      request.headers.set('Accept', 'text/event-stream');
      final response = await request.close();

      if (response.statusCode != 200) {
        await response.drain<void>();
        throw StateError(
          'Upstream vehicle feed returned ${response.statusCode}',
        );
      }

      var eventName = '';
      var data = StringBuffer();

      await for (final line
          in response.transform(utf8.decoder).transform(const LineSplitter())) {
        if (line.isEmpty) {
          // Blank line dispatches the buffered event.
          final payload = data.toString();
          final name = eventName;
          eventName = '';
          data = StringBuffer();
          if (payload.isEmpty) continue;
          final delta = _parseEvent(name, payload, session);
          if (delta != null) yield delta;
          continue;
        }
        if (line.startsWith(':')) continue; // SSE comment / heartbeat
        if (line.startsWith('event:')) {
          eventName = line.substring(6).trim();
        } else if (line.startsWith('data:')) {
          var value = line.substring(5);
          if (value.startsWith(' ')) value = value.substring(1);
          if (data.isNotEmpty) data.writeln();
          data.write(value);
        }
      }
    } finally {
      // Runs on upstream close and on client cancel.
      httpClient.close(force: true);
    }
  }

  VehicleDelta? _parseEvent(
    String eventName,
    String payload,
    Session session,
  ) {
    try {
      final decoded = jsonDecode(payload);
      if (eventName == 'snapshot' && decoded is List) {
        return VehicleDelta(
          updated: decoded
              .whereType<Map<String, dynamic>>()
              .map(_vehicleFromJson)
              .toList(),
          removed: [],
        );
      }
      if (decoded is Map<String, dynamic>) {
        final updated = (decoded['updated'] as List? ?? [])
            .whereType<Map<String, dynamic>>()
            .map(_vehicleFromJson)
            .toList();
        final removed = (decoded['removed'] as List? ?? [])
            .whereType<String>()
            .toList();
        return VehicleDelta(updated: updated, removed: removed);
      }
      return null;
    } catch (e) {
      session.log(
        'Failed to parse $eventName vehicle event: $e',
        level: LogLevel.warning,
      );
      return null;
    }
  }

  VehiclePosition _vehicleFromJson(Map<String, dynamic> json) {
    double? asDouble(Object? v) => (v as num?)?.toDouble();
    final serviceJourneyGid = json['serviceJourneyGid'] as String?;
    final line = serviceJourneyGid == null
        ? null
        : _lines[lineGidForServiceJourney(serviceJourneyGid)];
    return VehiclePosition(
      vehicleId: json['vehicleId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      serviceJourneyGid: serviceJourneyGid,
      status: json['status'] as String?,
      atStop: json['atStop'] as bool?,
      lastStopPointGid: json['lastStopPointGid'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      speedKmh: asDouble(json['speedKmh']),
      course: asDouble(json['course']),
      destination: json['destination'] as String?,
      via: json['via'] as String?,
      lineShortName: line?.shortName,
      lineTransportMode: line?.transportMode,
      lineBackgroundColor: line?.backgroundColor,
      lineForegroundColor: line?.foregroundColor,
    );
  }

  Future<Map<String, _LineInfo>> _fetchLines(Session session) async {
    final httpClient = HttpClient();
    try {
      final uri = Uri.https(_linesHost, _linesPath);
      final request = await httpClient.getUrl(uri);
      request.headers.set('Accept', 'application/json');
      final response = await request.close();
      if (response.statusCode != 200) {
        await response.drain<void>();
        session.log(
          'Line metadata returned ${response.statusCode}, '
          'markers fall back to defaults',
          level: LogLevel.warning,
        );
        return const {};
      }
      final body = await response.transform(utf8.decoder).join();
      final decoded = jsonDecode(body);
      if (decoded is! List) return const {};
      final lines = <String, _LineInfo>{};
      for (final entry in decoded.whereType<Map<String, dynamic>>()) {
        final gid = entry['gid'] as String?;
        if (gid == null) continue;
        lines[gid] = _LineInfo(
          shortName: entry['shortName'] as String? ?? '',
          transportMode: entry['transportMode'] as String? ?? '',
          backgroundColor: entry['backgroundColor'] as String? ?? '#1d4ed8',
          foregroundColor: entry['foregroundColor'] as String? ?? '#ffffff',
        );
      }
      session.log('Loaded ${lines.length} line styles');
      return lines;
    } catch (e) {
      session.log(
        'Failed to fetch line metadata: $e, markers fall back to defaults',
        level: LogLevel.warning,
      );
      return const {};
    } finally {
      httpClient.close(force: true);
    }
  }
}

/// Derives the line gid from a service journey gid.
///
/// Observed pattern: vehicle `serviceJourneyGid` like `9015014500604700`
/// maps to line `gid` like `9011014500600000` — char index 3 (`5` -> `1`)
/// and the trailing journey part zeroed. Falls back to the raw gid when
/// the pattern does not match.
String lineGidForServiceJourney(String serviceJourneyGid) {
  if (serviceJourneyGid.length == 16) {
    return '${serviceJourneyGid.substring(0, 3)}1'
        '${serviceJourneyGid.substring(4, 12)}0000';
  }
  return serviceJourneyGid;
}

/// Line style metadata from `/api/vehicle-positions-map/lines`.
class _LineInfo {
  const _LineInfo({
    required this.shortName,
    required this.transportMode,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String shortName;

  /// Upstream mode: `bus`, `tram`, `train`, `ferry`, `taxi`. Relayed to the
  /// client so vehicle types can be filtered on fact rather than on the line
  /// number, which overlaps between modes (buses and trams share 1-14).
  final String transportMode;
  final String backgroundColor;
  final String foregroundColor;
}
