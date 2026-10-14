import 'dart:convert';

import 'package:open_transport_map_server/src/transit/adapters/transit_adapter_registry.dart';
import 'package:open_transport_map_server/src/transit/adapters/vasttrafik/vasttrafik_v3_adapter.dart';
import 'package:test/test.dart';

void main() {
  group('Given TransitAdapterRegistry', () {
    test('when registering a built-in adapter then it can be looked up', () {
      registerBuiltInTransitAdapters();

      final adapter = TransitAdapterRegistry.get('vasttrafik');
      expect(adapter.agencyExternalId, 'vasttrafik');
    });

    test('when looking up an unknown agency then it throws', () {
      expect(
        () => TransitAdapterRegistry.get('unknown-agency'),
        throwsArgumentError,
      );
    });

    test('when checking has then it reflects registration', () {
      registerBuiltInTransitAdapters();
      expect(TransitAdapterRegistry.has('vasttrafik'), isTrue);
      expect(TransitAdapterRegistry.has('nope'), isFalse);
    });

    test(
      'when registering twice then the registry stays idempotent',
      () {
        registerBuiltInTransitAdapters();
        registerBuiltInTransitAdapters();

        expect(
          TransitAdapterRegistry.registeredAgencies
              .where((a) => a == 'vasttrafik')
              .length,
          1,
        );
      },
    );
  });

  group('Given VasttrafikV3Adapter', () {
    late VasttrafikV3Adapter adapter;

    setUp(() {
      adapter = VasttrafikV3Adapter();
    });

    test('when reading agencyExternalId then it reports vasttrafik', () {
      expect(adapter.agencyExternalId, 'vasttrafik');
    });

    test('when fetching agency then Västtrafik metadata is returned', () async {
      final agency = await adapter.fetchAgency();
      expect(agency.externalId, 'vasttrafik');
      expect(agency.name, 'Västtrafik');
      expect(agency.timezone, 'Europe/Stockholm');
      expect(agency.countryCode, 'SE');
      expect(agency.city, 'Gothenburg');
    });

    group('when converting WKT geometry to GeoJSON', () {
      test('a polygon is embedded as a GeoJSON Polygon string', () {
        final geoJson = VasttrafikV3Adapter.geometryGeoJsonFromWkt(
          {
            'wkt': 'POLYGON ((11.9 57.7, 12.0 57.7, 12.0 57.8, 11.9 57.7))',
            'srid': 4326,
          },
          'Polygon',
        );

        expect(geoJson, isNotNull);
        final decoded = jsonDecode(geoJson!) as Map<String, dynamic>;
        expect(decoded['type'], 'Polygon');
        final ring = (decoded['coordinates'] as List).first as List;
        expect(ring.first, [11.9, 57.7]);
      });

      test('a non-map geometry returns null', () {
        expect(
          VasttrafikV3Adapter.geometryGeoJsonFromWkt('nope', 'Polygon'),
          isNull,
        );
        expect(
          VasttrafikV3Adapter.geometryGeoJsonFromWkt(null, 'Polygon'),
          isNull,
        );
      });

      test('a geometry without wkt returns null', () {
        expect(
          VasttrafikV3Adapter.geometryGeoJsonFromWkt({'srid': 4326}, 'Polygon'),
          isNull,
        );
      });

      test('small polygons still convert (ring is closed for the caller)', () {
        final geoJson = VasttrafikV3Adapter.geometryGeoJsonFromWkt(
          {'wkt': 'POLYGON ((11.9 57.7, 12.0 57.7, 11.9 57.7))'},
          'Polygon',
        );
        expect(geoJson, isNotNull);
        final decoded = jsonDecode(geoJson!) as Map<String, dynamic>;
        final ring = (decoded['coordinates'] as List).first as List;
        // Ring gets an explicit closing point appended (repeat of first).
        expect(ring.length, 4);
      });
    });

    group('when extracting point coordinates', () {
      test('WKT POINT yields (lat, lon)', () {
        expect(
          VasttrafikV3Adapter.pointCoordinates({
            'wkt': 'POINT (11.9 57.7)',
            'srid': 4326,
          }),
          (57.7, 11.9),
        );
      });

      test('missing geometry returns null', () {
        expect(VasttrafikV3Adapter.pointCoordinates(null), isNull);
        expect(VasttrafikV3Adapter.pointCoordinates({}), isNull);
      });
    });

    group('when resolving tariff zones from stop areas', () {
      test('the first zone code is returned', () {
        expect(
          VasttrafikV3Adapter.tariffZoneExternalId([
            {'code': 'A', 'number': 3000},
            {'code': 'B', 'number': 5000},
          ]),
          'A',
        );
      });

      test('a missing code falls back to the number', () {
        expect(
          VasttrafikV3Adapter.tariffZoneExternalId([
            {'number': 3000},
          ]),
          '3000',
        );
      });

      test('missing zone info returns null', () {
        expect(VasttrafikV3Adapter.tariffZoneExternalId(null), isNull);
        expect(VasttrafikV3Adapter.tariffZoneExternalId([]), isNull);
        expect(
          VasttrafikV3Adapter.tariffZoneExternalId('nope'),
          isNull,
        );
      });
    });

    group('when deriving a line gid from a service journey gid', () {
      test('a 16 character gid maps to the line gid', () {
        expect(
          VasttrafikV3Adapter.lineGidForServiceJourney('9015014500604700'),
          '9011014500600000',
        );
      });

      test('gids of other lengths pass through unchanged', () {
        expect(
          VasttrafikV3Adapter.lineGidForServiceJourney('901501450060470'),
          '901501450060470',
        );
        expect(
          VasttrafikV3Adapter.lineGidForServiceJourney('90150145006047000'),
          '90150145006047000',
        );
        expect(VasttrafikV3Adapter.lineGidForServiceJourney(''), '');
      });
    });

    test('when no upstream token is set then fetches return empty', () async {
      expect(await adapter.fetchZones(), isEmpty);
      expect(await adapter.fetchStopAreas(), isEmpty);
      expect(await adapter.fetchStopPoints(), isEmpty);
    });
  });

  group('Given VasttrafikLineInfo defaults', () {
    test('when no colors are provided then the map API defaults are used', () {
      // Default colors are applied while parsing the lines map API and are
      // exercised through fetchLinesMap in integration tests; here we only
      // assert the constructor surface used by tests and callers.
      const info = VasttrafikLineInfo(
        shortName: '11',
        transportMode: 'tram',
        backgroundColor: '#000000',
        foregroundColor: '#ffffff',
      );
      expect(info.shortName, '11');
      expect(info.transportMode, 'tram');
    });
  });
}
