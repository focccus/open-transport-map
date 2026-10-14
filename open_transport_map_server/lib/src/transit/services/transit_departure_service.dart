import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../adapters/vasttrafik/vasttrafik_pr_v4_client.dart';
import 'transit_sync_service.dart';

/// Fetches departures for a stop on demand and lazily caches the journey data
/// those departures need: the route alignment, and the stop each line calls at
/// next.
///
/// Nothing is preloaded — upstream line data changes often enough that a full
/// mirror is both wasteful and wrong. Instead, when a user opens a stop, each
/// `(line, destination)` pair that is missing or older than [_routeTtl] is
/// looked up through the departure detail endpoint once, and the result is
/// cached per stop point. Later requests for the same pair read straight from
/// the database.
///
/// Results are streamed as a sequence of complete states so the UI is never
/// blocked on the detail calls:
/// 1. The departures, with whatever geometry and next stops are already cached.
/// 2. The same departures, with the remaining detail data filled in.
///
/// The detail calls themselves run concurrently ([_maxConcurrentDetails] at a
/// time), but every database write happens afterwards, serially: two lines
/// sharing a route row would otherwise race to insert it.
class TransitDepartureService {
  /// How long cached route and next-stop data is reused before refetching.
  static const _routeTtl = Duration(hours: 12);

  /// Detail requests in flight at once. Enough to hide latency without
  /// hammering the upstream API when a stop serves many lines.
  static const _maxConcurrentDetails = 4;

  static const _defaultLineColor = '#1d4ed8';
  static const _defaultForegroundColor = '#ffffff';

  static final _client = VasttrafikPrV4Client();

  /// Departures at [gid] (a stop area or stop point) plus the GeoJSON of the
  /// routes serving it. Every event is the complete current state; see the
  /// class docs for the two-stage contract.
  static Stream<StopDeparturesResponse> watchDepartures(
    Session session, {
    required String gid,
    required bool isStopArea,
    String agencyExternalId = 'vasttrafik',
  }) async* {
    // Route adapter diagnostics into the session log.
    final previousLogger = VasttrafikPrV4Client.logger;
    VasttrafikPrV4Client.logger = (message) =>
        session.log(message, level: LogLevel.debug);
    try {
      yield* _watchDepartures(
        session,
        gid: gid,
        isStopArea: isStopArea,
        agencyExternalId: agencyExternalId,
      );
    } finally {
      VasttrafikPrV4Client.logger = previousLogger;
    }
  }

