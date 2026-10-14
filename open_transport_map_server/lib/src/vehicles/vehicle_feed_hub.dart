import 'dart:async';

import '../generated/protocol.dart';
import '../transit/adapters/transit_provider_adapter.dart';

/// One upstream vehicle feed per agency, shared by every connected client.
///
/// The upstream SSE feed is costly to open: OAuth, the line-metadata fetch and
/// a full snapshot. Opening one per client (and so one per viewport) multiplies
/// that cost and the upstream load. The hub instead keeps a single subscription
/// covering the provider's whole service area, remembers the latest position of
/// every vehicle it reports, and forwards to each client only the vehicles
/// inside that client's viewport.
class VehicleFeedHub {
  /// A hub with its own set of feeds. The server uses [instance].
  VehicleFeedHub();

  /// The process-wide hub, holding one feed per agency.
  static final VehicleFeedHub instance = VehicleFeedHub();

  final Map<String, _AgencyFeed> _feeds = {};

  /// Vehicles inside the given box, as a stream that also carries the later
  /// deltas for that box. A new subscriber is primed with the vehicles already
  /// known inside it, so it does not wait for the next upstream event.
  Stream<VehicleDelta> watch({
    required TransitProviderAdapter adapter,
    required double north,
    required double south,
    required double east,
    required double west,
  }) {
    final feed = _feeds.putIfAbsent(
      adapter.agencyExternalId,
      () => _AgencyFeed(adapter),
    );
    return feed.addClient(_Bounds(north, south, east, west));
  }
}

/// A client's viewport.
class _Bounds {
  const _Bounds(this.north, this.south, this.east, this.west);

  final double north;
  final double south;
  final double east;
  final double west;

  bool contains(VehiclePosition v) =>
      v.latitude >= south &&
      v.latitude <= north &&
      v.longitude >= west &&
      v.longitude <= east;
}

/// The shared upstream feed for one agency, plus its subscribers.
class _AgencyFeed {
  _AgencyFeed(this._adapter);

  static const _retryDelay = Duration(seconds: 5);

  final TransitProviderAdapter _adapter;

  /// Latest position of every vehicle the feed has reported, whole service area.
  final Map<String, VehiclePosition> _state = {};
  final Set<_ClientFeed> _clients = {};
  StreamSubscription<VehicleDelta>? _subscription;
  Timer? _retry;

  Stream<VehicleDelta> addClient(_Bounds bounds) {
    late final _ClientFeed client;
    client = _ClientFeed(bounds, onCancelled: () => _clients.remove(client));
    _clients.add(client);
    client.add(
      VehicleDelta(
        updated: [
          for (final v in _state.values)
            if (bounds.contains(v)) v,
        ],
        removed: const [],
      ),
    );
    _ensureRunning();
    return client.stream;
  }

  void _ensureRunning() {
    if (_subscription != null || _clients.isEmpty) return;
    _subscription = _adapter.watchVehicles().listen(
      _onDelta,
      onError: _onFailure,
      onDone: _onFailure,
    );
  }

  void _onDelta(VehicleDelta delta) {
    for (final id in delta.removed) {
      _state.remove(id);
    }
    for (final vehicle in delta.updated) {
      _state[vehicle.vehicleId] = vehicle;
    }
    for (final client in _clients.toList()) {
      client.forward(delta);
    }
  }

  /// The upstream feed ended or failed. Keep serving from what is known and
  /// retry, unless nobody is listening any more.
  void _onFailure([Object? _]) {
    _subscription?.cancel();
    _subscription = null;
    if (_clients.isEmpty || _retry != null) return;
    _retry = Timer(_retryDelay, () {
      _retry = null;
      _ensureRunning();
    });
  }
}

/// One client's viewport-filtered view of the shared feed.
class _ClientFeed {
  _ClientFeed(this._bounds, {required void Function() onCancelled})
    : _controller = StreamController<VehicleDelta>(onCancel: onCancelled);

  final _Bounds _bounds;
  final StreamController<VehicleDelta> _controller;

  Stream<VehicleDelta> get stream => _controller.stream;

  void add(VehicleDelta delta) {
    if (!_controller.isClosed) _controller.add(delta);
  }

  /// Forwards the delta, keeping only the vehicles inside this client's box.
  void forward(VehicleDelta delta) {
    final updated = [
      for (final vehicle in delta.updated)
        if (_bounds.contains(vehicle)) vehicle,
    ];
    if (updated.isEmpty && delta.removed.isEmpty) return;
    add(VehicleDelta(updated: updated, removed: delta.removed));
  }
}
