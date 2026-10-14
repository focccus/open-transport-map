import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../../generated/protocol.dart';
import '../transit_adapter_registry.dart';
import '../transit_provider_adapter.dart';

/// Registers all built-in transit providers with [TransitAdapterRegistry].
/// Idempotent; call from server startup or before a sync.
void registerBuiltInTransitAdapters() {
  if (!TransitAdapterRegistry.has('vasttrafik')) {
    TransitAdapterRegistry.register(VasttrafikV3Adapter());
  }
}

/// Adapter for Västtrafik (Geography v3 + Vehicle Positions SSE).
///
/// Fetches live data from the Västtrafik ext-api Geography v3 (paginated,
/// WKT geometry requested with `srid=4326`). Sync aborts before any request
/// when credentials are missing; failures return empty results — no mock or
/// sample data is ever produced.
///
/// Credentials, in order of precedence:
/// 1. `VASTTRAFIK_API_TOKEN` env — a pre-fetched bearer token.
/// 2. `VASTTRAFIK_CLIENT_ID` + `VASTTRAFIK_CLIENT_SECRET` env (or the
///    `vasttrafikClientId` / `vasttrafikClientSecret` keys in Serverpod
///    `config/passwords.yaml`, passed through [configureOAuth]) — a
///    client-credentials grant against `ext-api.vasttrafik.se/token`.
/// The vehicle positions SSE and the lines map API need no auth.
class VasttrafikV3Adapter implements TransitProviderAdapter {
  static const _upstreamHost = 'labs-api.vasttrafik.se';
  static const _upstreamPath = '/api/vehicle-positions/stream';
  static const _linesHost = 'labs.vasttrafik.se';
  static const _linesPath = '/api/vehicle-positions-map/lines';

  /// Box the upstream feed is opened with. It covers everything Västtrafik
  /// reports; the per-client viewport is applied by `VehicleFeedHub`, so the
  /// upstream request does not follow any single client.
  static const _serviceAreaNorth = 62.614244861069395;
  static const _serviceAreaSouth = 52.737190372479326;
  static const _serviceAreaEast = 32.89552374897343;
  static const _serviceAreaWest = -9.929183282276576;

  /// Geography v3 base and OAuth configuration.
  static const _v3BaseDefault = 'https://ext-api.vasttrafik.se/geo/v3';
  static const _v3TokenEnv = 'VASTTRAFIK_API_TOKEN';
  static const _v3BaseEnv = 'VASTTRAFIK_API_BASE_URL';
  static const _clientIdEnv = 'VASTTRAFIK_CLIENT_ID';
  static const _clientSecretEnv = 'VASTTRAFIK_CLIENT_SECRET';
  static const _scopeEnv = 'VASTTRAFIK_SCOPE';
  static const _authBaseDefault = 'https://ext-api.vasttrafik.se';
  static const _authBaseEnv = 'VASTTRAFIK_AUTH_BASE_URL';

  /// Page size for paginated Geography endpoints.
  static const _pageSize = 1000;

  /// Logging hook — assigned by [TransitSyncService] so adapter diagnostics
  /// appear in the server session log.
  static void Function(String message) logger = (message) {};

  // --- OAuth client-credentials state ---
  static String? _configuredClientId;
  static String? _configuredClientSecret;
  static String? _configuredAuthBase;
  static String? _configuredScope;
  static String? _cachedToken;
  static DateTime? _tokenExpiresAt;

  /// Proactive refresh margin before real expiry.
  static const _tokenRefreshMargin = Duration(seconds: 60);

  @override
  String get agencyExternalId => 'vasttrafik';

  /// True when either a static token or client credentials are available.
  static bool get hasCredentials {
    final staticToken = Platform.environment[_v3TokenEnv];
    if (staticToken != null && staticToken.isNotEmpty) return true;
    final clientId =
        Platform.environment[_clientIdEnv] ?? _configuredClientId ?? '';
    final clientSecret =
        Platform.environment[_clientSecretEnv] ?? _configuredClientSecret ?? '';
    return clientId.isNotEmpty && clientSecret.isNotEmpty;
  }

