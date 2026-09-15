import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:open_transport_map_client/open_transport_map_client.dart';

import '../client.dart';
import '../models/vehicle_view_options.dart';
import '../widgets/vehicle_view_options_sheet.dart';

/// Live map of Västtrafik vehicle positions, relayed through the Serverpod
/// streaming endpoint `vehiclePositions.watchVehicles`.
///
/// Rendering strategy (perf):
/// - Low zoom: clustered circle layer only (GPU, one source update per event).
///   Individual dots are colored per line with the short name as label.
/// - High zoom (>= the animation zoom, user-configurable): animated arrow
///   symbols only (cluster and dot layers hide via maxzoom), capped at the
///   configured number of vehicles nearest the viewport center. Each animates
///   at its own speed derived from `speedKmh`, so slow vehicles crawl, fast
///   ones fly.
///
/// The top-left button opens a sheet for vehicle types, clustering, and
/// animation settings; see `VehicleViewOptions`.
///
/// Train lines (short name containing `tåg`) show a train pictogram instead of
/// the line number. The pictogram is a second, unrotated symbol so it stays
/// upright while the marker itself rotates to show heading.
///
/// The upstream stream follows the viewport with a debounce, so panning
/// shrinks the payload instead of streaming the whole country.
class VehicleMapScreen extends StatefulWidget {
  const VehicleMapScreen({super.key});

  @override
  State<VehicleMapScreen> createState() => _VehicleMapScreenState();
}

