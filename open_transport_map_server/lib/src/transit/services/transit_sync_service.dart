import 'dart:async';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../adapters/transit_adapter_registry.dart';
import '../adapters/vasttrafik/vasttrafik_v3_adapter.dart';

class TransitSyncService {
  /// Pause between batches of upstream API calls.
  static const _batchThrottle = Duration(milliseconds: 100);

  static Future<void> syncAgency(
    Session session,
    String agencyExternalId,
  ) async {
    // Route adapter diagnostics into the session log.
    final previousLogger = VasttrafikV3Adapter.logger;
    VasttrafikV3Adapter.logger = (message) => session.log(
      message,
      level: LogLevel.debug,
    );
    try {
      await _syncAgency(session, agencyExternalId);
    } finally {
      VasttrafikV3Adapter.logger = previousLogger;
    }
  }

  /// Registers the built-in adapters and loads Västtrafik OAuth credentials
  /// from the environment or `config/passwords.yaml`. Returns false (after
  /// logging) when no credentials are available, so callers never hit the
  /// upstream unauthenticated. Safe to call repeatedly.
  static Future<bool> ensureVasttrafikConfigured(Session session) async {
    registerBuiltInTransitAdapters();

    // OAuth credentials: env vars first, then Serverpod passwords
    // (config/passwords.yaml).
    try {
      VasttrafikV3Adapter.configureOAuth(
        clientId: _passwordOrEnv(session, 'VASTTRAFIK_CLIENT_ID'),
        clientSecret: _passwordOrEnv(session, 'VASTTRAFIK_CLIENT_SECRET'),
        authBaseUrl: _passwordOrEnv(
          session,
          'VASTTRAFIK_AUTH_BASE_URL',
        ),
      );
      final scope = _passwordOrEnv(session, 'VASTTRAFIK_SCOPE');
      if (scope != null && scope.isNotEmpty) {
        VasttrafikV3Adapter.configureOAuth(scope: scope);
      }
    } catch (e) {
      session.log(
        'Failed to configure Västtrafik OAuth: $e',
        level: LogLevel.warning,
      );
    }

    // Hard gate: never start upstream requests without credentials.
    if (!VasttrafikV3Adapter.hasCredentials) {
      final knownKeys = session.passwords.keys
          .where((k) => k.toLowerCase().contains('vasttrafik'))
          .toList();
      session.log(
        'Aborting transit request: no Västtrafik API credentials. Add '
        'vasttrafikClientId / vasttrafikClientSecret under development: in '
        'config/passwords.yaml, or set VASTTRAFIK_CLIENT_ID / '
        'VASTTRAFIK_CLIENT_SECRET in the environment. '
        'Existing vasttrafik-related password keys: ${knownKeys.isEmpty ? "none" : knownKeys.join(", ")}',
        level: LogLevel.warning,
      );
      return false;
    }
    return true;
  }