  static Stream<StopDeparturesResponse> _watchDepartures(
    Session session, {
    required String gid,
    required bool isStopArea,
    required String agencyExternalId,
  }) async* {
    final metadata = await _stopMetadata(
      session,
      gid: gid,
      isStopArea: isStopArea,
    );

    StopDeparturesResponse build(
      List<DepartureItem> departures,
      String routeShapesGeoJson,
    ) => StopDeparturesResponse(
      stopGid: gid,
      stopName: metadata.name,
      isStopArea: isStopArea,
      stopAreaGid: metadata.stopAreaGid,
      municipality: metadata.municipality,
      platform: metadata.platform,
      departures: departures,
      routeShapesGeoJson: routeShapesGeoJson,
    );

    final departures = <DepartureItem>[];
    final pendingByKey = <String, _PendingRoute>{};

    if (await TransitSyncService.ensureVasttrafikConfigured(session)) {
      final raw = await _client.fetchDepartures(
        gid: gid,
        isStopArea: isStopArea,
      );

      for (final entry in raw) {
        final item = _departureFromJson(entry);
        if (item == null) continue;
        departures.add(item);
        final key = _routeKey(item.lineDesignation, item.destination);
        if (pendingByKey.containsKey(key)) continue;

        final detailsReference = _string(entry['detailsReference']);
        final stopPointGid = _string(_map(entry['stopPoint'])?['gid']);
        if (detailsReference == null || stopPointGid == null) continue;

        final line = _map(_map(entry['serviceJourney'])?['line']);
        pendingByKey[key] = _PendingRoute(
          item: item,
          detailsReference: detailsReference,
          stopPointGid: stopPointGid,
          lineGid: _string(line?['gid']),
        );
      }
    }

    final agency = await TransitAgency.db.findFirstRow(
      session,
      where: (t) => t.externalId.equals(agencyExternalId),
    );
    final agencyId = agency?.id;

    // Stage 1: serve whatever is already cached. No upstream calls, so the
    // list, and any known route lines and next stops, appear immediately.
    final shapes = <String, _ResolvedShape>{};
    final nextStopByKey = <String, String?>{};
    final needsDetails = <MapEntry<String, _PendingRoute>>[];
    if (agencyId != null) {
      for (final entry in pendingByKey.entries) {
        final pending = entry.value;
        final route = await _loadRoute(
          session,
          agencyId: agencyId,
          pending: pending,
        );
        if (route == null) {
          needsDetails.add(entry);
          continue;
        }

        final shape = await _loadShape(
          session,
          routeId: route.id!,
          headsign: pending.item.destination,
        );
        final nextStop = await _loadNextStop(
          session,
          routeId: route.id!,
          headsign: pending.item.destination,
          stopPointExternalId: pending.stopPointGid,
        );
        final nextStopName = nextStop?.nextStopName;
        if (nextStopName != null) nextStopByKey[entry.key] = nextStopName;
        if (shape != null) {
          shapes[entry.key] = _resolved(
            route,
            shape,
            pending.item,
            nextStop: nextStopName,
          );
        }

        // A cache entry counts as usable only when both halves are fresh; the
        // next stop is what the chip filter needs.
        final fresh =
            shape != null &&
            _isFresh(shape.cachedAt) &&
            nextStop != null &&
            _isFresh(nextStop.cachedAt);
        if (!fresh) needsDetails.add(entry);
      }
    }

    yield build(
      _withNextStops(departures, nextStopByKey),
      _featureCollection(shapes.values),
    );

    if (agencyId == null || needsDetails.isEmpty) return;

    // Stage 2a: the network-bound part, run concurrently.
    final infos = <String, _JourneyInfo>{};
    try {
      await _forEachLimited(needsDetails, _maxConcurrentDetails, (entry) async {
        infos[entry.key] = await _fetchJourneyInfo(entry.value);
      });
    } catch (e, st) {
      // The departures already reached the client; the rest is decoration.
      session.log(
        'Journey details failed for $gid: $e',
        level: LogLevel.warning,
        stackTrace: st,
      );
      return;
    }

    // Stage 2b: the database-bound part, run serially. Two lines on the same
    // route would otherwise race to insert the shared route row.
    for (final entry in needsDetails) {
      final info = infos[entry.key];
      if (info == null) continue;
      final resolved = await _storeDetails(
        session,
        agencyId: agencyId,
        pending: entry.value,
        info: info,
      );
      if (resolved != null) shapes[entry.key] = resolved;

      final nextStopName = resolved?.nextStop ?? info.nextStop;
      if (nextStopName != null) nextStopByKey[entry.key] = nextStopName;
    }

    session.log(
      'Departures for $gid: ${shapes.length} route shapes and '
      '${nextStopByKey.length} next stops of ${pendingByKey.length} line pairs',
      level: LogLevel.debug,
    );
    yield build(
      _withNextStops(departures, nextStopByKey),
      _featureCollection(shapes.values),
    );
  }

  /// Copies [nextStops] onto the departures that share each line pair.
  static List<DepartureItem> _withNextStops(
    List<DepartureItem> departures,
    Map<String, String?> nextStops,
  ) {
    if (nextStops.isEmpty) return departures;
    return [
      for (final departure in departures)
        departure.copyWith(
          nextStop:
              nextStops[_routeKey(
                departure.lineDesignation,
                departure.destination,
              )],
        ),
    ];
  }

  static Future<TransitRoute?> _loadRoute(
    Session session, {
    required int agencyId,
    required _PendingRoute pending,
  }) {
    final externalId = pending.lineGid ?? pending.item.lineDesignation;
    return TransitRoute.db.findFirstRow(
      session,
      where: (t) =>
          t.agencyId.equals(agencyId) & t.externalId.equals(externalId),
    );
  }

