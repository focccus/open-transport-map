import 'package:flutter_test/flutter_test.dart';
import 'package:open_transport_map_client/open_transport_map_client.dart';
import 'package:open_transport_map_flutter/models/vehicle_view_options.dart';

/// Short names below are taken from the live map-lines API, so the classifier
/// is checked against real Västtrafik data rather than invented samples.
VehiclePosition _vehicle(String? mode, String? shortName) => VehiclePosition(
  vehicleId: 'v',
  timestamp: DateTime(2026),
  latitude: 57.7,
  longitude: 11.9,
  lineShortName: shortName,
  lineTransportMode: mode,
);

void main() {
  group('classifyVehicle by transport mode', () {
    test('train mode beats its short name', () {
      expect(
        classifyVehicle(_vehicle('train', 'TÅG')),
        VehicleKind.train,
      );
    });

    test('tram mode separates trams from buses sharing the same number', () {
      expect(classifyVehicle(_vehicle('tram', '11')), VehicleKind.tram);
      expect(classifyVehicle(_vehicle('bus', '11')), VehicleKind.metroBus);
    });

    test('the tram X is not an express bus', () {
      expect(classifyVehicle(_vehicle('tram', 'X')), VehicleKind.tram);
      expect(classifyVehicle(_vehicle('bus', 'X1')), VehicleKind.expressBus);
    });

    test('ferry mode is the boat type', () {
      expect(classifyVehicle(_vehicle('ferry', '281')), VehicleKind.boat);
      expect(classifyVehicle(_vehicle('ferry', 'BÅT')), VehicleKind.boat);
      expect(classifyVehicle(_vehicle('ferry', '999')), VehicleKind.boat);
    });

    test('buses and taxis share the bus type', () {
      expect(classifyVehicle(_vehicle('bus', '543')), VehicleKind.bus);
      expect(classifyVehicle(_vehicle('bus', '1')), VehicleKind.bus);
      expect(classifyVehicle(_vehicle('taxi', 'TAXI')), VehicleKind.bus);
      expect(classifyVehicle(_vehicle('taxi', '133')), VehicleKind.bus);
    });

    test('two digit bus numbers are metrobuses', () {
      expect(classifyVehicle(_vehicle('bus', '16')), VehicleKind.metroBus);
      expect(classifyVehicle(_vehicle('bus', '40')), VehicleKind.metroBus);
      expect(classifyVehicle(_vehicle('bus', '1')), VehicleKind.bus);
      expect(classifyVehicle(_vehicle('bus', '101')), VehicleKind.bus);
    });

    test('x prefixed buses are express buses', () {
      for (final name in ['X1', 'X6', 'X40', 'X76', 'X90']) {
        expect(classifyVehicle(_vehicle('bus', name)), VehicleKind.expressBus);
      }
      // Suffixed variants stay ordinary buses.
      expect(classifyVehicle(_vehicle('bus', '16X')), VehicleKind.bus);
      expect(classifyVehicle(_vehicle('bus', '1E')), VehicleKind.bus);
    });
  });

  group('classifyVehicle without relayed mode', () {
    test('falls back to short name patterns', () {
      expect(classifyVehicle(_vehicle(null, 'TÅG')), VehicleKind.train);
      expect(classifyVehicle(_vehicle(null, 'BÅT')), VehicleKind.boat);
      expect(classifyVehicle(_vehicle(null, '284')), VehicleKind.boat);
      expect(classifyVehicle(_vehicle(null, 'X3')), VehicleKind.expressBus);
      expect(classifyVehicle(_vehicle(null, '27')), VehicleKind.metroBus);
      expect(classifyVehicle(_vehicle(null, '543')), VehicleKind.bus);
      expect(classifyVehicle(_vehicle(null, null)), VehicleKind.bus);
    });
  });

  group('VehicleViewOptions', () {
    test('defaults match the documented behaviour', () {
      const options = VehicleViewOptions();
      expect(options.showsAllKinds, isTrue);
      expect(options.clustering, isTrue);
      expect(options.clusterMinPoints, 20);
      expect(options.animations, isTrue);
      expect(options.animationZoom, 10);
      expect(options.maxAnimatedVehicles, 500);
    });

    test('kinds toggle without disturbing other settings', () {
      const options = VehicleViewOptions(clustering: false);
      final without = options.withKind(VehicleKind.train, false);
      expect(without.showsKind(VehicleKind.train), isFalse);
      expect(without.showsKind(VehicleKind.bus), isTrue);
      expect(without.clustering, isFalse);
      expect(without.showsAllKinds, isFalse);
    });

    test('sameLayers only reports creation-time differences', () {
      const options = VehicleViewOptions();
      // Type filters are applied to the source data, not the layers.
      expect(
        options.sameLayers(options.withKind(VehicleKind.bus, false)),
        isTrue,
      );
      expect(options.sameLayers(options.copyWith(clustering: false)), isFalse);
      expect(
        options.sameLayers(options.copyWith(clusterMinPoints: 20)),
        isFalse,
      );
      expect(options.sameLayers(options.copyWith(animations: false)), isFalse);
      expect(options.sameLayers(options.copyWith(animationZoom: 15)), isFalse);
      // The animated vehicle cap only changes symbol selection.
      expect(
        options.sameLayers(options.copyWith(maxAnimatedVehicles: 12)),
        isTrue,
      );
    });
  });
}