  static Future<void> _syncAgency(
    Session session,
    String agencyExternalId,
  ) async {
    final adapter = TransitAdapterRegistry.get(agencyExternalId);

    if (!await ensureVasttrafikConfigured(session)) return;

    session.log('Starting transit sync for agency: $agencyExternalId');

    final agencyDto = await adapter.fetchAgency();
    session.log('Agency DTO: ${agencyDto.name}');
    await _throttle();
    final zonesDto = await adapter.fetchZones();
    await _throttle();
    final stopAreasDto = await adapter.fetchStopAreas();
    await _throttle();
    final stopPointsDto = await adapter.fetchStopPoints();

    session.log(
      'Upstream fetched: zones=${zonesDto.length}, areas=${stopAreasDto.length}, '
      'points=${stopPointsDto.length} — writing to database',
    );

    await session.db.transaction((tx) async {
      // 1. Agency
      var agency = await TransitAgency.db.findFirstRow(
        session,
        where: (t) => t.externalId.equals(agencyDto.externalId),
        transaction: tx,
      );

      if (agency == null) {
        agency = await TransitAgency.db.insertRow(
          session,
          TransitAgency(
            externalId: agencyDto.externalId,
            name: agencyDto.name,
            timezone: agencyDto.timezone,
            countryCode: agencyDto.countryCode,
            city: agencyDto.city,
            syncedAt: DateTime.now(),
          ),
          transaction: tx,
        );
      } else {
        agency = agency.copyWith(
          name: agencyDto.name,
          timezone: agencyDto.timezone,
          countryCode: agencyDto.countryCode,
          city: agencyDto.city,
          syncedAt: DateTime.now(),
        );
        agency = await TransitAgency.db.updateRow(
          session,
          agency,
          transaction: tx,
        );
      }

      final agencyId = agency.id!;

      // 2. Zones (batched)
      final zoneIdByExt = <String, int>{};
      {
        final existingByExt = {
          for (final row in await TransitZone.db.find(
            session,
            where: (t) => t.agencyId.equals(agencyId),
            transaction: tx,
          ))
            row.externalId: row,
        };
        final toInsert = <TransitZone>[];
        final toUpdate = <TransitZone>[];
        for (final z in zonesDto) {
          final existing = existingByExt[z.externalId];
          if (existing == null) {
            toInsert.add(
              TransitZone(
                agencyId: agencyId,
                externalId: z.externalId,
                name: z.name,
                color: z.color,
                geometryGeoJson: z.geometryGeoJson,
              ),
            );
          } else {
            toUpdate.add(
              existing.copyWith(
                name: z.name,
                color: z.color,
                geometryGeoJson: z.geometryGeoJson,
              ),
            );
          }
        }
        final inserted = await TransitZone.db.insert(
          session,
          toInsert,
          ignoreConflicts: true,
          transaction: tx,
        );
        final updated = await TransitZone.db.update(
          session,
          toUpdate,
          transaction: tx,
        );
        for (final row in [...inserted, ...updated]) {
          zoneIdByExt[row.externalId] = row.id!;
        }
        for (final entry in existingByExt.entries) {
          zoneIdByExt.putIfAbsent(entry.key, () => entry.value.id!);
        }
        session.log(
          'Zones upserted: inserted=${inserted.length}, updated=${updated.length}',
        );
      }

      // 3. Stop Areas (Stations) — batched
      final stopAreaIdByExt = <String, int>{};
      {
        final existingByExt = {
          for (final row in await TransitStopArea.db.find(
            session,
            where: (t) => t.agencyId.equals(agencyId),
            transaction: tx,
          ))
            row.externalId: row,
        };
        final toInsert = <TransitStopArea>[];
        final toUpdate = <TransitStopArea>[];
        for (final sa in stopAreasDto) {
          final zoneId = sa.tariffZoneExternalId != null
              ? zoneIdByExt[sa.tariffZoneExternalId!]
              : null;
          final existing = existingByExt[sa.externalId];
          if (existing == null) {
            toInsert.add(
              TransitStopArea(
                agencyId: agencyId,
                externalId: sa.externalId,
                name: sa.name,
                latitude: sa.latitude,
                longitude: sa.longitude,
                municipality: sa.municipality,
                tariffZoneId: zoneId,
              ),
            );
          } else {
            toUpdate.add(
              existing.copyWith(
                name: sa.name,
                latitude: sa.latitude,
                longitude: sa.longitude,
                municipality: sa.municipality,
                tariffZoneId: zoneId,
              ),
            );
          }
        }
        final inserted = await TransitStopArea.db.insert(
          session,
          toInsert,
          ignoreConflicts: true,
          transaction: tx,
        );
        final updated = await TransitStopArea.db.update(
          session,
          toUpdate,
          transaction: tx,
        );
        for (final row in [...inserted, ...updated]) {
          stopAreaIdByExt[row.externalId] = row.id!;
        }
        for (final entry in existingByExt.entries) {
          stopAreaIdByExt.putIfAbsent(entry.key, () => entry.value.id!);
        }
        session.log(
          'Stop areas upserted: inserted=${inserted.length}, '
          'updated=${updated.length}',
        );
      }

      // 4. Stop Points (Platforms/Quays)
      for (final sp in stopPointsDto) {
        final parentAreaId = stopAreaIdByExt[sp.stopAreaExternalId];
        if (parentAreaId == null) continue;

        var existing = await TransitStopPoint.db.findFirstRow(
          session,
          where: (t) =>
              t.agencyId.equals(agencyId) & t.externalId.equals(sp.externalId),
          transaction: tx,
        );

        if (existing == null) {
          await TransitStopPoint.db.insertRow(
            session,
            TransitStopPoint(
              agencyId: agencyId,
              stopAreaId: parentAreaId,
              externalId: sp.externalId,
              name: sp.name,
              platform: sp.platform,
              latitude: sp.latitude,
              longitude: sp.longitude,
              designation: sp.designation,
            ),
            transaction: tx,
          );
        } else {
          await TransitStopPoint.db.updateRow(
            session,
            existing.copyWith(
              stopAreaId: parentAreaId,
              name: sp.name,
              platform: sp.platform,
              latitude: sp.latitude,
              longitude: sp.longitude,
              designation: sp.designation,
            ),
            transaction: tx,
          );
        }
      }
    });

    session.log(
      'Successfully completed transit sync for: $agencyExternalId '
      '(zones=${zonesDto.length}, areas=${stopAreasDto.length}, '
      'points=${stopPointsDto.length})',
    );
  }

  /// Reads a password from Serverpod passwords (any casing/math) with env
  /// fallback. Supports `VASTTRAFIK_CLIENT_ID`, `vasttrafik_client_id` and
  /// `vasttrafikClientId` spellings.
  static String? _passwordOrEnv(Session session, String key) {
    final env = Platform.environment[key];
    if (env != null && env.isNotEmpty) return env;
    final passwords = session.passwords;
    for (final candidate in [key, key.toLowerCase(), _toLowerCamel(key)]) {
      final value = passwords[candidate];
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }

  static String _toLowerCamel(String key) {
    final parts = key.toLowerCase().split('_');
    if (parts.length < 2) return key.toLowerCase();
    return parts.first +
        parts
            .skip(1)
            .map(
              (p) => p.isEmpty ? '' : '${p[0].toUpperCase()}${p.substring(1)}',
            )
            .join();
  }

  static Future<void> _throttle() => Future<void>.delayed(_batchThrottle);
}
