import 'package:flutter/material.dart';
import 'package:open_transport_map_client/open_transport_map_client.dart';

/// Vehicle types the view options can show or hide.
///
/// Classification leans on the line's upstream `transportMode` because the line
/// number alone is ambiguous: buses and trams share the numbers 1-14, and the
/// tram `X` collides with the `X1`-`X90` express buses.
enum VehicleKind {
  bus('Bus', Icons.directions_bus_outlined),
  metroBus('Metrobus', Icons.directions_bus),
  expressBus('Express bus', Icons.airport_shuttle),
  tram('Tram', Icons.tram),
  train('Train', Icons.train),
  boat('Boat', Icons.directions_boat);

  const VehicleKind(this.label, this.icon);

  final String label;
  final IconData icon;
}

final _twoDigits = RegExp(r'^\d{2}$');
final _boatNumber = RegExp(r'^28\d$');

/// Classifies a vehicle for the type filter.
///
/// Uses the relayed transport mode when present and falls back to short-name
/// patterns (`TÅG`, `BÅT`, `28x`) when the line metadata is missing.
VehicleKind classifyVehicle(VehiclePosition v) {
  final mode = (v.lineTransportMode ?? '').trim().toLowerCase();
  final short = (v.lineShortName ?? '').trim();
  final lower = short.toLowerCase();

  switch (mode) {
    case 'train':
      return VehicleKind.train;
    case 'tram':
      return VehicleKind.tram;
    case 'ferry':
      return VehicleKind.boat;
  }

  if (mode.isEmpty) {
    if (lower.contains('tåg')) return VehicleKind.train;
    if (lower == 'båt' || _boatNumber.hasMatch(short)) return VehicleKind.boat;
  }

  // Road modes (bus, taxi) and anything unrecognised: split by short name.
  // Taxis run bus routes with the same yellow branding, so they count as bus.
  if (short.length > 1 && lower.startsWith('x')) return VehicleKind.expressBus;
  if (_twoDigits.hasMatch(short)) return VehicleKind.metroBus;
  return VehicleKind.bus;
}

/// User-configurable map view settings, applied live from the options sheet.
@immutable
class VehicleViewOptions {
  const VehicleViewOptions({
    this.kinds = _allKinds,
    this.clustering = true,
    this.clusterMinPoints = defaultClusterMinPoints,
    this.animations = true,
    this.animationZoom = defaultAnimationZoom,
    this.maxAnimatedVehicles = defaultMaxAnimatedVehicles,
  });

  static const _allKinds = {
    VehicleKind.bus,
    VehicleKind.metroBus,
    VehicleKind.expressBus,
    VehicleKind.tram,
    VehicleKind.train,
    VehicleKind.boat,
  };

  static const defaultClusterMinPoints = 20;
  static const minClusterMinPoints = 2;
  static const maxClusterMinPoints = 100;

  static const defaultAnimationZoom = 10.0;
  static const minAnimationZoom = 8.0;
  static const maxAnimationZoom = 18.0;

  static const defaultMaxAnimatedVehicles = 500;
  static const minAnimatedVehiclesLimit = 5;
  static const maxAnimatedVehiclesLimit = 2000;

  /// Types drawn on the map. Filtering is applied to the GeoJSON source, so
  /// cluster counts reflect it too.
  final Set<VehicleKind> kinds;

  /// Whether nearby vehicles merge into count bubbles.
  final bool clustering;

  /// Fewest vehicles in one spot before they cluster.
  final int clusterMinPoints;

  /// Whether markers animate along the segment between updates.
  final bool animations;

  /// Zoom at which animated markers take over from clusters and dots.
  final double animationZoom;

  /// Most animated markers drawn at once; the vehicles nearest the viewport
  /// center win.
  final int maxAnimatedVehicles;

  bool get showsAllKinds => kinds.length == VehicleKind.values.length;

  bool showsKind(VehicleKind kind) => kinds.contains(kind);

  VehicleViewOptions withKind(VehicleKind kind, bool enabled) {
    final next = {...kinds};
    if (enabled) {
      next.add(kind);
    } else {
      next.remove(kind);
    }
    return copyWith(kinds: next);
  }

  VehicleViewOptions copyWith({
    Set<VehicleKind>? kinds,
    bool? clustering,
    int? clusterMinPoints,
    bool? animations,
    double? animationZoom,
    int? maxAnimatedVehicles,
  }) {
    return VehicleViewOptions(
      kinds: kinds ?? this.kinds,
      clustering: clustering ?? this.clustering,
      clusterMinPoints: clusterMinPoints ?? this.clusterMinPoints,
      animations: animations ?? this.animations,
      animationZoom: animationZoom ?? this.animationZoom,
      maxAnimatedVehicles: maxAnimatedVehicles ?? this.maxAnimatedVehicles,
    );
  }

  /// True when both configurations need the same map source and layers.
  /// `cluster` and `maxzoom` are creation-time properties, so a change here
  /// means the layers have to be rebuilt rather than updated in place. The
  /// animated vehicle cap is excluded: it only affects symbol selection.
  bool sameLayers(VehicleViewOptions other) =>
      clustering == other.clustering &&
      clusterMinPoints == other.clusterMinPoints &&
      animations == other.animations &&
      animationZoom == other.animationZoom;
}