  /// Configures OAuth client credentials (typically from
  /// `session.passwords`, i.e. Serverpod config/passwords.yaml). Call before
  /// the first sync when env vars are not used.
  static void configureOAuth({
    String? clientId,
    String? clientSecret,
    String? authBaseUrl,
    String? scope,
  }) {
    _configuredClientId = clientId ?? _configuredClientId;
    _configuredClientSecret = clientSecret ?? _configuredClientSecret;
    _configuredAuthBase = authBaseUrl ?? _configuredAuthBase;
    _configuredScope = scope ?? _configuredScope;
  }

  @override
  Future<AgencyDto> fetchAgency() async {
    return const AgencyDto(
      externalId: 'vasttrafik',
      name: 'Västtrafik',
      timezone: 'Europe/Stockholm',
      countryCode: 'SE',
      city: 'Gothenburg',
    );
  }

  @override
  Future<List<ZoneDto>> fetchZones() async {
    final page = await _pagedList(
      '/TariffZones',
      query: {'includeGeometry': 'true', 'srid': '4326'},
    );
    final zones = <ZoneDto>[];
    for (final entry in page) {
      final gid = entry['gid'] as String?;
      if (gid == null) continue;
      zones.add(
        ZoneDto(
          externalId: gid,
          name: entry['name'] as String? ?? gid,
          geometryGeoJson: geometryGeoJsonFromWkt(entry['geometry'], 'Polygon'),
        ),
      );
    }
    return zones;
  }

  @override
  Future<List<StopAreaDto>> fetchStopAreas() async {
    final page = await _pagedList(
      '/StopAreas',
      query: {
        'includeTariffZones': 'true',
        'includeMunicipality': 'true',
        'includeGeometry': 'true',
        'srid': '4326',
      },
    );
    final areas = <StopAreaDto>[];
    var skipped = 0;
    for (final entry in page) {
      final gid = entry['gid'] as String?;
      if (gid == null) {
        skipped++;
        continue;
      }
      final point = pointCoordinates(entry['geometry']);
      if (point == null) {
        logger('Vasttrafik stop area $gid has no usable geometry, skipping');
        skipped++;
        continue;
      }
      final municipality = entry['municipality'];
      areas.add(
        StopAreaDto(
          externalId: gid,
          name: entry['name'] as String? ?? gid,
          latitude: point.$1,
          longitude: point.$2,
          municipality: municipality is Map<String, dynamic>
              ? municipality['name'] as String?
              : null,
          tariffZoneExternalId: tariffZoneExternalId(entry['tariffZones']),
        ),
      );
    }
    logger('Vasttrafik stop areas kept ${areas.length}, skipped $skipped');
    return areas;
  }

  @override
  Future<List<StopPointDto>> fetchStopPoints() async {
    final page = await _pagedList(
      '/StopPoints',
      query: {
        'includeMunicipality': 'true',
        'includeGeometry': 'true',
        'srid': '4326',
      },
    );
    final points = <StopPointDto>[];
    var skipped = 0;
    for (final entry in page) {
      final gid = entry['gid'] as String?;
      final parentGid = entry['stopAreaGid'] as String?;
      if (gid == null || parentGid == null) {
        skipped++;
        continue;
      }
      final point = pointCoordinates(entry['geometry']);
      if (point == null) {
        logger('Vasttrafik stop point $gid has no usable geometry, skipping');
        skipped++;
        continue;
      }
      points.add(
        StopPointDto(
          externalId: gid,
          stopAreaExternalId: parentGid,
          name: entry['name'] as String? ?? gid,
          platform: entry['designation'] as String?,
          latitude: point.$1,
          longitude: point.$2,
          designation: entry['designation'] as String?,
        ),
      );
    }
    logger('Vasttrafik stop points kept ${points.length}, skipped $skipped');
    return points;
  }

  // Line ingestion is disabled for now.
  @override
  Future<List<RouteDto>> fetchRoutes() async {
    // Line ingestion is disabled for now. Route data comes back as an empty
    // list until lines can be ingested reliably; vehicle-position marker
    // colors still come from the lines map inside watchVehicles.
    return const [];
  }

  @override
  Future<List<RouteShapeDto>> fetchRouteShapes(String routeExternalId) async {
    // The Geography v3 API has no line/journey geometry endpoints; calling
    // the lines-map API per route would be unauthenticated guessing work.
    // Shapes are intentionally not produced here.
    return const [];
  }