  static Future<TransitRouteShape?> _loadShape(
    Session session, {
    required int routeId,
    required String headsign,
  }) {
    return TransitRouteShape.db.findFirstRow(
      session,
      where: (t) => t.routeId.equals(routeId) & t.headsign.equals(headsign),
    );
  }

  static Future<TransitNextStop?> _loadNextStop(
    Session session, {
    required int routeId,
    required String headsign,
    required String stopPointExternalId,
  }) {
    return TransitNextStop.db.findFirstRow(
      session,
      where: (t) =>
          t.routeId.equals(routeId) &
          t.headsign.equals(headsign) &
          t.stopPointExternalId.equals(stopPointExternalId),
    );
  }

  /// Upserts the route, its shape and its next stop for one line pair, and
  /// returns the shape ready to be drawn. Null when there is no shape to draw.
  static Future<_ResolvedShape?> _storeDetails(
    Session session, {
    required int agencyId,
    required _PendingRoute pending,
    required _JourneyInfo info,
  }) async {
    final item = pending.item;
    final now = DateTime.now().toUtc();

    final existingRoute = await _loadRoute(
      session,
      agencyId: agencyId,
      pending: pending,
    );
    final route = existingRoute == null
        ? await TransitRoute.db.insertRow(
            session,
            TransitRoute(
              agencyId: agencyId,
              externalId: pending.lineGid ?? item.lineDesignation,
              shortName: item.lineShortName,
              longName: item.lineName,
              transportMode: item.transportMode ?? 'unknown',
              backgroundColor: item.backgroundColor,
              foregroundColor: item.foregroundColor,
              borderColor: item.borderColor,
              cachedAt: now,
            ),
          )
        : await TransitRoute.db.updateRow(
            session,
            existingRoute.copyWith(
              shortName: item.lineShortName,
              longName: item.lineName ?? existingRoute.longName,
              transportMode: item.transportMode ?? existingRoute.transportMode,
              backgroundColor: item.backgroundColor,
              foregroundColor: item.foregroundColor,
              borderColor: item.borderColor,
              cachedAt: now,
            ),
          );

    var shape = await _loadShape(
      session,
      routeId: route.id!,
      headsign: item.destination,
    );
    final geometry = info.geometry;
    if (geometry != null) {
      shape = shape == null
          ? await TransitRouteShape.db.insertRow(
              session,
              TransitRouteShape(
                routeId: route.id!,
                headsign: item.destination,
                geometryGeoJson: geometry,
                cachedAt: now,
              ),
            )
          : await TransitRouteShape.db.updateRow(
              session,
              shape.copyWith(geometryGeoJson: geometry, cachedAt: now),
            );
    }

    final nextStopName = info.nextStop;
    if (nextStopName != null) {
      final existingNextStop = await _loadNextStop(
        session,
        routeId: route.id!,
        headsign: item.destination,
        stopPointExternalId: pending.stopPointGid,
      );
      if (existingNextStop == null) {
        await TransitNextStop.db.insertRow(
          session,
          TransitNextStop(
            routeId: route.id!,
            headsign: item.destination,
            stopPointExternalId: pending.stopPointGid,
            nextStopName: nextStopName,
            cachedAt: now,
          ),
        );
      } else {
        await TransitNextStop.db.updateRow(
          session,
          existingNextStop.copyWith(
            nextStopName: nextStopName,
            cachedAt: now,
          ),
        );
      }
    }

    if (shape == null) return null;
    return _resolved(route, shape, item, nextStop: nextStopName);
  }

  /// Fetches one departure's journey details: the route as a GeoJSON
  /// `LineString`, and the name of the call after this departure's stop.
  static Future<_JourneyInfo> _fetchJourneyInfo(_PendingRoute pending) async {
    final details = await _client.fetchDetails(
      stopPointGid: pending.stopPointGid,
      detailsReference: pending.detailsReference,
    );
    final journeys = details?['serviceJourneys'];
    if (journeys is! List) return const _JourneyInfo();

    for (final journey in journeys.whereType<Map<String, dynamic>>()) {
      final info = _JourneyInfo(
        geometry: _lineString(journey['serviceJourneyCoordinates']),
        nextStop: _nextStopFromJourney(journey, pending.stopPointGid),
      );
      if (info.geometry != null || info.nextStop != null) return info;
    }
    return const _JourneyInfo();
  }

