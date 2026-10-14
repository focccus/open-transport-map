import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'services/transit_departure_service.dart';
import 'services/transit_sync_service.dart';

class TransitEndpoint extends Endpoint {
  /// Fetches station hubs / interchange complexes within the bounding box.
  /// Intended for low and medium map zoom levels (< 13.5).
  Future<List<TransitStopArea>> getStopAreasInBounds(
    Session session, {
    required double north,
    required double south,
    required double east,
    required double west,
    String? agencyExternalId,
  }) async {
    return TransitStopArea.db.find(
      session,
      where: (t) =>
          t.latitude.between(south, north) & t.longitude.between(west, east),
    );
  }

  /// Searches stop areas by name in the local database.
  ///
  /// Matches case-insensitively, prioritizing prefix matches over substring matches.
  Future<List<TransitStopArea>> searchStopAreas(
    Session session, {
    required String query,
    int? limit,
    String? agencyExternalId,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return <TransitStopArea>[];

    final effectiveLimit = (limit ?? 20).clamp(1, 100);
    final escaped = trimmed
        .replaceAll(r'\', r'\\')
        .replaceAll('%', r'\%')
        .replaceAll('_', r'\_');

    final results = await TransitStopArea.db.find(
      session,
      where: (t) => t.name.ilike('%$escaped%'),
      limit: effectiveLimit * 3 > 100 ? effectiveLimit * 3 : 100,
    );

    final lowerQuery = trimmed.toLowerCase();
    results.sort((a, b) {
      final aName = a.name.toLowerCase();
      final bName = b.name.toLowerCase();
      final aExact = aName == lowerQuery;
      final bExact = bName == lowerQuery;
      if (aExact != bExact) return aExact ? -1 : 1;

      final aPrefix = aName.startsWith(lowerQuery);
      final bPrefix = bName.startsWith(lowerQuery);
      if (aPrefix != bPrefix) return aPrefix ? -1 : 1;

      final aWordPrefix = aName
          .split(RegExp(r'\s+'))
          .any((w) => w.startsWith(lowerQuery));
      final bWordPrefix = bName
          .split(RegExp(r'\s+'))
          .any((w) => w.startsWith(lowerQuery));
      if (aWordPrefix != bWordPrefix) return aWordPrefix ? -1 : 1;

      return aName.compareTo(bName);
    });

    return results.take(effectiveLimit).toList();
  }

  /// Every stop area, ordered by id, for the client's local stop cache. Paged
  /// so the client pulls the list in batches instead of one large response.
  ///
  /// Stops change rarely, so the client re-syncs on this rather than on every
  /// search.
  Future<List<TransitStopArea>> listStopAreas(
    Session session, {
    int limit = 500,
    int offset = 0,
    String? agencyExternalId,
  }) async {
    return TransitStopArea.db.find(
      session,
      orderBy: (t) => t.id,
      limit: limit.clamp(1, 1000),
      offset: offset < 0 ? 0 : offset,
    );
  }

  /// Fetches physical boarding platforms / quays within the bounding box.
  /// Intended for street-level map zoom levels (>= 13.5).
  Future<List<TransitStopPoint>> getStopPointsInBounds(
    Session session, {
    required double north,
    required double south,
    required double east,
    required double west,
    String? agencyExternalId,
  }) async {
    return TransitStopPoint.db.find(
      session,
      where: (t) =>
          t.latitude.between(south, north) & t.longitude.between(west, east),
    );
  }

  /// Fetches route alignment shapes (GeoJSON LineStrings).
  Future<List<TransitRouteShape>> getRouteShapesInBounds(
    Session session, {
    required double north,
    required double south,
    required double east,
    required double west,
    String? agencyExternalId,
  }) async {
    return TransitRouteShape.db.find(session);
  }

  /// Departures at a stop area or stop point, fetched on demand, together with
  /// the GeoJSON of the routes serving it. Routes are cached in the database
  /// the first time they are seen and reused until they expire.
  ///
  /// Pass [isStopArea] true to query `/stop-areas/{gid}/departures`, false to
  /// query `/stop-points/{gid}/departures`.
  ///
  /// Two states are streamed: the departures (with any already-cached route
  /// shapes) first, then the full route GeoJSON once the remaining detail
  /// calls finish. The client renders the list without waiting for routes.
  ///
  /// Streaming also lets the server run the detail calls concurrently instead
  /// of blocking a single response on all of them.
  Stream<StopDeparturesResponse> watchStopDepartures(
    Session session, {
    required String gid,
    required bool isStopArea,
    String? agencyExternalId,
  }) {
    return TransitDepartureService.watchDepartures(
      session,
      gid: gid,
      isStopArea: isStopArea,
      agencyExternalId: agencyExternalId ?? 'vasttrafik',
    );
  }

  /// Ordered calls of the journey behind one departure, for the timeline view.
  ///
  /// [stopPointGid] and [detailsReference] are the handles carried by the
  /// `DepartureItem` the user tapped. Returns an empty list when the journey
  /// cannot be read.
  Future<List<ServiceJourneyCall>> getServiceJourneyCalls(
    Session session, {
    required String stopPointGid,
    required String detailsReference,
    String? agencyExternalId,
  }) {
    return TransitDepartureService.fetchServiceJourneyCalls(
      session,
      stopPointGid: stopPointGid,
      detailsReference: detailsReference,
    );
  }

  /// Fetches tariff / fare boundary zones with polygon boundaries.
  Future<List<TransitZone>> getZones(
    Session session, {
    String? agencyExternalId,
  }) async {
    return TransitZone.db.find(session);
  }

  /// Manually triggers transit infrastructure synchronization.
  Future<bool> triggerSync(
    Session session, {
    String? agencyExternalId,
  }) async {
    try {
      await TransitSyncService.syncAgency(
        session,
        agencyExternalId ?? 'vasttrafik',
      );
      return true;
    } catch (e, st) {
      session.log(
        'Failed to trigger transit sync: $e',
        level: LogLevel.error,
        stackTrace: st,
      );
      return false;
    }
  }
}