  @override
  Stream<VehicleDelta> watchVehicles() async* {
    final lines = await fetchLinesMap();
    final httpClient = HttpClient();
    try {
      final uri = Uri.https(_upstreamHost, _upstreamPath, {
        'north': '$_serviceAreaNorth',
        'south': '$_serviceAreaSouth',
        'east': '$_serviceAreaEast',
        'west': '$_serviceAreaWest',
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
          final payload = data.toString();
          final name = eventName;
          eventName = '';
          data = StringBuffer();
          if (payload.isEmpty) continue;
          final delta = _parseEvent(name, payload, lines);
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

  // ---------- Geography v3 helpers ----------

  /// GETs a v3 endpoint with an OAuth bearer token. Returns the decoded JSON
  /// body or null on failure (logged).
  Future<Object?> _v3Api(String path, Map<String, String> query) async {
    final token = await accessToken();
    if (token == null) return null;

    final base = Platform.environment[_v3BaseEnv] ?? _v3BaseDefault;
    final uri = Uri.parse('$base$path').replace(queryParameters: query);
    final httpClient = HttpClient()
      ..connectionTimeout = const Duration(seconds: 15);
    try {
      final request = await httpClient.getUrl(uri);
      request.headers.set('Accept', 'application/json');
      request.headers.set('Authorization', 'Bearer $token');
      final response = await request.close();
      if (response.statusCode != 200) {
        final body = await response.transform(utf8.decoder).join();
        logger(
          'Vasttrafik v3 GET $uri failed (${response.statusCode}): $body',
        );
        return null;
      }
      final body = await response.transform(utf8.decoder).join();
      return jsonDecode(body);
    } catch (e) {
      logger('Vasttrafik v3 GET $path failed: $e');
      return null;
    } finally {
      httpClient.close(force: true);
    }
  }

  /// Walks a paginated Geography endpoint, following the "next" link until
  /// exhausted. A 404 past the last page is treated as end-of-list.
  Future<List<Map<String, dynamic>>> _pagedList(
    String path, {
    Map<String, String> query = const {},
    int maxPages = 100,
  }) async {
    final all = <Map<String, dynamic>>[];
    var offset = 0;
    for (var page = 0; page < maxPages; page++) {
      final decoded = await _v3Api(path, {
        ...query,
        'offset': '$offset',
        'limit': '$_pageSize',
      });
      if (decoded is! Map<String, dynamic>) break; // error already logged

      final items = _firstListValue(decoded) ?? const [];
      all.addAll(items.whereType<Map<String, dynamic>>());

      // End when the collection reports no next page or a short page.
      final links = decoded['links'];
      final nextLink = links is Map<String, dynamic>
          ? links['next'] as String?
          : null;
      final properties = decoded['properties'];
      final size = properties is Map<String, dynamic>
          ? (properties['size'] as num?)?.toInt() ?? 0
          : 0;
      if (size < _pageSize || nextLink == null) break;
      offset += size;
    }
    return all;
  }

  static List? _firstListValue(Map<String, dynamic> decoded) {
    for (final value in decoded.values) {
      if (value is List) return value;
    }
    return null;
  }

  /// Converts a Geometry v3 geometry object (`{wkt: ..., srid: ...}`) into a
  /// GeoJSON string of [kind] ('Point', 'LineString' or 'Polygon'). Assumes
  /// the WKT was requested with srid=4326 ([lon, lat] order).
  static String? geometryGeoJsonFromWkt(Object? geometry, String kind) {
    if (geometry is! Map<String, dynamic>) return null;
    final wkt = geometry['wkt'] as String?;
    if (wkt == null || wkt.isEmpty) return null;
    final matches = RegExp(r'-?\d+(?:\.\d+)?').allMatches(wkt).toList();
    final numbers = matches.map((m) => double.parse(m.group(0)!)).toList();
    if (numbers.length < 4 || numbers.length % 2 != 0) return null;

    final coordinates = <List<double>>[];
    for (var i = 0; i < numbers.length; i += 2) {
      // WKT is (X, Y) = (lon, lat).
      coordinates.add([numbers[i], numbers[i + 1]]);
    }

    switch (kind) {
      case 'Point':
        return jsonEncode({
          'type': 'Point',
          'coordinates': coordinates.first,
        });
      case 'LineString':
        return jsonEncode({'type': 'LineString', 'coordinates': coordinates});
      case 'Polygon':
        return jsonEncode({
          'type': 'Polygon',
          'coordinates': [coordinates..add(coordinates.first)],
        });
      default:
        return null;
    }
  }

  /// Extracts (lat, lon) from a `Point` geometry WKT; null when unusable.
  static (double, double)? pointCoordinates(Object? geometry) {
    if (geometry is! Map<String, dynamic>) return null;
    final wkt = geometry['wkt'] as String?;
    if (wkt == null || wkt.isEmpty) return null;
    final matches = RegExp(
      r'-?\d+(?:\.\d+)?',
    ).allMatches(wkt).map((m) => double.parse(m.group(0)!)).toList();
    if (matches.length < 2) return null;
    // WKT (X, Y) = (lon, lat).
    return (matches[1], matches[0]);
  }

  /// Returns the code of the first tariff zone in a stop-area entry's
  /// `tariffZones` list (e.g. 'A'), or null.
  static String? tariffZoneExternalId(Object? tariffZones) {
    if (tariffZones is! List || tariffZones.isEmpty) return null;
    final first = tariffZones.firstOrNull;
    if (first is! Map<String, dynamic>) return null;
    final code = first['code'] as String?;
    if (code?.isNotEmpty ?? false) return code;
    final number = first['number'] as num?;
    return number?.toString();
  }

  // ---------- OAuth ----------

  /// Returns a valid bearer token, fetching one via client-credentials grant
  /// when needed. Returns null when no credentials are available.
  ///
  /// Shared with other Västtrafik API clients (e.g. the Planera Resa v4
  /// departures client) so a single token is reused across endpoints.
  static Future<String?> accessToken() async {
    // 1. Pre-fetched static token.
    final staticToken = Platform.environment[_v3TokenEnv];
    if (staticToken != null && staticToken.isNotEmpty) {
      return _cachedToken = staticToken;
    }

    // 2. Client credentials from env / configureOAuth.
    var clientId = Platform.environment[_clientIdEnv];
    var clientSecret = Platform.environment[_clientSecretEnv];
    var authBase = Platform.environment[_authBaseEnv];
    var scope = Platform.environment[_scopeEnv];
    clientId ??= _configuredClientId;
    clientSecret ??= _configuredClientSecret;
    authBase ??= _configuredAuthBase;
    scope ??= _configuredScope;

    if (clientId == null || clientId.isEmpty) {
      return null;
    }
    if (clientSecret == null || clientSecret.isEmpty) {
      logger('Vasttrafik auth: clientId set but client secret missing');
      return null;
    }

    if (_cachedToken != null &&
        _tokenExpiresAt != null &&
        DateTime.now().isBefore(_tokenExpiresAt!)) {
      return _cachedToken;
    }

    final granted = await _fetchClientCredentialsToken(
      clientId,
      clientSecret,
      authBase ?? _authBaseDefault,
      scope,
    );
    if (granted == null) return null;
    final (token, expiresIn) = granted;
    _cachedToken = token;
    // Respect expires_in (up to 24 h per Västtrafik docs); refresh 60 s early.
    _tokenExpiresAt = expiresIn == null
        ? null
        : DateTime.now()
              .add(Duration(seconds: expiresIn))
              .subtract(_tokenRefreshMargin);
    if (expiresIn != null) {
      logger('Vasttrafik token cached until ${_tokenExpiresAt!}');
    }
    return token;
  }

  /// Returns the access token and its `expires_in` seconds (null when the
  /// upstream didn't report one).
  static Future<(String, int?)?> _fetchClientCredentialsToken(
    String clientId,
    String clientSecret,
    String authBase,
    String? scope,
  ) async {
    final uri = Uri.parse('$authBase/token');
    final httpClient = HttpClient()
      ..connectionTimeout = const Duration(seconds: 15);
    try {
      final request = await httpClient.postUrl(uri);
      final basic = base64Encode(utf8.encode('$clientId:$clientSecret'));
      request.headers.set(HttpHeaders.authorizationHeader, 'Basic $basic');
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        'application/x-www-form-urlencoded',
      );
      final bodyBuffer = StringBuffer('grant_type=client_credentials');
      if (scope != null && scope.isNotEmpty) {
        bodyBuffer.write('&scope=${Uri.encodeQueryComponent(scope)}');
      }
      request.add(utf8.encode(bodyBuffer.toString()));
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode != 200) {
        logger(
          'Vasttrafik OAuth token request returned ${response.statusCode}: '
          '$body',
        );
        return null;
      }
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) {
        logger('Vasttrafik OAuth token response is not a JSON object');
        return null;
      }
      final token = decoded['access_token'] as String?;
      if (token == null || token.isEmpty) {
        logger('Vasttrafik OAuth token response has no access_token: $body');
        return null;
      }
      logger('Vasttrafik OAuth token acquired via client-credentials grant');
      final expiresIn = (decoded['expires_in'] as num?)?.toInt();
      return (token, expiresIn);
    } catch (e, st) {
      logger('Vasttrafik OAuth token request failed: $e\n$st');
      return null;
    } finally {
      httpClient.close(force: true);
    }
  }

  // ---------- vehicle positions / lines helpers ----------

  /// Line metadata by line gid: shortName + colors for marker icons.
  Future<Map<String, VasttrafikLineInfo>> fetchLinesMap() async {
    final httpClient = HttpClient();
    try {
      final uri = Uri.https(_linesHost, _linesPath);
      final request = await httpClient.getUrl(uri);
      request.headers.set('Accept', 'application/json');
      final response = await request.close();
      if (response.statusCode != 200) {
        await response.drain<void>();
        logger('Västtrafik lines map returned ${response.statusCode}');
        return const {};
      }
      final body = await response.transform(utf8.decoder).join();
      final decoded = jsonDecode(body);
      if (decoded is! List) return const {};
      final lines = <String, VasttrafikLineInfo>{};
      for (final entry in decoded.whereType<Map<String, dynamic>>()) {
        final gid = entry['gid'] as String?;
        if (gid == null) continue;
        lines[gid] = VasttrafikLineInfo(
          shortName: entry['shortName'] as String? ?? '',
          transportMode: entry['transportMode'] as String? ?? '',
          backgroundColor: entry['backgroundColor'] as String? ?? '#1d4ed8',
          foregroundColor: entry['foregroundColor'] as String? ?? '#ffffff',
        );
      }
      return lines;
    } catch (_) {
      return const {};
    } finally {
      httpClient.close(force: true);
    }
  }

  VehicleDelta? _parseEvent(
    String eventName,
    String payload,
    Map<String, VasttrafikLineInfo> lines,
  ) {
    try {
      final decoded = jsonDecode(payload);
      if (eventName == 'snapshot' && decoded is List) {
        return VehicleDelta(
          updated: decoded
              .whereType<Map<String, dynamic>>()
              .map((j) => _vehicleFromJson(j, lines))
              .toList(),
          removed: [],
        );
      }
      if (decoded is Map<String, dynamic>) {
        final updated = (decoded['updated'] as List? ?? [])
            .whereType<Map<String, dynamic>>()
            .map((j) => _vehicleFromJson(j, lines))
            .toList();
        final removed = (decoded['removed'] as List? ?? [])
            .whereType<String>()
            .toList();
        return VehicleDelta(updated: updated, removed: removed);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  VehiclePosition _vehicleFromJson(
    Map<String, dynamic> json,
    Map<String, VasttrafikLineInfo> lines,
  ) {
    double? asDouble(Object? v) => (v as num?)?.toDouble();
    final serviceJourneyGid = json['serviceJourneyGid'] as String?;
    final line = serviceJourneyGid == null
        ? null
        : lines[lineGidForServiceJourney(serviceJourneyGid)];
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

  /// Derives the line gid from a service journey gid.
  static String lineGidForServiceJourney(String serviceJourneyGid) {
    if (serviceJourneyGid.length == 16) {
      return '${serviceJourneyGid.substring(0, 3)}1'
          '${serviceJourneyGid.substring(4, 12)}0000';
    }
    return serviceJourneyGid;
  }
}

class VasttrafikLineInfo {
  const VasttrafikLineInfo({
    required this.shortName,
    required this.transportMode,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String shortName;
  final String transportMode;
  final String backgroundColor;
  final String foregroundColor;
}