  /// GeoJSON `LineString` for a journey's coordinates. Null when there are
  /// fewer than two usable points.
  static String? _lineString(Object? coordinates) {
    if (coordinates is! List) return null;
    final points = <List<double>>[];
    for (final coordinate in coordinates.whereType<Map<String, dynamic>>()) {
      final latitude = (coordinate['latitude'] as num?)?.toDouble();
      final longitude = (coordinate['longitude'] as num?)?.toDouble();
      if (latitude == null || longitude == null) continue;
      // GeoJSON is [longitude, latitude].
      points.add([longitude, latitude]);
    }
    if (points.length < 2) return null;
    return jsonEncode({'type': 'LineString', 'coordinates': points});
  }

  /// Name of the call following [stopPointGid] on the journey, in call order.
  /// Null when the journey terminates there, or when the stop is not one of
  /// the journey's calls.
  static String? _nextStopFromJourney(
    Map<String, dynamic> journey,
    String stopPointGid,
  ) {
    final calls = journey['callsOnServiceJourney'];
    if (calls is! List) return null;

    final ordered = calls.whereType<Map<String, dynamic>>().toList()
      ..sort((a, b) => _callIndex(a).compareTo(_callIndex(b)));

    for (var i = 0; i < ordered.length; i++) {
      final gid = _string(_map(ordered[i]['stopPoint'])?['gid']);
      if (gid != stopPointGid) continue;
      if (i + 1 >= ordered.length) return null;
      return _string(_map(ordered[i + 1]['stopPoint'])?['name']);
    }
    return null;
  }

  /// Calls carry their position along the journey as a string.
  static int _callIndex(Map<String, dynamic> call) =>
      int.tryParse('${call['index']}') ?? 0;

  /// Ordered calls of one journey, for the timeline view. [stopPointGid] and
  /// [detailsReference] come from the departure the user tapped.
  static Future<List<ServiceJourneyCall>> fetchServiceJourneyCalls(
    Session session, {
    required String stopPointGid,
    required String detailsReference,
  }) async {
    // Route adapter diagnostics into the session log.
    final previousLogger = VasttrafikPrV4Client.logger;
    VasttrafikPrV4Client.logger = (message) =>
        session.log(message, level: LogLevel.debug);
    try {
      if (!await TransitSyncService.ensureVasttrafikConfigured(session)) {
        return const [];
      }
      final details = await _client.fetchDetails(
        stopPointGid: stopPointGid,
        detailsReference: detailsReference,
      );
      return callsFromDetails(details);
    } finally {
      VasttrafikPrV4Client.logger = previousLogger;
    }
  }

  /// Calls of the first journey in a details payload, in call order. Empty when
  /// the payload holds no usable journey.
  ///
  /// Public alongside the other payload parsers so the mapping can be tested
  /// against a captured payload.
  static List<ServiceJourneyCall> callsFromDetails(
    Map<String, dynamic>? details,
  ) {
    final journeys = details?['serviceJourneys'];
    if (journeys is! List) return const [];

    for (final journey in journeys.whereType<Map<String, dynamic>>()) {
      final calls = journey['callsOnServiceJourney'];
      if (calls is! List) continue;

      final ordered = calls.whereType<Map<String, dynamic>>().toList()
        ..sort((a, b) => _callIndex(a).compareTo(_callIndex(b)));
      final parsed = <ServiceJourneyCall>[];
      for (final call in ordered) {
        final item = _callFromJson(call);
        if (item != null) parsed.add(item);
      }
      if (parsed.isEmpty) continue;
      return parsed;
    }
    return const [];
  }