class _VehicleMapScreenState extends State<VehicleMapScreen>
    with SingleTickerProviderStateMixin {
  static final _initialBounds = LatLngBounds(
    southwest: LatLng(52.737190372479326, -9.929183282276576),
    northeast: LatLng(62.614244861069395, 32.89552374897343),
  );

  static const _arrowImageName = 'vehicle-arrow';

  /// Upright train pictogram, drawn on top of the marker body for train lines
  /// and inside the clustered dots at low zoom. Registered as SDF, so both
  /// places tint it with the line's foreground color.
  static const _trainGlyphImageName = 'vehicle-train-glyph';
  static const _clusterSourceId = 'vehicles-cluster';
  static const _clusterCirclesLayerId = 'vehicles-clusters';
  static const _clusterCountLayerId = 'vehicles-cluster-count';
  static const _dotLayerId = 'vehicles-dots';
  static const _dotLabelLayerId = 'vehicles-dot-labels';
  static const _trainDotLayerId = 'vehicles-train-icons';

  /// Animated markers are drawn from one GeoJSON source rather than as
  /// per-marker annotations: a source update moves every marker in a single
  /// platform call, where annotations cost one call each, per frame.
  static const _markerSourceId = 'vehicles-markers';
  static const _markerLayerId = 'vehicles-marker-icons';
  static const _markerGlyphLayerId = 'vehicles-marker-glyphs';

  // Roughly Gothenburg, where most Västtrafik vehicles are.
  /// Cluster radius in pixels.

  /// Cluster radius in pixels.
  static const _clusterRadius = 50.0;

  /// Scale of the 64px arrow image; ~35px on screen.
  static const _iconSize = 0.55;

  /// Scale of the 32px train glyph; ~12px, inside the 22px marker body.
  static const _trainGlyphSize = 0.38;

  /// Restart upstream stream at most this often while panning/zooming.
  static const _viewportDebounce = Duration(milliseconds: 800);

  /// Push at most one clustered source update per interval to the map.
  static const _sourceThrottle = Duration(milliseconds: 1000);

  /// Marker pushes are capped at ~30 Hz. Advancing state stays per-frame,
  /// but halving the platform calls keeps symbol motion from stuttering.
  static const _markerPushInterval = Duration(milliseconds: 33);

  // Roughly Gothenburg, where most Västtrafik vehicles are.
  static const _initialCamera = CameraPosition(
    target: LatLng(57.7089, 11.9746),
    zoom: 9,
  );

  final Map<String, _AnimatedVehicle> _vehicles = {};
  StreamSubscription<VehicleDelta>? _subscription;
  MapLibreMapController? _mapController;
  Ticker? _ticker;
  Duration _lastTick = Duration.zero;
  Timer? _viewportTimer;
  Timer? _sourceTimer;
  Duration _lastMarkerPush = Duration.zero;
  bool _sourceUpdatePending = false;
  bool _styleReady = false;
  bool _imageReady = false;
  bool _clusterReady = false;

  /// Vehicles currently drawn as markers: enabled types, in viewport, nearest
  /// to the center first, capped at the configured maximum.
  Set<String> _wantedMarkers = const {};
  String? _error;
  bool _connected = false;
  int _eventCount = 0;
  double _zoom = _initialCamera.zoom;
  LatLngBounds _viewport = _initialBounds;
  VehicleViewOptions _options = const VehicleViewOptions();

  /// Whether animated markers are the active representation right now.
  bool get _markersActive =>
      _options.animations && _zoom >= _options.animationZoom;

  /// Upper zoom bound for cluster and dot layers, so they hand over to the
  /// animated markers. Null when animations are off: dots stay at every zoom.
  double? get _dotsMaxZoom =>
      _options.animations ? _options.animationZoom : null;

  /// Zoom at which the marker layers become visible. Above the range when
  /// animations are off, which hides them for good.
  double get _markersMinZoom =>
      _options.animations ? _options.animationZoom : 24;

  /// True when the two source families need the same map source and layers.

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick);
    _ticker?.start();
    _connect(_initialBounds);
  }

  void _connect(LatLngBounds bounds) {
    _subscription?.cancel();
    setState(() {
      _error = null;
      _connected = true;
    });
    _subscription = client.vehiclePositions
        .watchVehicles(
          north: bounds.northeast.latitude,
          south: bounds.southwest.latitude,
          east: bounds.northeast.longitude,
          west: bounds.southwest.longitude,
        )
        .listen(
          _onDelta,
          onError: (Object e) {
            setState(() {
              _error = '$e';
              _connected = false;
            });
          },
          onDone: () {
            if (mounted) {
              setState(() => _connected = false);
            }
          },
        );
  }

  void _reconnect() => _connect(_viewport);

  /// Camera moved: track zoom + viewport, debounce upstream resubscribe.
  void _onCameraIdle() {
    final controller = _mapController;
    if (controller == null) return;
    final camera = controller.cameraPosition;
    if (camera != null) {
      _zoom = camera.zoom;
      unawaited(_syncSymbolsToZoom());
    }
    unawaited(_updateViewport(debounced: true));
  }

  Future<void> _updateViewport({required bool debounced}) async {
    final controller = _mapController;
    if (controller == null) return;
    try {
      final bounds = await controller.getVisibleRegion();
      // Guard against NaN bounds before first layout (iOS).
      if (!bounds.southwest.latitude.isFinite ||
          !bounds.northeast.latitude.isFinite) {
        return;
      }
      _viewport = bounds;
      if (!debounced) {
        _connect(bounds);
        return;
      }
      _viewportTimer?.cancel();
      _viewportTimer = Timer(_viewportDebounce, () {
        if (mounted) _connect(_viewport);
      });
    } catch (e) {
      debugPrint('getVisibleRegion failed: $e');
    }
  }

  Future<void> _onDelta(VehicleDelta delta) async {
    final now = DateTime.now();
    // Removed vehicles simply drop out of the marker set and the source data;
    // there is no per-marker handle to release any more.
    for (final removedId in delta.removed) {
      _vehicles.remove(removedId);
    }
    for (final vehicle in delta.updated) {
      final existing = _vehicles[vehicle.vehicleId];
      if (existing == null) {
        _vehicles[vehicle.vehicleId] = _AnimatedVehicle(
          current: vehicle,
          now: now,
        );
      } else {
        existing.retarget(vehicle, now);
      }
    }
    if (mounted) setState(() => _eventCount++);
    unawaited(_syncSymbolsToZoom());
    _scheduleClusterRefresh();
  }

  bool _inViewport(VehiclePosition v) {
    return v.latitude >= _viewport.southwest.latitude &&
        v.latitude <= _viewport.northeast.latitude &&
        v.longitude >= _viewport.southwest.longitude &&
        v.longitude <= _viewport.northeast.longitude;
  }

  /// Viewport center, for nearest-first marker selection.
  LatLng get _viewportCenter => LatLng(
    (_viewport.southwest.latitude + _viewport.northeast.latitude) / 2,
    (_viewport.southwest.longitude + _viewport.northeast.longitude) / 2,
  );

  static double _distSq(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    final dLat = lat1 - lat2;
    final dLng = lng1 - lng2;
    return dLat * dLat + dLng * dLng;
  }

  /// Show at most [_options.maxAnimatedVehicles] symbols: enabled types only,
  /// nearest in-viewport vehicles win. Runs on every delta and zoom change;
  /// cheap set math, no platform calls for unchanged vehicles.
  /// Recomputes the marker set and pushes what the current zoom shows.
  ///
  /// Above the animation zoom the clustered layers are hidden, so their source
  /// is left stale instead of re-clustered every second; below it the markers
  /// are hidden and only the cluster source is refreshed.
  Future<void> _syncSymbolsToZoom() async {
    if (!_styleReady || !_imageReady) return;
    _updateWantedMarkers();
    if (_markersActive) {
      await _refreshMarkerSource();
      return;
    }
    await _refreshClusterSource();
  }

  /// Nearest-first selection of the vehicles that get an animated marker.
  void _updateWantedMarkers() {
    if (!_markersActive) {
      _wantedMarkers = const {};
      return;
    }
    final center = _viewportCenter;
    final candidates =
        _vehicles.values
            .where(
              // Type filter applies here too, so disabling a type also
              // withdraws its markers and frees up the cap.
              (a) =>
                  _options.showsKind(classifyVehicle(a.current)) &&
                  _inViewport(a.current),
            )
            .toList()
          ..sort(
            (a, b) =>
                _distSq(
                  a.current.latitude,
                  a.current.longitude,
                  center.latitude,
                  center.longitude,
                ).compareTo(
                  _distSq(
                    b.current.latitude,
                    b.current.longitude,
                    center.latitude,
                    center.longitude,
                  ),
                ),
          );
    _wantedMarkers = {
      for (final a in candidates.take(_options.maxAnimatedVehicles))
        a.current.vehicleId,
    };
  }

  /// Throttled clustered-source refresh: at most one platform call per
  /// [_sourceThrottle], coalescing the ~1/s SSE events.
  void _scheduleClusterRefresh() {
    if (!_clusterReady) return;
    if (_markersActive) {
      // Layers are hidden up here; the next zoom-out refreshes them.
      return;
    }
    if (_sourceTimer != null) {
      _sourceUpdatePending = true;
      return;
    }
    unawaited(_refreshClusterSource());
    _sourceTimer = Timer(_sourceThrottle, () {
      _sourceTimer = null;
      if (_sourceUpdatePending) {
        _sourceUpdatePending = false;
        _scheduleClusterRefresh();
      }
    });
  }

  Map<String, dynamic> _featureCollection() {
    return {
      'type': 'FeatureCollection',
      'features': _vehicles.values
          // Type filter is applied to the source, so cluster counts follow it.
          .where((a) => _options.showsKind(classifyVehicle(a.current)))
          .map((a) {
            final v = a.current;
            final train = a.isTrain;
            return {
              'type': 'Feature',
              'id': v.vehicleId,
              'properties': {
                'vehicleId': v.vehicleId,
                // Train lines show an icon instead of the line number.
                'label': train ? '' : _labelFor(v),
                'bgColor': _bgColorFor(v),
                'fgColor': _fgColorFor(v),
                'isTrain': train ? 1 : 0,
              },
              'geometry': {
                'type': 'Point',
                'coordinates': [v.longitude, v.latitude],
              },
            };
          })
          .toList(),
    };
  }

  static String _labelFor(VehiclePosition v) {
    final short = v.lineShortName;
    if (short != null && short.isNotEmpty) return short;
    return v.destination ?? '';
  }

  static String _bgColorFor(VehiclePosition v) =>
      v.lineBackgroundColor ?? '#1d4ed8';

  static String _fgColorFor(VehiclePosition v) =>
      v.lineForegroundColor ?? '#ffffff';

  /// Text size scaled by label length: one digit big, three digits small.
  static double _textSizeFor(String label) => switch (label.length) {
    <= 1 => 13,
    2 => 11.5,
    _ => 9.5,
  };

  /// Vertical text offset: a small nudge because digit glyphs sit above the
  /// text-box center.
  static const _textOffset = Offset(0, 0.1);

  Future<void> _refreshClusterSource() async {
    final controller = _mapController;
    if (controller == null || !_styleReady || !_clusterReady) return;
    if (_markersActive) {
      // Hidden above the animation zoom; re-clustering 1300 points for nothing
      // is the most expensive thing this screen could do.
      return;
    }
    try {
      await controller.setGeoJsonSource(
        _clusterSourceId,
        _featureCollection(),
      );
    } catch (e) {
      // Style reloads wipe sources; re-created on next onStyleLoadedCallback.
      debugPrint('setGeoJsonSource failed: $e');
    }
  }

  /// One source update draws every animated marker, replacing what used to be
  /// one `updateSymbol` platform call per marker per frame.
  Future<void> _refreshMarkerSource() async {
    final controller = _mapController;
    if (controller == null || !_styleReady) return;
    if (!_markersActive) return;
    try {
      await controller.setGeoJsonSource(
        _markerSourceId,
        _markerFeatureCollection(),
      );
    } catch (e) {
      debugPrint('marker source update failed: $e');
    }
  }

  /// Features for the marker layers. The layers are data-driven, so rotating,
  /// colouring and labelling happen on the GPU without further calls.
  Map<String, dynamic> _markerFeatureCollection() {
    final features = <Map<String, dynamic>>[];
    for (final animated in _vehicles.values) {
      if (!_wantedMarkers.contains(animated.current.vehicleId)) continue;
      final train = animated.isTrain;
      final label = train ? '' : animated.displayLabel;
      features.add({
        'type': 'Feature',
        'id': animated.current.vehicleId,
        'properties': {
          'icon': _arrowImageName,
          'rotate': animated.renderedCourse,
          'color': animated.displayColor,
          'isTrain': train ? 1 : 0,
          'label': label,
          'textColor': animated.displayTextColor,
          'textSize': train ? 0 : _textSizeFor(label),
          'textOffset': [_textOffset.dx, _textOffset.dy],
        },
        'geometry': {
          'type': 'Point',
          'coordinates': [
            animated.renderedPosition.longitude,
            animated.renderedPosition.latitude,
          ],
        },
      });
    }
    return {'type': 'FeatureCollection', 'features': features};
  }

  /// Ticker-driven: every vehicle advances by real elapsed time at its own
  /// reported ground speed. Slow vehicles crawl, fast ones fly. Stationary
  /// (< ~2 km/h) vehicles hold position.
  void _tick(Duration elapsed) {
    final dt = elapsed - _lastTick;
    _lastTick = elapsed;
    if (_mapController == null ||
        !_styleReady ||
        !_imageReady ||
        !_markersActive) {
      return;
    }
    final dtSeconds = dt.inMicroseconds / 1e6;
    if (dtSeconds <= 0 || dtSeconds > 5) return;
    var moved = false;
    for (final animated in _vehicles.values) {
      if (!_wantedMarkers.contains(animated.current.vehicleId)) continue;
      if (animated.advance(dtSeconds)) moved = true;
    }
    final push = elapsed - _lastMarkerPush >= _markerPushInterval;
    if (!moved || !push) return;
    _lastMarkerPush = elapsed;
    unawaited(_refreshMarkerSource());
  }

  /// Adds the marker source and its two data-driven symbol layers.
  ///
  /// Everything that used to be a per-marker annotation property (rotation,
  /// colour, label, glyph) is a feature property here, so one source update
  /// moves every marker and the GPU does the rest.
  Future<void> _setupMarkerLayers(MapLibreMapController controller) async {
    await controller.addSource(
      _markerSourceId,
      GeojsonSourceProperties(data: _markerFeatureCollection()),
    );
    // The zoom swap is a layer bound, so nothing is created or destroyed while
    // the user zooms through the threshold.
    final minzoom = _markersMinZoom;
    await controller.addSymbolLayer(
      _markerSourceId,
      _markerLayerId,
      SymbolLayerProperties(
        iconImage: [Expressions.get, 'icon'],
        iconSize: _iconSize,
        iconRotate: [Expressions.get, 'rotate'],
        iconColor: [Expressions.get, 'color'],
        iconAllowOverlap: true,
        iconIgnorePlacement: true,
        textField: [Expressions.get, 'label'],
        textColor: [Expressions.get, 'textColor'],
        textSize: [Expressions.get, 'textSize'],
        textOffset: [Expressions.get, 'textOffset'],
        textAllowOverlap: true,
        textIgnorePlacement: true,
      ),
      minzoom: minzoom,
    );
    // Train pictogram on its own layer: no `iconRotate`, so the glyph stays
    // upright while the arrow underneath marks the heading.
    await controller.addSymbolLayer(
      _markerSourceId,
      _markerGlyphLayerId,
      SymbolLayerProperties(
        iconImage: _trainGlyphImageName,
        iconSize: _trainGlyphSize,
        iconColor: [Expressions.get, 'textColor'],
        iconAllowOverlap: true,
        iconIgnorePlacement: true,
      ),
      filter: [
        '==',
        [Expressions.get, 'isTrain'],
        1,
      ],
      minzoom: minzoom,
    );
  }

  /// Circle body of radius 20 centered in the 64px canvas, with a pointed
  /// arrow head on top pointing up.
  ///
  /// The body is concentric with the image center on purpose: the icon anchor
  /// is the image center, so rotating the marker (per-vehicle `iconRotate`)
  /// cannot swing the body away from the label, which stays anchored to the
  /// same point.
  static void _paintArrowBody(ui.Canvas canvas, ui.Color color) {
    const cx = 32.0;
    const cy = 32.0;
    const headHalfWidth = 13.0;
    final fill = ui.Paint()..color = color;
    canvas.drawCircle(const ui.Offset(cx, cy), 20.0, fill);
    final head = ui.Path()
      ..moveTo(cx, 4.0)
      ..lineTo(cx + headHalfWidth, 20.0)
      ..lineTo(cx - headHalfWidth, 20.0)
      ..close();
    canvas.drawPath(head, fill);
  }

  /// Draws the arrow marker once (white shape, tinted per vehicle at runtime
  /// via `iconColor`) and registers it with the map style.
  ///
  /// Small circle body with a pointed arrow head on top, so the marker reads
  /// as a direction indicator at any icon size.
  Future<void> _ensureArrowImage(MapLibreMapController controller) async {
    const size = 64.0;
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    _paintArrowBody(canvas, const ui.Color(0xFFFFFFFF));
    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    if (bytes == null) return;
    await controller.addImage(
      _arrowImageName,
      bytes.buffer.asUint8List(),
      true, // SDF: tintable via iconColor per symbol
    );
    _imageReady = true;
  }

  /// Train pictogram drawn in a 32x32 design box, so callers can place and
  /// scale it freely. Drawn as paths rather than a font glyph: the icon font
  /// loads asynchronously on web, and painting before it is ready bakes a
  /// blank image into the map style.
  static void _paintTrainGlyph(ui.Canvas canvas, ui.Color color) {
    final fill = ui.Paint()..color = color;
    final stroke = ui.Paint()
      ..color = color
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeJoin = ui.StrokeJoin.round;
    // Body.
    canvas.drawRRect(
      ui.RRect.fromRectAndRadius(
        const ui.Rect.fromLTWH(6, 2.2, 20, 16.5),
        const ui.Radius.circular(4.5),
      ),
      stroke,
    );
    // Window band.
    canvas.drawRRect(
      ui.RRect.fromRectAndRadius(
        const ui.Rect.fromLTWH(11, 5.7, 10, 5),
        const ui.Radius.circular(2),
      ),
      fill,
    );
    // Wheels.
    canvas.drawCircle(const ui.Offset(10.5, 23.2), 2.4, fill);
    canvas.drawCircle(const ui.Offset(21.5, 23.2), 2.4, fill);
    // Rail.
    canvas.drawRRect(
      ui.RRect.fromRectAndRadius(
        const ui.Rect.fromLTWH(5, 27.3, 22, 2.6),
        const ui.Radius.circular(1.3),
      ),
      fill,
    );
  }

  /// Standalone white train glyph registered as SDF, so the clustered dot
  /// layer can tint it with each line's foreground color.
  Future<void> _ensureTrainGlyphImage(MapLibreMapController controller) async {
    const size = 32.0;
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    _paintTrainGlyph(canvas, const ui.Color(0xFFFFFFFF));
    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    if (bytes == null) return;
    await controller.addImage(
      _trainGlyphImageName,
      bytes.buffer.asUint8List(),
      true, // SDF: tintable via iconColor
    );
  }

  /// Cluster layers are created with `cluster`, `clusterMinPoints` and
  /// `maxzoom`, none of which can be changed in place, so a settings change
  /// recreates the source and layers.
  Future<void> _rebuildLayers() async {
    final controller = _mapController;
    if (controller == null) return;
    _clusterReady = false;
    for (final layerId in [
      _markerGlyphLayerId,
      _markerLayerId,
      _trainDotLayerId,
      _dotLabelLayerId,
      _dotLayerId,
      _clusterCountLayerId,
      _clusterCirclesLayerId,
    ]) {
      try {
        await controller.removeLayer(layerId);
      } catch (e) {
        // Absent layers are fine: clustering may be off.
        debugPrint('removeLayer $layerId failed: $e');
      }
    }
    for (final sourceId in [_markerSourceId, _clusterSourceId]) {
      try {
        await controller.removeSource(sourceId);
      } catch (e) {
        debugPrint('removeSource failed: $e');
      }
    }
    if (!_styleReady) return;
    try {
      await _setupClusterLayers(controller);
      await _setupMarkerLayers(controller);
    } catch (e) {
      debugPrint('layer rebuild failed: $e');
    }
    _updateWantedMarkers();
    await _refreshClusterSource();
    await _refreshMarkerSource();
  }

  /// Applies new view options, rebuilding the layers only when a setting that
  /// is fixed at creation time changed.
  void _applyOptions(VehicleViewOptions next) {
    final needsRebuild = !_options.sameLayers(next);
    setState(() => _options = next);
    if (needsRebuild) {
      unawaited(_rebuildLayers());
      return;
    }
    unawaited(_refreshClusterSource());
    unawaited(_syncSymbolsToZoom());
  }

  Future<void> _openViewOptions() async {
    await showVehicleViewOptionsSheet(
      context,
      options: _options,
      onChanged: _applyOptions,
    );
  }

  Future<void> _setupClusterLayers(MapLibreMapController controller) async {
    final maxzoom = _dotsMaxZoom;
    await controller.addSource(
      _clusterSourceId,
      GeojsonSourceProperties(
        data: _featureCollection(),
        cluster: _options.clustering,
        clusterRadius: _clusterRadius,
        clusterMinPoints: _options.clusterMinPoints.toDouble(),
        // Stop clustering once markers take over.
        clusterMaxZoom: maxzoom ?? 18,
      ),
    );
    if (_options.clustering) {
      // Cluster bubbles, sized by point count.
      await controller.addCircleLayer(
        _clusterSourceId,
        _clusterCirclesLayerId,
        CircleLayerProperties(
          circleRadius: [
            Expressions.step,
            [Expressions.get, 'point_count'],
            16,
            10,
            22,
            50,
            30,
          ],
          circleColor: const Color(0xFF1d4ed8).toHexStringRGB(),
          circleOpacity: 0.9,
          circleStrokeWidth: 2,
          circleStrokeColor: '#ffffff',
        ),
        filter: [Expressions.has, 'point_count'],
        // Exclusive swap: clusters only below the marker zoom.
        maxzoom: maxzoom,
      );
      // Cluster count labels.
      await controller.addSymbolLayer(
        _clusterSourceId,
        _clusterCountLayerId,
        SymbolLayerProperties(
          textField: [Expressions.get, 'point_count_abbreviated'],
          textSize: 12,
          textColor: '#ffffff',
          textAllowOverlap: true,
        ),
        filter: [Expressions.has, 'point_count'],
        maxzoom: maxzoom,
      );
    }
    // Individual dots: line color + short name. Without clustering these are
    // every vehicle; with clustering only the unclustered ones.
    await controller.addCircleLayer(
      _clusterSourceId,
      _dotLayerId,
      CircleLayerProperties(
        circleRadius: 9,
        circleColor: [Expressions.get, 'bgColor'],
        circleOpacity: 1,
        circleStrokeWidth: 1.5,
        circleStrokeColor: '#ffffff',
      ),
      filter: [
        '!',
        [Expressions.has, 'point_count'],
      ],
      // Hidden once animated markers take over.
      maxzoom: maxzoom,
    );
    // Short-name labels inside the dots.
    await controller.addSymbolLayer(
      _clusterSourceId,
      _dotLabelLayerId,
      SymbolLayerProperties(
        textField: [Expressions.get, 'label'],
        textSize: 10,
        textColor: [Expressions.get, 'fgColor'],
        textAllowOverlap: true,
        textIgnorePlacement: true,
      ),
      filter: [
        '!',
        [Expressions.has, 'point_count'],
      ],
      maxzoom: maxzoom,
    );
    // Train lines show a glyph instead of the (empty) short name.
    await _ensureTrainGlyphImage(controller);
    await controller.addSymbolLayer(
      _clusterSourceId,
      _trainDotLayerId,
      SymbolLayerProperties(
        iconImage: _trainGlyphImageName,
        // 32px design box; ~13px glyph inside the 18px dot.
        iconSize: 0.4,
        iconColor: [Expressions.get, 'fgColor'],
        iconAllowOverlap: true,
        iconIgnorePlacement: true,
      ),
      // Clusters carry no `isTrain`, so they are excluded automatically.
      filter: [
        '==',
        [Expressions.get, 'isTrain'],
        1,
      ],
      maxzoom: maxzoom,
    );
    _clusterReady = true;
  }

  Future<void> _onStyleLoaded() async {
    final controller = _mapController;
    if (controller == null) return;
    _styleReady = true;
    _imageReady = false;
    _clusterReady = false;
    // Style reloads wipe registered images and layers; recreate both. The
    // overlap settings are layer properties now, not annotation flags.
    try {
      await _ensureArrowImage(controller);
      await _ensureTrainGlyphImage(controller);
    } catch (e) {
      debugPrint('marker image setup failed: $e');
    }
    try {
      await _setupClusterLayers(controller);
      await _setupMarkerLayers(controller);
    } catch (e) {
      debugPrint('layer setup failed: $e');
    }
    await _syncSymbolsToZoom();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _viewportTimer?.cancel();
    _sourceTimer?.cancel();
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _connected
                      ? 'Vehicles live (${_vehicles.length}) · '
                            'events $_eventCount'
                      : 'Vehicles (disconnected)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton(onPressed: _reconnect, child: const Text('Reconnect')),
            ],
          ),
        ),
        if (_error != null)
          Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.errorContainer,
            padding: const EdgeInsets.all(8),
            child: Text(_error!),
          ),
        Expanded(
          child: Stack(
            children: [
              MapLibreMap(
                initialCameraPosition: _initialCamera,
                styleString: MapLibreStyles.openfreemapLiberty,
                onMapCreated: (controller) => _mapController = controller,
                onStyleLoadedCallback: _onStyleLoaded,
                onCameraIdle: _onCameraIdle,
                trackCameraPosition: true,
                // Show every vehicle even when markers collide.
                annotationOrder: const [AnnotationType.symbol],
              ),
              Positioned(
                top: 12,
                left: 12,
                child: IconButton.filledTonal(
                  onPressed: _openViewOptions,
                  tooltip: 'View options',
                  icon: Icon(
                    _options.showsAllKinds ? Icons.tune : Icons.filter_alt_off,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// One vehicle plus its interpolation state between SSE updates.
///
/// Movement is time-based, not frame-based: each update records the segment
/// from the last rendered position to the new target plus a duration derived
/// from `speedKmh` (distance / speed, clamped). [_tick] advances every vehicle
/// by real elapsed seconds, so a 10 km/h bus crawls while a 100 km/h train
/// flies across the same screen distance. Interpolation is linear (constant
/// ground speed) and continues past the last fix by dead reckoning, so
/// markers glide smoothly instead of stop-starting on every update.
class _AnimatedVehicle {
  _AnimatedVehicle({required VehiclePosition current, required DateTime now})
    : current = current,
      _fromLat = current.latitude,
      _fromLng = current.longitude,
      _fromCourse = current.course ?? 0,
      _renderedLat = current.latitude,
      _renderedLng = current.longitude,
      _renderedCourse = current.course ?? 0,
      _segmentElapsed = 1,
      _segmentDuration = 1,
      _lastUpdate = now;

  VehiclePosition current;

  /// Train lines show a pictogram in the marker body instead of the number.
  bool get isTrain => displayLabel.toLowerCase().contains('tåg');

  double _fromLat;
  double _fromLng;
  double _fromCourse;

  double _renderedLat;
  double _renderedLng;
  double _renderedCourse;

  /// Seconds into the current segment / total segment seconds.
  double _segmentElapsed;
  double _segmentDuration;

  /// Ground speed in m/s; used to keep rolling past the last fix (dead
  /// reckoning) until the next update arrives.
  double _speedMs = 0;

  /// Length of the current segment in meters. Caps how far dead reckoning
  /// may run, so the marker never overshoots the next fix and snaps back.
  double _segmentLenMeters = 0;
  DateTime _lastUpdate; // ignore: unused_field

  LatLng get renderedPosition => LatLng(_renderedLat, _renderedLng);
  double get renderedCourse => _renderedCourse;

  static const _minDuration = 0.3;
  static const _maxDuration = 10.0;

  /// Stop dead reckoning this many seconds after the segment's ETA passed.
  static const _maxExtrapolation = 5.0;

  /// New target arrives: start the next segment from the currently rendered
  /// position, with a duration from distance / speedKmh so the marker moves
  /// at the reported ground speed.
  void retarget(VehiclePosition next, DateTime now) {
    final distMeters = _haversineMeters(
      _renderedLat,
      _renderedLng,
      next.latitude,
      next.longitude,
    );
    final reportedMs = (next.speedKmh ?? 0) / 3.6;
    _segmentLenMeters = distMeters;
    final double duration;
    if (distMeters <= 1) {
      // Standing still: no glide, no extrapolation.
      duration = _minDuration;
      _speedMs = 0;
    } else if (reportedMs > 0.5) {
      duration = (distMeters / reportedMs).clamp(_minDuration, _maxDuration);
      _speedMs = distMeters / duration;
    } else {
      // No speed reported: glide over ~1s, then hold.
      duration = 1.0;
      _speedMs = 0;
    }
    _fromLat = _renderedLat;
    _fromLng = _renderedLng;
    _fromCourse = _renderedCourse;
    current = next;
    _segmentElapsed = 0;
    _segmentDuration = duration;
    _lastUpdate = now;
  }

  /// Advances along the current segment by [dtSeconds] at constant speed,
  /// then keeps extrapolating along the last course while awaiting the next
  /// update. Returns false when nothing moved (caller can skip the platform
  /// call).
  bool advance(double dtSeconds) {
    _segmentElapsed += dtSeconds;
    final prevLat = _renderedLat;
    final prevLng = _renderedLng;
    final t = (_segmentElapsed / _segmentDuration).clamp(0.0, 1.0);
    final targetCourse = current.course ?? _fromCourse;
    if (t < 1) {
      _renderedLat = _lerp(_fromLat, current.latitude, t);
      _renderedLng = _lerp(_fromLng, current.longitude, t);
      _renderedCourse =
          _fromCourse + _shortestAngle(_fromCourse, targetCourse) * t;
    } else if (_speedMs >= 0.5 &&
        _segmentElapsed - _segmentDuration <= _maxExtrapolation) {
      // Dead reckoning past the last fix at the reported speed/course,
      // capped at one segment's length to avoid overshooting the next fix.
      _renderedCourse = targetCourse;
      final extraMeters = math.min(
        _speedMs * (_segmentElapsed - _segmentDuration),
        _segmentLenMeters,
      );
      const earth = 6371000.0;
      final bearing = _toRad(targetCourse);
      _renderedLat =
          current.latitude +
          extraMeters * math.cos(bearing) / earth * 180 / math.pi;
      _renderedLng =
          current.longitude +
          extraMeters *
              math.sin(bearing) /
              (earth * math.cos(_toRad(current.latitude))) *
              180 /
              math.pi;
    }
    return _renderedLat != prevLat || _renderedLng != prevLng;
  }

  String get displayLabel {
    final short = current.lineShortName;
    if (short != null && short.isNotEmpty) return short;
    return current.destination ?? '';
  }

  String get displayColor => current.lineBackgroundColor ?? '#1d4ed8';

  String get displayTextColor => current.lineForegroundColor ?? '#ffffff';

  static double _lerp(double a, double b, double t) => a + (b - a) * t;

  /// Shortest signed angular difference in degrees, for smooth rotation.
  static double _shortestAngle(double from, double to) {
    var diff = (to - from) % 360;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;
    return diff;
  }

  /// Great-circle distance in meters.
  static double _haversineMeters(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const earth = 6371000.0;
    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);
    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRad(lat1)) *
            math.cos(_toRad(lat2)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    return 2 * earth * math.asin(math.sqrt(a));
  }

  static double _toRad(double deg) => deg * math.pi / 180;
}
