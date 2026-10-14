import 'dart:convert';
import 'dart:io';

import 'vasttrafik_v3_adapter.dart';

/// Client for the Västtrafik Planera Resa v4 API: departures at a stop point or
/// stop area, and per-departure journey details (calls, coordinates,
/// occupancy).
///
/// Shares the OAuth bearer token with [VasttrafikV3Adapter] through
/// [VasttrafikV3Adapter.accessToken], so no separate credentials are needed.
class VasttrafikPrV4Client {
  static const _baseDefault = 'https://ext-api.vasttrafik.se/pr/v4';
  static const _baseEnv = 'VASTTRAFIK_PR_API_BASE_URL';

  static const _timeout = Duration(seconds: 15);

  /// Logging hook — assigned by callers so diagnostics land in the session log.
  static void Function(String message) logger = (message) {};

  /// Departures at a stop area or stop point. Each entry carries
  /// `detailsReference` and `serviceJourney`, enough to render the list and to
  /// request the journey details that hold the route geometry.
  Future<List<Map<String, dynamic>>> fetchDepartures({
    required String gid,
    required bool isStopArea,
    int limit = 40,
  }) async {
    final path = isStopArea
        ? '/stop-areas/$gid/departures'
        : '/stop-points/$gid/departures';
    final decoded = await _get(path, {'limit': '$limit'});
    final results = decoded?['results'];
    if (results is! List) return const [];
    return results.whereType<Map<String, dynamic>>().toList();
  }

  /// Journey details for one departure, including the ordered
  /// `serviceJourneyCoordinates` used to draw the route line.
  Future<Map<String, dynamic>?> fetchDetails({
    required String stopPointGid,
    required String detailsReference,
  }) async {
    final path =
        '/stop-points/$stopPointGid/departures/'
        '${Uri.encodeComponent(detailsReference)}/details';
    return _get(path, {
      // Repeated query parameter; `includes` may be given multiple times.
      'includes': const [
        'servicejourneycalls',
        'servicejourneycoordinates',
        'occupancy',
      ],
    });
  }

  /// GETs [path] with a bearer token. Returns the decoded JSON object, or null
  /// on any failure (logged).
  Future<Map<String, dynamic>?> _get(
    String path,
    Map<String, dynamic> query,
  ) async {
    final token = await VasttrafikV3Adapter.accessToken();
    if (token == null) {
      logger('Vasttrafik PR v4 GET $path skipped: no access token');
      return null;
    }

    final base = Platform.environment[_baseEnv] ?? _baseDefault;
    final uri = Uri.parse('$base$path').replace(queryParameters: query);
    final httpClient = HttpClient()..connectionTimeout = _timeout;
    try {
      final request = await httpClient.getUrl(uri);
      request.headers.set('Accept', 'application/json');
      request.headers.set('Authorization', 'Bearer $token');
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode != 200) {
        logger(
          'Vasttrafik PR v4 GET $uri failed (${response.statusCode}): $body',
        );
        return null;
      }
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) {
        logger('Vasttrafik PR v4 GET $uri returned a non-object body');
        return null;
      }
      return decoded;
    } catch (e) {
      logger('Vasttrafik PR v4 GET $path failed: $e');
      return null;
    } finally {
      httpClient.close(force: true);
    }
  }
}
