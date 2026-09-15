import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:open_transport_map_client/open_transport_map_client.dart';

import '../client.dart';

/// Live map of Västtrafik vehicle positions, relayed through the Serverpod
/// streaming endpoint `vehiclePositions.watchVehicles`.
///
/// Rendering strategy (perf):
/// - Low zoom: clustered circle layer only (GPU, one source update per event).
///   Individual dots are colored per line with the short name as label.
/// - High zoom (>= [_markerZoom]): animated arrow symbols only (cluster
///   and dot layers hide via maxzoom), capped at
///   [_maxMarkers] vehicles nearest the viewport center. Each animates at its
///   own speed derived from `speedKmh`, so slow vehicles crawl, fast ones fly.
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

  /// Detailed markers only at street-level zoom.
  static const _markerZoom = 13.5;

  /// Max animated symbols at once. Nearest to viewport center win.
  static const _maxMarkers = 50;

  /// Cluster radius in pixels.
  static const _clusterRadius = 50.0;

  /// Scale of the 64px arrow image; ~35px on screen.
  static const _iconSize = 0.55;

  /// Scale of the 32px train glyph; ~12px, inside the 22px marker body.
  static const _trainGlyphSize = 0.38;

  /// Minimum points to form a cluster. Below this, show single dots.
  static const _clusterMinPoints = 10.0;

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
  String? _error;
  bool _connected = false;
  int _eventCount = 0;
  double _zoom = _initialCamera.zoom;
  LatLngBounds _viewport = _initialBounds;

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
    for (final removedId in delta.removed) {
      final animated = _vehicles.remove(removedId);
      if (animated != null) {
        unawaited(_removeSymbol(animated));
      }
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

  /// Show at most [_maxMarkers] symbols: nearest in-viewport vehicles win.
  /// Runs on every delta and zoom change; cheap set math, no platform calls
  /// for unchanged vehicles.
  Future<void> _syncSymbolsToZoom() async {
    if (!_styleReady || !_imageReady) return;
    if (_zoom < _markerZoom) {
      for (final animated in _vehicles.values) {
        if (animated.symbol != null || animated.addInFlight) {
          unawaited(_removeSymbol(animated));
        }
      }
      return;
    }
    final center = _viewportCenter;
    final candidates =
        _vehicles.values.where((a) => _inViewport(a.current)).toList()..sort(
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
    final wanted = {
      for (final a in candidates.take(_maxMarkers)) a.current.vehicleId,
    };
    for (final animated in _vehicles.values) {
      final id = animated.current.vehicleId;
      final has = animated.symbol != null || animated.addInFlight;
      if (wanted.contains(id) && !has) {
        animated.snap();
        unawaited(_addSymbol(animated));
      } else if (!wanted.contains(id) && has) {
        unawaited(_removeSymbol(animated));
      }
    }
  }

  /// Throttled clustered-source refresh: at most one platform call per
  /// [_sourceThrottle], coalescing the ~1/s SSE events.
  void _scheduleClusterRefresh() {
    if (!_clusterReady) return;
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
      'features': _vehicles.values.map((a) {
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
      }).toList(),
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

  /// Ticker-driven: every vehicle advances by real elapsed time at its own
  /// reported ground speed. Slow vehicles crawl, fast ones fly. Stationary
  /// (< ~2 km/h) vehicles hold position.
  void _tick(Duration elapsed) {
    final dt = elapsed - _lastTick;
    _lastTick = elapsed;
    final controller = _mapController;
    if (controller == null ||
        !_styleReady ||
        !_imageReady ||
        _zoom < _markerZoom) {
      return;
    }
    final dtSeconds = dt.inMicroseconds / 1e6;
    if (dtSeconds <= 0 || dtSeconds > 5) return;
    final push = elapsed - _lastMarkerPush >= _markerPushInterval;
    if (push) _lastMarkerPush = elapsed;
    for (final animated in _vehicles.values) {
      final symbol = animated.symbol;
      if (symbol == null) continue;
      final moved = animated.advance(dtSeconds);
      if (!push || !moved) continue;
      // The marker image is baked per train/non-train, so a flip between the
      // two needs a fresh symbol rather than an in-place update.
      if (animated.renderedTrain != animated.isTrain) {
        unawaited(_rebuildSymbol(animated));
        continue;
      }
      final pos = animated.renderedPosition;
      final label = animated.displayLabel;
      final train = animated.renderedTrain;
      unawaited(
        _updateSymbolSafe(
          controller,
          symbol,
          SymbolOptions(
            geometry: pos,
            iconRotate: animated.renderedCourse,
            iconImage: _arrowImageName,
            iconColor: animated.displayColor,
            textField: train ? null : label,
            textColor: train ? null : animated.displayTextColor,
            textSize: train ? null : _textSizeFor(label),
            textOffset: train ? null : _textOffset,
          ),
        ),
      );
      // The glyph rides along without the course rotation, so the pictogram
      // stays upright while the arrow keeps pointing the direction.
      final glyph = animated.glyph;
      if (glyph != null) {
        unawaited(
          _updateSymbolSafe(
            controller,
            glyph,
            SymbolOptions(geometry: pos, iconColor: animated.displayTextColor),
          ),
        );
      }
    }
  }

  Future<void> _addSymbol(_AnimatedVehicle animated) async {
    final controller = _mapController;
    if (controller == null ||
        !_styleReady ||
        !_imageReady ||
        _zoom < _markerZoom) {
      return;
    }
    // Guard against overlapping sync runs: the await below yields, so a
    // second _syncSymbolsToZoom would otherwise start a duplicate add and
    // leak the first native symbol as an undeletable trace.
    if (animated.symbol != null || animated.addInFlight) return;
    animated.addInFlight = true;
    animated.dropAfterAdd = false;
    Symbol? added;
    Symbol? addedGlyph;
    try {
      final v = animated.current;
      final label = animated.displayLabel;
      final train = animated.isTrain;
      added = await controller.addSymbol(
        SymbolOptions(
          geometry: LatLng(v.latitude, v.longitude),
          iconImage: _arrowImageName,
          iconRotate: v.course ?? 0,
          iconSize: _iconSize,
          iconColor: animated.displayColor,
          // Train lines show a glyph in the body instead of the line number.
          textField: train ? null : label,
          textColor: train ? null : animated.displayTextColor,
          // Line number centered in the circle body.
          textSize: train ? null : _textSizeFor(label),
          textOffset: train ? null : _textOffset,
        ),
      );
      if (train) {
        addedGlyph = await controller.addSymbol(
          SymbolOptions(
            geometry: LatLng(v.latitude, v.longitude),
            iconImage: _trainGlyphImageName,
            // No iconRotate: the pictogram stays upright at any heading.
            iconSize: _trainGlyphSize,
            iconColor: animated.displayTextColor,
          ),
        );
      }
      animated.renderedTrain = train;
    } catch (e) {
      debugPrint('addSymbol failed: $e');
      animated.addInFlight = false;
      // Keep no handle from a partially created marker.
      await _removeHandles(controller, added, addedGlyph);
      return;
    }
    animated.addInFlight = false;
    if (animated.dropAfterAdd ||
        !_vehicles.containsKey(animated.current.vehicleId)) {
      // A remove (zoom-out, eviction, vehicle gone) arrived mid-add.
      animated.dropAfterAdd = false;
      await _removeHandles(controller, added, addedGlyph);
      return;
    }
    animated.symbol = added;
    animated.glyph = addedGlyph;
  }

  Future<void> _removeHandles(
    MapLibreMapController controller,
    Symbol? symbol,
    Symbol? glyph,
  ) async {
    for (final handle in [symbol, glyph]) {
      if (handle == null) continue;
      try {
        await controller.removeSymbol(handle);
      } catch (e) {
        debugPrint('removeSymbol failed: $e');
      }
    }
  }

  /// Marker image is baked per train/non-train, so a flip between the two
  /// needs a new symbol instead of an in-place update.
  Future<void> _rebuildSymbol(_AnimatedVehicle animated) async {
    if (animated.addInFlight) return;
    await _removeSymbol(animated);
    if (!_vehicles.containsKey(animated.current.vehicleId) ||
        _zoom < _markerZoom) {
      return;
    }
    animated.snap();
    await _addSymbol(animated);
  }

  Future<void> _removeSymbol(_AnimatedVehicle animated) async {
    if (animated.addInFlight) {
      // Add still awaiting native handle; _addSymbol removes it on arrival.
      animated.dropAfterAdd = true;
      return;
    }
    final controller = _mapController;
    final symbol = animated.symbol;
    final glyph = animated.glyph;
    animated.symbol = null;
    animated.glyph = null;
    if (controller == null) return;
    await _removeHandles(controller, symbol, glyph);
  }

  Future<void> _updateSymbolSafe(
    MapLibreMapController controller,
    Symbol symbol,
    SymbolOptions options,
  ) async {
    try {
      await controller.updateSymbol(symbol, options);
    } catch (e) {
      debugPrint('updateSymbol failed: $e');
    }
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

  Future<void> _setupClusterLayers(MapLibreMapController controller) async {
    await controller.addSource(
      _clusterSourceId,
      GeojsonSourceProperties(
        data: _featureCollection(),
        cluster: true,
        clusterRadius: _clusterRadius,
        clusterMinPoints: _clusterMinPoints,
        // Stop clustering once markers take over at [_markerZoom].
        clusterMaxZoom: _markerZoom,
      ),
    );
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
      // Exclusive swap: clusters only below [_markerZoom], symbols above.
      maxzoom: _markerZoom,
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
      maxzoom: _markerZoom,
    );
    // Individual dots for unclustered vehicles: line color + short name.
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
      // Dots only below the marker zoom; symbols take over above it.
      maxzoom: _markerZoom,
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
      maxzoom: _markerZoom,
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
      maxzoom: _markerZoom,
    );
    _clusterReady = true;
  }

  Future<void> _onStyleLoaded() async {
    final controller = _mapController;
    if (controller == null) return;
    _styleReady = true;
    _imageReady = false;
    _clusterReady = false;
    // Style reloads wipe registered images; they are re-created on demand.
    // Style reloads wipe registered images; re-created below.
    try {
      await _ensureArrowImage(controller);
      await _ensureTrainGlyphImage(controller);
      // Show every vehicle even when markers collide.
      await controller.setSymbolIconAllowOverlap(true);
      await controller.setSymbolIconIgnorePlacement(true);
      await controller.setSymbolTextAllowOverlap(true);
      await controller.setSymbolTextIgnorePlacement(true);
    } catch (e) {
      debugPrint('arrow image setup failed: $e');
    }
    try {
      await _setupClusterLayers(controller);
    } catch (e) {
      debugPrint('cluster layer setup failed: $e');
    }
    // Style reloads wipe symbols; re-add visible ones.
    for (final animated in _vehicles.values) {
      animated.symbol = null;
      animated.glyph = null;
      animated.addInFlight = false;
      animated.dropAfterAdd = false;
      animated.renderedTrain = false;
      animated.snap();
    }
    await _syncSymbolsToZoom();
    await _refreshClusterSource();
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
          child: MapLibreMap(
            initialCameraPosition: _initialCamera,
            styleString: MapLibreStyles.openfreemapLiberty,
            onMapCreated: (controller) => _mapController = controller,
            onStyleLoadedCallback: _onStyleLoaded,
            onCameraIdle: _onCameraIdle,
            trackCameraPosition: true,
            // Show every vehicle even when markers collide.
            annotationOrder: const [AnnotationType.symbol],
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
  Symbol? symbol;

  /// Upright train pictogram drawn over the marker body for train lines.
  Symbol? glyph;

  /// True while addSymbol's await is outstanding. Guards _syncSymbolsToZoom
  /// against starting a duplicate add (leaked trace) for the same vehicle.
  bool addInFlight = false;

  /// Set by _removeSymbol when a removal arrives mid-add; the add completion
  /// then deletes the just-created native symbol instead of keeping it.
  bool dropAfterAdd = false;

  /// Train lines show an icon in the marker body instead of the line number.
  bool get isTrain => displayLabel.toLowerCase().contains('tåg');

  /// Whether the current marker was built as the train variant.
  bool renderedTrain = false;

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

  void snap() {
    _renderedLat = current.latitude;
    _renderedLng = current.longitude;
    _renderedCourse = current.course ?? _renderedCourse;
    _fromLat = _renderedLat;
    _fromLng = _renderedLng;
    _fromCourse = _renderedCourse;
    _segmentElapsed = _segmentDuration;
    // No dead reckoning from a snapped position; wait for a real fix.
    _speedMs = 0;
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
