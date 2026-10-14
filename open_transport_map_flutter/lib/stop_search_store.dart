import 'package:open_transport_map_client/open_transport_map_client.dart';
import 'package:serverpod_database/serverpod_database.dart';

import 'models/stop_search_result.dart';

/// Local stop search.
///
/// [CachedStopArea] is the synced half: every stop area the server knows about,
/// pulled down in pages and refetched on each sync. [RecentStopSearch] is the
/// local half: the queries the user last picked a stop from, kept on the device
/// only.
class StopSearchStore {
  StopSearchStore({required this.client, required this.session});

  final Client client;

  /// The local database, or null when it could not be opened. Without it the
  /// cache and the recent queries are unavailable and search uses the server.
  final ClientDatabaseSession? session;

  /// Page size when pulling the stops down.
  static const _pageSize = 500;

  /// Result cap, matching the server's own search.
  static const _resultLimit = 20;

  /// How many recent queries are kept.
  static const _recentLimit = 8;

  bool _syncing = false;

  /// Pulls every stop area into the local cache, a page at a time. Re-running
  /// refreshes names and positions of the stops already cached.
  Future<void> sync() async {
    final session = this.session;
    if (session == null || _syncing) return;
    _syncing = true;
    try {
      var offset = 0;
      while (true) {
        final page = await client.transit.listStopAreas(
          limit: _pageSize,
          offset: offset,
        );
        if (page.isEmpty) break;
        final now = DateTime.now();
        await CachedStopArea.db.upsert(
          session,
          [
            for (final area in page)
              CachedStopArea(
                externalId: area.externalId,
                name: area.name,
                latitude: area.latitude,
                longitude: area.longitude,
                municipality: area.municipality,
                syncedAt: now,
              ),
          ],
          conflictColumns: (t) => [t.externalId],
          updateColumns: (t) => [
            t.name,
            t.latitude,
            t.longitude,
            t.municipality,
            t.syncedAt,
          ],
        );
        if (page.length < _pageSize) break;
        offset += page.length;
      }
    } finally {
      _syncing = false;
    }
  }

  /// Whether the cache holds no stop at all, i.e. it has never synced.
  Future<bool> isEmpty() async {
    final session = this.session;
    if (session == null) return true;
    return await CachedStopArea.db.count(session) == 0;
  }

  /// Searches the cache, ranking like the server: exact name, then prefix, then
  /// a word prefix, then the rest, alphabetically.
  ///
  /// Falls back to the server while the cache is empty, so search works before
  /// the first sync finishes.
  Future<List<StopSearchResult>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];
    final session = this.session;
    if (session == null || await isEmpty()) return _searchServer(trimmed);

    final escaped = trimmed
        .replaceAll(r'\', r'\\')
        .replaceAll('%', r'\%')
        .replaceAll('_', r'\_');

    final rows = await CachedStopArea.db.find(
      session,
      where: (t) => t.name.ilike('%$escaped%'),
      limit: 100,
    );
    if (rows.isEmpty) return const [];

    final lower = trimmed.toLowerCase();
    rows.sort((a, b) {
      final aName = a.name.toLowerCase();
      final bName = b.name.toLowerCase();
      final aExact = aName == lower;
      final bExact = bName == lower;
      if (aExact != bExact) return aExact ? -1 : 1;

      final aPrefix = aName.startsWith(lower);
      final bPrefix = bName.startsWith(lower);
      if (aPrefix != bPrefix) return aPrefix ? -1 : 1;

      final aWord = aName.split(RegExp(r'\s+')).any((w) => w.startsWith(lower));
      final bWord = bName.split(RegExp(r'\s+')).any((w) => w.startsWith(lower));
      if (aWord != bWord) return aWord ? -1 : 1;

      return aName.compareTo(bName);
    });

    return [
      for (final row in rows.take(_resultLimit))
        StopSearchResult(
          externalId: row.externalId,
          name: row.name,
          latitude: row.latitude,
          longitude: row.longitude,
          municipality: row.municipality,
        ),
    ];
  }

  Future<List<StopSearchResult>> _searchServer(String query) async {
    final results = await client.transit.searchStopAreas(query: query);
    return [
      for (final stop in results)
        StopSearchResult(
          externalId: stop.externalId,
          name: stop.name,
          latitude: stop.latitude,
          longitude: stop.longitude,
          municipality: stop.municipality,
        ),
    ];
  }

  /// Records [query] as recently used, newest first. Re-searching the same text
  /// moves it back to the top instead of duplicating it.
  Future<void> recordSearch(String query) async {
    final session = this.session;
    if (session == null) return;
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    await RecentStopSearch.db.deleteWhere(
      session,
      where: (t) => t.query.equals(trimmed),
    );
    await RecentStopSearch.db.insert(
      session,
      [RecentStopSearch(query: trimmed, searchedAt: DateTime.now())],
      ignoreConflicts: true,
    );
  }

  /// The most recently picked queries, newest first.
  Future<List<String>> recentQueries() async {
    final session = this.session;
    if (session == null) return const [];
    final rows = await RecentStopSearch.db.find(
      session,
      orderBy: (t) => t.searchedAt.desc(),
      limit: _recentLimit,
    );
    return [for (final row in rows) row.query];
  }
}