  /// One call of a details payload. Null when it names no stop point.
  static ServiceJourneyCall? _callFromJson(Map<String, dynamic> call) {
    final stopPoint = _map(call['stopPoint']);
    final name = _string(stopPoint?['name']);
    if (name == null) return null;

    final stopPointPlatform = _string(stopPoint?['platform']);
    return ServiceJourneyCall(
      stopPointGid: _string(stopPoint?['gid']) ?? '',
      name: name,
      latitude:
          (call['latitude'] as num?)?.toDouble() ??
          (stopPoint?['latitude'] as num?)?.toDouble(),
      longitude:
          (call['longitude'] as num?)?.toDouble() ??
          (stopPoint?['longitude'] as num?)?.toDouble(),
      platform:
          _string(call['estimatedPlatform']) ??
          _string(call['plannedPlatform']) ??
          stopPointPlatform,
      plannedArrivalTime: _dateTime(call['plannedArrivalTime']),
      estimatedArrivalTime:
          _dateTime(call['estimatedArrivalTime']) ??
          _dateTime(call['estimatedOtherwisePlannedArrivalTime']),
      plannedDepartureTime: _dateTime(call['plannedDepartureTime']),
      estimatedDepartureTime:
          _dateTime(call['estimatedDepartureTime']) ??
          _dateTime(call['estimatedOtherwisePlannedDepartureTime']),
      // Either leg being cancelled strikes the call through.
      isCancelled:
          call['isCancelled'] == true ||
          call['isDepartureCancelled'] == true ||
          call['isArrivalCancelled'] == true,
    );
  }

  /// Runs [action] over [items] with at most [limit] in flight.
  static Future<void> _forEachLimited<T>(
    List<T> items,
    int limit,
    Future<void> Function(T) action,
  ) async {
    if (items.isEmpty) return;
    var next = 0;
    Future<void> worker() async {
      while (true) {
        final index = next++;
        if (index >= items.length) return;
        await action(items[index]);
      }
    }

    final workers = limit < items.length ? limit : items.length;
    await Future.wait([for (var i = 0; i < workers; i++) worker()]);
  }

  static Future<StopMetadata> _stopMetadata(
    Session session, {
    required String gid,
    required bool isStopArea,
  }) async {
    if (isStopArea) {
      final area = await TransitStopArea.db.findFirstRow(
        session,
        where: (t) => t.externalId.equals(gid),
      );
      return StopMetadata(
        name: area?.name ?? gid,
        municipality: area?.municipality,
      );
    }

    final point = await TransitStopPoint.db.findFirstRow(
      session,
      where: (t) => t.externalId.equals(gid),
    );
    TransitStopArea? area;
    if (point != null) {
      area = await TransitStopArea.db.findById(session, point.stopAreaId);
    }
    return StopMetadata(
      name: point?.name ?? gid,
      // Lets the UI jump from a platform to all departures of its stop area.
      stopAreaGid: area?.externalId,
      municipality: area?.municipality,
      platform: point?.designation ?? point?.platform,
    );
  }

  static DepartureItem? _departureFromJson(Map<String, dynamic> json) {
    final serviceJourney = _map(json['serviceJourney']);
    final line = _map(serviceJourney?['line']);
    final directionDetails = _map(serviceJourney?['directionDetails']);
    final stopPoint = _map(json['stopPoint']);
    final realtimeStopPoint = _map(json['realtimeStopPoint']);
    final occupancy = _map(json['occupancy']);

    final designation =
        _string(line?['designation']) ?? _string(line?['shortName']);
    final plannedTime = _dateTime(json['plannedTime']);
    if (designation == null || plannedTime == null) return null;

    return DepartureItem(
      serviceJourneyGid: _string(serviceJourney?['gid']) ?? '',
      lineDesignation: designation,
      lineShortName: _string(line?['shortName']) ?? designation,
      lineName: _string(line?['name']),
      destination:
          _string(directionDetails?['shortDirection']) ??
          _string(serviceJourney?['direction']) ??
          _string(directionDetails?['fullDirection']) ??
          '',
      via: _string(directionDetails?['via']),
      platform:
          _string(realtimeStopPoint?['platform']) ??
          _string(stopPoint?['platform']),
      plannedTime: plannedTime,
      estimatedTime:
          _dateTime(json['estimatedTime']) ??
          _dateTime(json['estimatedOtherwisePlannedTime']),
      isCancelled: json['isCancelled'] == true,
      backgroundColor: _string(line?['backgroundColor']) ?? _defaultLineColor,
      foregroundColor:
          _string(line?['foregroundColor']) ?? _defaultForegroundColor,
      borderColor: _string(line?['borderColor']),
      transportMode: _string(line?['transportMode']),
      occupancyLevel: _string(occupancy?['level']),
      // Handles for the details call behind the timeline view.
      detailsReference: _string(json['detailsReference']),
      stopPointGid: _string(stopPoint?['gid']),
    );
  }

