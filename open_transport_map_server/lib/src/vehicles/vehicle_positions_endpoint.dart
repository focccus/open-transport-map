import 'dart:async';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../transit/adapters/transit_adapter_registry.dart';
import 'vehicle_feed_hub.dart';

/// Streams vehicle positions to clients as a [Stream] of [VehicleDelta].
///
/// The stream is viewport-scoped: the client passes its bounds, and
/// [VehicleFeedHub] forwards only the vehicles inside them, from one upstream
/// feed shared with every other client.
class VehiclePositionsEndpoint extends Endpoint {
  Stream<VehicleDelta> watchVehicles(
    Session session, {
    required double north,
    required double south,
    required double east,
    required double west,
    String? agencyExternalId,
  }) {
    final adapter = TransitAdapterRegistry.get(
      agencyExternalId ?? 'vasttrafik',
    );
    return VehicleFeedHub.instance.watch(
      adapter: adapter,
      north: north,
      south: south,
      east: east,
      west: west,
    );
  }
}
