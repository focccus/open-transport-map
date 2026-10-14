import 'dart:async';

import 'package:open_transport_map_server/src/generated/protocol.dart';
import 'package:open_transport_map_server/src/transit/adapters/transit_provider_adapter.dart';
import 'package:open_transport_map_server/src/vehicles/vehicle_feed_hub.dart';
import 'package:test/test.dart';

/// Adapter whose feed is driven by the test, so the hub can be exercised
/// without touching the network.
class _FakeAdapter implements TransitProviderAdapter {
  _FakeAdapter(this.agencyExternalId);

  @override
  final String agencyExternalId;

  final controller = StreamController<VehicleDelta>.broadcast();

  /// How many times the hub opened the upstream feed.
  int opens = 0;

  @override
  Stream<VehicleDelta> watchVehicles() {
    opens++;
    return controller.stream;
  }

  @override
  Future<AgencyDto> fetchAgency() => throw UnimplementedError();

  @override
  Future<List<ZoneDto>> fetchZones() => throw UnimplementedError();

  @override
  Future<List<StopAreaDto>> fetchStopAreas() => throw UnimplementedError();

  @override
  Future<List<StopPointDto>> fetchStopPoints() => throw UnimplementedError();

  @override
  Future<List<RouteDto>> fetchRoutes() => throw UnimplementedError();

  @override
  Future<List<RouteShapeDto>> fetchRouteShapes(String routeExternalId) =>
      throw UnimplementedError();
}

VehiclePosition _vehicle(String id, double latitude, double longitude) =>
    VehiclePosition(
      vehicleId: id,
      timestamp: DateTime.utc(2026),
      latitude: latitude,
      longitude: longitude,
    );

List<String> _ids(VehicleDelta delta) => [
  for (final v in delta.updated) v.vehicleId,
];

void main() {
  group('Given a VehicleFeedHub', () {
    late VehicleFeedHub hub;
    late _FakeAdapter adapter;

    setUp(() {
      hub = VehicleFeedHub();
      adapter = _FakeAdapter('fake');
    });

    test('when two clients watch different boxes '
        'then one feed serves both, scoped per box', () async {
      final north = <VehicleDelta>[];
      final south = <VehicleDelta>[];
      final northSub = hub
          .watch(adapter: adapter, north: 60, south: 50, east: 20, west: 10)
          .listen(north.add);
      final southSub = hub
          .watch(adapter: adapter, north: -50, south: -60, east: 20, west: 10)
          .listen(south.add);
      await pumpEventQueue();

      adapter.controller.add(
        VehicleDelta(
          updated: [_vehicle('north-1', 55, 15), _vehicle('south-1', -55, 15)],
          removed: const [],
        ),
      );
      await pumpEventQueue();

      expect(adapter.opens, 1);
      expect(_ids(north.last), ['north-1']);
      expect(_ids(south.last), ['south-1']);

      await northSub.cancel();
      await southSub.cancel();
    });

    test(
      'when a client connects late '
      'then it is primed with the vehicles already known in its box',
      () async {
        final first = hub
            .watch(adapter: adapter, north: 60, south: 50, east: 20, west: 10)
            .listen((_) {});
        await pumpEventQueue();
        adapter.controller.add(
          VehicleDelta(
            updated: [
              _vehicle('in-box', 55, 15),
              _vehicle('elsewhere', -55, 15),
            ],
            removed: const [],
          ),
        );
        await pumpEventQueue();

        final primed = <VehicleDelta>[];
        final late = hub
            .watch(adapter: adapter, north: 60, south: 50, east: 20, west: 10)
            .listen(primed.add);
        await pumpEventQueue();

        expect(_ids(primed.first), ['in-box']);

        await first.cancel();
        await late.cancel();
      },
    );

    test(
      'when a vehicle is removed then the removal reaches every client',
      () async {
        final first = <VehicleDelta>[];
        final second = <VehicleDelta>[];
        final firstSub = hub
            .watch(adapter: adapter, north: 60, south: 50, east: 20, west: 10)
            .listen(first.add);
        final secondSub = hub
            .watch(adapter: adapter, north: 60, south: 50, east: 20, west: 10)
            .listen(second.add);
        await pumpEventQueue();

        adapter.controller.add(
          VehicleDelta(updated: [_vehicle('gone', 55, 15)], removed: const []),
        );
        await pumpEventQueue();
        adapter.controller.add(
          VehicleDelta(updated: const [], removed: const ['gone']),
        );
        await pumpEventQueue();

        expect(first.last.removed, ['gone']);
        expect(second.last.removed, ['gone']);
        expect(_ids(first.last), isEmpty);
        expect(_ids(second.last), isEmpty);

        await firstSub.cancel();
        await secondSub.cancel();
      },
    );
  });
}