  static _ResolvedShape _resolved(
    TransitRoute route,
    TransitRouteShape shape,
    DepartureItem item, {
    String? nextStop,
  }) {
    return _ResolvedShape(
      routeId: route.id ?? 0,
      shortName: route.shortName,
      destination: shape.headsign ?? item.destination,
      transportMode: route.transportMode,
      color: route.backgroundColor ?? _defaultLineColor,
      foregroundColor: route.foregroundColor ?? _defaultForegroundColor,
      geometry: shape.geometryGeoJson,
      nextStop: nextStop,
    );
  }

  static String _featureCollection(Iterable<_ResolvedShape> shapes) {
    final features = <Map<String, dynamic>>[];
    for (final shape in shapes) {
      Object? geometry;
      try {
        geometry = jsonDecode(shape.geometry);
      } catch (_) {
        continue;
      }
      features.add({
        'type': 'Feature',
        'geometry': geometry,
        'properties': {
          'routeId': shape.routeId,
          'shortName': shape.shortName,
          'destination': shape.destination,
          'transportMode': shape.transportMode,
          'color': shape.color,
          'foregroundColor': shape.foregroundColor,
          'nextStop': shape.nextStop,
        },
      });
    }
    return jsonEncode({'type': 'FeatureCollection', 'features': features});
  }

  static bool _isFresh(DateTime? cachedAt) {
    if (cachedAt == null) return false;
    return DateTime.now().toUtc().difference(cachedAt) < _routeTtl;
  }

  static String _routeKey(String line, String destination) =>
      '$line\u0000$destination';

  static Map<String, dynamic>? _map(Object? value) =>
      value is Map<String, dynamic> ? value : null;

  static String? _string(Object? value) {
    final text = value as String?;
    return (text == null || text.isEmpty) ? null : text;
  }

  static DateTime? _dateTime(Object? value) {
    final text = value as String?;
    return text == null ? null : DateTime.tryParse(text);
  }
}

/// Stop identity resolved from the local database, used for the response
/// header while the departures themselves come from upstream.
class StopMetadata {
  const StopMetadata({
    required this.name,
    this.stopAreaGid,
    this.municipality,
    this.platform,
  });

  final String name;

  /// Parent stop area, set for stop points only: the UI links the title to it.
  final String? stopAreaGid;
  final String? municipality;
  final String? platform;
}

/// A departure chosen to represent one (line, destination) pair when fetching
/// the journey details.
class _PendingRoute {
  const _PendingRoute({
    required this.item,
    required this.detailsReference,
    required this.stopPointGid,
    required this.lineGid,
  });

  final DepartureItem item;
  final String detailsReference;
  final String stopPointGid;
  final String? lineGid;
}

/// The two things a journey-details call yields for one line pair.
class _JourneyInfo {
  const _JourneyInfo({this.geometry, this.nextStop});

  final String? geometry;
  final String? nextStop;
}

/// A route shape ready to be emitted as a GeoJSON feature.
class _ResolvedShape {
  const _ResolvedShape({
    required this.routeId,
    required this.shortName,
    required this.destination,
    required this.transportMode,
    required this.color,
    required this.foregroundColor,
    required this.geometry,
    this.nextStop,
  });

  final int routeId;
  final String shortName;
  final String destination;
  final String transportMode;
  final String color;
  final String foregroundColor;
  final String geometry;

  /// Known only once the journey details have been read; null before that.
  final String? nextStop;
}
