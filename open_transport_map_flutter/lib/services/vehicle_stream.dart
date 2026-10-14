import 'dart:async';

import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:open_transport_map_client/open_transport_map_client.dart';

import '../client.dart';

/// Bounds-scoped subscription to `vehiclePositions.watchVehicles`.
///
/// The endpoint relays only the vehicles inside the requested box, so the feed
/// follows the viewport instead of streaming the whole region. Opening a feed
/// costs a fresh upstream snapshot and a reconnect, so the requested box is
/// [padding] larger than the viewport: the live subscription is kept while the
/// viewport stays inside it, and only replaced once the user pans or zooms past
/// that slack. [subscribedBounds] reports the box the live feed covers, so
/// callers can drop vehicles left over from an earlier viewport.
class VehicleStream {
  VehicleStream({
    required this.onConnect,
    required this.onDelta,
    required this.onError,
    required this.onDone,
    this.padding = 0.35,
    this.debounce = const Duration(milliseconds: 700),
    this.shrinkRatio = 0.25,
  });

  /// Called whenever a new upstream feed is opened.
  final void Function() onConnect;

  /// Deltas from the live feed.
  final void Function(VehicleDelta delta) onDelta;

  /// The live feed failed. The subscription is dropped; the next [follow] or
  /// [restart] opens a fresh one.
  final void Function(Object error) onError;

  /// The live feed ended.
  final void Function() onDone;

  /// Margin requested around the viewport, as a fraction of its size.
  final double padding;

  /// How long the viewport must settle before a replacement feed is opened.
  final Duration debounce;

  /// Replace the feed once the viewport needs less than this fraction of the
  /// area already covered, so zooming in does not keep streaming a wide box.
  final double shrinkRatio;

  StreamSubscription<VehicleDelta>? _feed;
  Timer? _timer;
  LatLngBounds? _viewport;
  LatLngBounds? _subscribed;
  int _generation = 0;
  bool _disposed = false;

  /// Box the live feed covers, or null when no feed is open.
  LatLngBounds? get subscribedBounds => _subscribed;

  /// Points the subscription at [viewport]. Keeps the current feed while the
  /// padded viewport still fits inside it; otherwise replaces it, after
  /// [debounce] of quiet.
  void follow(LatLngBounds viewport) {
    if (_disposed) return;
    _viewport = viewport;
    final target = _paddedViewport();
    if (target == null) return;
    if (_feed == null) {
      _open(target);
      return;
    }
    if (!_needsReopen(target)) {
      _timer?.cancel();
      _timer = null;
      return;
    }
    _timer?.cancel();
    _timer = Timer(debounce, () {
      _timer = null;
      if (_disposed) return;
      final next = _paddedViewport();
      if (next != null && _needsReopen(next)) _open(next);
    });
  }

  /// Drops the current feed and opens a fresh one for the last viewport.
  void restart() {
    if (_disposed) return;
    _timer?.cancel();
    _timer = null;
    final target = _paddedViewport();
    if (target != null) _open(target);
  }

  void dispose() {
    _disposed = true;
    _timer?.cancel();
    _timer = null;
    _feed?.cancel();
    _feed = null;
  }

  void _open(LatLngBounds bounds) {
    _feed?.cancel();
    _subscribed = bounds;
    onConnect();
    final generation = ++_generation;
    _feed = client.vehiclePositions
        .watchVehicles(
          north: bounds.northeast.latitude,
          south: bounds.southwest.latitude,
          east: bounds.northeast.longitude,
          west: bounds.southwest.longitude,
        )
        .listen(
          onDelta,
          onError: (Object e) {
            _dropped(generation);
            onError(e);
          },
          onDone: () {
            _dropped(generation);
            onDone();
          },
        );
  }

  /// Clears the feed state, unless it was already replaced by a newer one.
  void _dropped(int generation) {
    if (generation != _generation) return;
    _feed = null;
    _subscribed = null;
  }

  LatLngBounds? _paddedViewport() {
    final viewport = _viewport;
    if (viewport == null) return null;
    final latSpan = (viewport.northeast.latitude - viewport.southwest.latitude)
        .abs();
    final lngSpan =
        (viewport.northeast.longitude - viewport.southwest.longitude).abs();
    final latPad = latSpan * padding;
    final lngPad = lngSpan * padding;
    return LatLngBounds(
      southwest: LatLng(
        (viewport.southwest.latitude - latPad).clamp(-90.0, 90.0).toDouble(),
        (viewport.southwest.longitude - lngPad).clamp(-180.0, 180.0).toDouble(),
      ),
      northeast: LatLng(
        (viewport.northeast.latitude + latPad).clamp(-90.0, 90.0).toDouble(),
        (viewport.northeast.longitude + lngPad).clamp(-180.0, 180.0).toDouble(),
      ),
    );
  }

  bool _needsReopen(LatLngBounds target) {
    final current = _subscribed;
    if (current == null) return true;
    if (!_covers(current, target)) return true;
    return _area(target) < _area(current) * shrinkRatio;
  }

  static bool _covers(LatLngBounds outer, LatLngBounds inner) =>
      inner.southwest.latitude >= outer.southwest.latitude &&
      inner.southwest.longitude >= outer.southwest.longitude &&
      inner.northeast.latitude <= outer.northeast.latitude &&
      inner.northeast.longitude <= outer.northeast.longitude;

  static double _area(LatLngBounds bounds) =>
      (bounds.northeast.latitude - bounds.southwest.latitude).abs() *
      (bounds.northeast.longitude - bounds.southwest.longitude).abs();
}
