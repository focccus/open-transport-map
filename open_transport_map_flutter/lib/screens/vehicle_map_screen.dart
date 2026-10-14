import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:open_transport_map_client/open_transport_map_client.dart';

import '../client.dart';
import '../models/stop_search_result.dart';
import '../models/vehicle_view_options.dart';
import '../services/vehicle_stream.dart';
import '../widgets/service_journey_timeline_panel.dart';
import '../widgets/stop_departures_panel.dart';
import '../widgets/stop_area_search_bar.dart';
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
/// The upstream stream is scoped to the viewport by `VehicleStream`, which
/// requests a padded box and keeps the live feed while the view stays inside
/// it. Markers drawn for the first time (new vehicles, or ones re-entering the
/// viewport or the animation cap) are placed without animation; only later
/// live updates glide.
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

  static const _stopsSourceId = 'transit-stops';
  static const _stopsLayerId = 'transit-stop-dots';
  static const _stopsLabelsLayerId = 'transit-stop-labels';
  static const _stopAreasSourceId = 'transit-stop-areas';
  static const _stopAreaCirclesLayerId = 'transit-stop-area-circles';
  static const _stopAreaLabelsLayerId = 'transit-stop-area-labels';

  /// The open journey's own calls, drawn on the map in its line's colors in
  /// place of the general stop layers.
  static const _journeyStopsSourceId = 'journey-stops';
  static const _journeyStopsLayerId = 'journey-stop-dots';

  /// Rounded-rect template stretched with `icon-text-fit: both` behind the
  /// stop-area name labels.
  static const _stopTagImageName = 'stop-tag';

  /// Active route alignments for the selected stop, drawn as colored lines.
  static const _routesSourceId = 'transit-routes';
  static const _routesCasingLayerId = 'transit-routes-casing';
  static const _routesLayerId = 'transit-routes-line';

  /// Tariff zone polygons, drawn only when the view options enable them.
  static const _zonesSourceId = 'transit-zones';
  static const _zonesFillLayerId = 'transit-zones-fill';
  static const _zonesOutlineLayerId = 'transit-zones-outline';

  /// At or above this width departures dock in a side panel instead of a
  /// bottom sheet.
  static const _wideLayoutBreakpoint = 720.0;

  static const Map<String, dynamic> _emptyFeatureCollectionMap = {
    'type': 'FeatureCollection',
    'features': <Object>[],
  };

  /// Stop areas are the grey dots from 13 up; they grow into labelled
  /// circles as the user zooms in closer.
  static const _stopsMinZoom = 13.0;

  /// Individual stop points (platforms) only appear really close up.
  static const _stopPointsMinZoom = 16.0;

  /// Radius of the tap target around a stop, in logical pixels. Material's
  /// minimum touch target is 48 px across; the drawn dots are far smaller.
  static const _stopTapRadius = 24.0;

  /// Width of the docked departures panel on wide layouts.
  static const _departuresPanelWidth = 360.0;

  /// Bottom-sheet sizes on narrow layouts, as fractions of the map area. The
  /// maximum is two thirds: as much of the screen as the list can take while
  /// still leaving the map usable.
  static const _sheetMinSize = 0.15;
  static const _sheetInitialSize = 0.4;
  static const _sheetMaxSize = 2 / 3;

  /// Where the sheet settles when released: its ends plus the initial size, in
  /// ascending order.
  static const _sheetSnapSizes = <double>[
    _sheetMinSize,
    _sheetInitialSize,
    _sheetMaxSize,
  ];

  static const _sheetSnapDuration = Duration(milliseconds: 200);

  /// Release speed above which the sheet moves one whole snap step in the
  /// direction of the flick, instead of settling on the nearest size.
  static const _sheetFlingVelocity = 400.0;

  /// Ignore differences this small when stepping between snap sizes.
  static const _sheetSizeEpsilon = 0.005;

  /// Stops currently drawn, kept so a tap can find the nearest one in Dart
  /// instead of relying on MapLibre's exact-point hit test.
  List<TransitStopArea> _stopAreas = const [];
  List<TransitStopPoint> _stopPoints = const [];

  /// Width of the map itself in logical pixels, used to turn the tap tolerance
  /// into degrees.
  double _mapWidthPx = 1;

  /// Drives the bottom sheet, so drags outside its scrollable can move it too.
  final _sheetController = DraggableScrollableController();

  /// Height of the bottom sheet's parent, which is what its size fractions are
  /// relative to. Not the screen height: the map area is shorter than that.
  double _sheetParentHeightPx = 1;

  bool _stopsReady = false;

  // Roughly Gothenburg, where most Västtrafik vehicles are.
  /// Cluster radius in pixels.

  /// Cluster radius in pixels.
  static const _clusterRadius = 50.0;

  /// Scale of the 64px arrow image; ~35px on screen.
  static const _iconSize = 0.55;

  /// Scale of the 32px train glyph; ~12px, inside the 22px marker body.
  static const _trainGlyphSize = 0.38;

  /// Opacity of vehicles whose line does not serve the selected stop.
  static const _dimOpacity = 0.22;

  /// Push at most one clustered source update per interval to the map.
  static const _sourceThrottle = Duration(milliseconds: 1000);

  /// How often the open stop's departures are refetched. Past departures drop
  /// off the list as soon as the upstream stops reporting them.
  static const _departuresRefresh = Duration(seconds: 30);

  /// While an open journey is shown, how long each re-centering move takes, so
  /// the camera glides after its vehicle instead of jumping.
  static const _followInterval = Duration(seconds: 1);

  /// Extra room around the open journey's stops when the live feed is scoped to
  /// it, so the vehicle stays covered wherever it is along the route.
  static const _journeyPadding = 0.15;

  /// Marker pushes are capped at ~30 Hz. Advancing state stays per-frame,
  /// but halving the platform calls keeps symbol motion from stuttering.
  static const _markerPushInterval = Duration(milliseconds: 33);

  // Roughly Gothenburg, where most Västtrafik vehicles are.
  static const _initialCamera = CameraPosition(
    target: LatLng(57.7089, 11.9746),
    zoom: 9,
  );

  final Map<String, _AnimatedVehicle> _vehicles = {};
  late final VehicleStream _stream;
  MapLibreMapController? _mapController;
  Ticker? _ticker;
  Duration _lastTick = Duration.zero;
  Timer? _sourceTimer;
  Duration _lastMarkerPush = Duration.zero;
  bool _sourceUpdatePending = false;
  bool _styleReady = false;
  bool _imageReady = false;
  bool _clusterReady = false;

  /// Vehicles currently drawn as markers: enabled types, in viewport, nearest
  /// to the center first, capped at the configured maximum.
  Set<String> _wantedMarkers = const {};

  /// Vehicles drawn as markers on the previous rebuild, so newly drawn ones can
  /// be placed without animating them.
  Set<String> _placedMarkers = const {};
  String? _error;
  bool _connected = false;
  double _zoom = _initialCamera.zoom;
  LatLngBounds _viewport = _initialBounds;
  VehicleViewOptions _options = const VehicleViewOptions();

  /// Stop whose departures are open, and the response for it. Null when no
  /// stop is selected.
  String? _selectionGid;
  bool _selectionIsArea = false;
  StopDeparturesResponse? _departures;
  StreamSubscription<StopDeparturesResponse>? _departuresSubscription;
  Timer? _departuresTimer;
  bool _departuresLoading = false;
  String? _departuresError;

  /// Next stop the departures and route lines are filtered on, or null.
  String? _nextStopFilter;

  /// Departure whose journey timeline is open in place of the list. Null while
  /// the list itself is showing.
  DepartureItem? _journeyDeparture;
  List<ServiceJourneyCall>? _journeyCalls;
  bool _journeyLoading = false;
  String? _journeyError;
  Timer? _journeyTimer;

  /// Set when the user moves the map themselves: the camera stops chasing the
  /// open journey's vehicle until another journey is opened.
  bool _followReleased = false;

  /// Tariff zone polygons are fetched lazily, the first time they are shown.
  bool _zonesRequested = false;
  bool _zonesReady = false;

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
    _stream = VehicleStream(
      onConnect: _onStreamConnect,
      onDelta: _onDelta,
      onError: _onStreamError,
      onDone: _onStreamDone,
    )..follow(_initialBounds);
  }

  void _onStreamConnect() {
    if (!mounted) return;
    setState(() {
      _error = null;
      _connected = true;
    });
  }

  void _onStreamError(Object e) {
    if (!mounted) return;
    setState(() {
      _error = '$e';
      _connected = false;
    });
  }

  void _onStreamDone() {
    if (!mounted) return;
    setState(() => _connected = false);
  }

  void _reconnect() => _stream.restart();

  /// Camera moved: track zoom, then re-scope the feed and the markers to the
  /// new visible region.
  void _onCameraIdle() {
    final controller = _mapController;
    if (controller == null) return;
    final camera = controller.cameraPosition;
    if (camera != null) _zoom = camera.zoom;
    unawaited(_refreshForCamera());
    unawaited(_refreshStops());
  }

  /// Ordered, so the marker set is chosen against the fresh viewport.
  Future<void> _refreshForCamera() async {
    await _updateViewport();
    await _syncSymbolsToZoom();
  }

  Future<void> _updateViewport() async {
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
      // While the journey is being followed, the feed covers the whole journey
      // so its vehicle stays in it wherever it is along the route. Once the
      // user takes over the camera, the feed follows the viewport again.
      _stream.follow(_followReleased ? bounds : (_journeyBounds() ?? bounds));
    } catch (e) {
      debugPrint('getVisibleRegion failed: $e');
    }
  }

  Future<void> _onDelta(VehicleDelta delta) async {
    final now = DateTime.now();
    // The feed is bounds-scoped, so anything outside the box it now covers is
    // left over from an earlier viewport: drop it instead of carrying it, and
    // of drawing it in the clusters, forever.
    final covered = _stream.subscribedBounds;
    if (covered != null) {
      _vehicles.removeWhere((_, a) => !_within(covered, a.current));
    }
    // Removed vehicles simply drop out of the marker set and the source data;
    // there is no per-marker handle to release any more.
    for (final removedId in delta.removed) {
      _vehicles.remove(removedId);
    }
    // The open journey's own vehicle moving is what re-centers the map.
    final followedJourney = _journeyDeparture?.serviceJourneyGid;
    var journeyMoved = false;
    for (final vehicle in delta.updated) {
      if (followedJourney != null &&
          vehicle.serviceJourneyGid == followedJourney) {
        journeyMoved = true;
      }
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
    unawaited(_syncSymbolsToZoom());
    _scheduleClusterRefresh();
    // Re-center on each live update of that vehicle rather than on a clock, so
    // the map stays free to move between them.
    if (journeyMoved) unawaited(_followJourney());
  }

  static bool _within(LatLngBounds bounds, VehiclePosition v) =>
      v.latitude >= bounds.southwest.latitude &&
      v.latitude <= bounds.northeast.latitude &&
      v.longitude >= bounds.southwest.longitude &&
      v.longitude <= bounds.northeast.longitude;

  bool _inViewport(VehiclePosition v) => _within(_viewport, v);

  /// Short names / designations of the lines the map is highlighting. Empty
  /// when no stop is selected, which means nothing is dimmed.
  ///
  /// With a next-stop chip active, only the lines still listed under it count,
  /// so the vehicles fade in step with the filtered list.
  Set<String> _selectedLineNames() {
    // An open journey highlights its own line and leaves the rest dimmed.
    final journey = _journeyDeparture;
    if (journey != null) return _lineNames(journey);
    final response = _departures;
    if (response == null) return const {};
    final filter = _nextStopFilter;
    final names = <String>{};
    for (final departure in response.departures) {
      if (filter != null && departure.nextStop != filter) continue;
      names.addAll(_lineNames(departure));
    }
    return names;
  }

  /// Short name and designation of a line, normalized for comparison.
  static Set<String> _lineNames(DepartureItem departure) => {
    for (final name in [departure.lineShortName, departure.lineDesignation])
      if (name.trim().isNotEmpty) name.trim().toLowerCase(),
  };

  /// False when a stop is selected and this vehicle's line does not serve it,
  /// i.e. its icon should be dimmed.
  static bool _servesSelection(VehiclePosition v, Set<String> selected) {
    if (selected.isEmpty) return true;
    return selected.contains((v.lineShortName ?? '').trim().toLowerCase());
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
      _placedMarkers = const {};
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
    final wanted = candidates.take(_options.maxAnimatedVehicles).toList();
    // Markers drawn for the first time (a new vehicle, or one that re-entered
    // the viewport or the animation cap) appear where they are instead of
    // gliding in from wherever they were last rendered. Later deltas animate.
    for (final a in wanted) {
      if (!_placedMarkers.contains(a.current.vehicleId)) a.settle();
    }
    _wantedMarkers = {for (final a in wanted) a.current.vehicleId};
    _placedMarkers = _wantedMarkers;
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
    final selected = _selectedLineNames();
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
                'opacity': _servesSelection(v, selected) ? 1.0 : _dimOpacity,
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

  /// Re-pushes both vehicle sources so the selection's dimming takes effect.
  /// Only the active one (markers above the animation zoom, dots below) does
  /// any work; the other returns immediately.
  void _refreshVehicleSources() {
    unawaited(_refreshClusterSource());
    unawaited(_refreshMarkerSource());
  }

  /// Features for the marker layers. The layers are data-driven, so rotating,
  /// colouring and labelling happen on the GPU without further calls.
  Map<String, dynamic> _markerFeatureCollection() {
    final features = <Map<String, dynamic>>[];
    final selected = _selectedLineNames();
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
          'opacity': _servesSelection(animated.current, selected)
              ? 1.0
              : _dimOpacity,
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
        iconOpacity: [Expressions.get, 'opacity'],
        iconAllowOverlap: true,
        iconIgnorePlacement: true,
        textField: [Expressions.get, 'label'],
        textColor: [Expressions.get, 'textColor'],
        textOpacity: [Expressions.get, 'opacity'],
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
        iconOpacity: [Expressions.get, 'opacity'],
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
      _stopsLabelsLayerId,
      _stopsLayerId,
      _stopAreaLabelsLayerId,
      _stopAreaCirclesLayerId,
    ]) {
      try {
        await controller.removeLayer(layerId);
      } catch (e) {
        // Absent layers are fine: clustering may be off.
        debugPrint('removeLayer $layerId failed: $e');
      }
    }
    for (final sourceId in [
      _markerSourceId,
      _clusterSourceId,
      _stopsSourceId,
      _stopAreasSourceId,
    ]) {
      try {
        await controller.removeSource(sourceId);
      } catch (e) {
        debugPrint('removeSource failed: $e');
      }
    }
    if (!_styleReady) return;
    try {
      await _setupStopsLayer(controller);
      await _setupClusterLayers(controller);
      await _setupMarkerLayers(controller);
    } catch (e) {
      debugPrint('layer rebuild failed: $e');
    }
    _updateWantedMarkers();
    await _applyLayerVisibility();
    await _refreshClusterSource();
    await _refreshMarkerSource();
    await _refreshStops();
  }

  /// Rounded-rect template behind stop-area labels. 1 pixel per unit is
  /// enough: `icon-text-fit: both` scales it to the text bounds.
  Future<void> _ensureStopTagImage(MapLibreMapController controller) async {
    const w = 32.0;
    const h = 8.0;
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    canvas.drawRRect(
      ui.RRect.fromRectAndRadius(
        const ui.Rect.fromLTWH(0, 0, w, h),
        const ui.Radius.circular(3),
      ),
      ui.Paint()..color = const ui.Color(0xFFECEFF1),
    );
    canvas.drawRRect(
      ui.RRect.fromRectAndRadius(
        const ui.Rect.fromLTWH(0, 0, w, h),
        const ui.Radius.circular(3),
      ),
      ui.Paint()
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = const ui.Color(0xFF78909C),
    );
    final picture = recorder.endRecording();
    final image = await picture.toImage(w.toInt(), h.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    if (bytes == null) return;
    await controller.addImage(_stopTagImageName, bytes.buffer.asUint8List());
  }

  /// Grey dots (stop areas) from 13 up, growing into labelled circles as
  /// the user zooms in; platforms (stop points) appear really close up
  /// with their platform/name label inside the dot.
  Future<void> _setupStopsLayer(
    MapLibreMapController controller,
  ) async {
    // --- Stop areas: grey dots below 16, labelled circles above. ---
    await controller.addSource(
      _stopAreasSourceId,
      GeojsonSourceProperties(
        data: {
          'type': 'FeatureCollection',
          'features': const [],
        },
      ),
    );
    await controller.addCircleLayer(
      _stopAreasSourceId,
      _stopAreaCirclesLayerId,
      const CircleLayerProperties(
        circleRadius: [
          Expressions.interpolate,
          ['linear'],
          [Expressions.zoom],
          13,
          3.5,
          16,
          18,
        ],
        circleColor: '#CFD8DC',
        circleOpacity: [
          Expressions.interpolate,
          ['linear'],
          [Expressions.zoom],
          13,
          0.9,
          16,
          0.9,
        ],
        circleStrokeWidth: 1.25,
        circleStrokeColor: '#78909C',
      ),
      minzoom: _stopsMinZoom,
      maxzoom: _stopPointsMinZoom,
    );
    // Stop area name inside an auto-width box replaces the circle at 16+.
    // `icon-text-fit: both` stretches a small template image to the text
    // dimensions, so the box hugs the label with no custom sizing logic.
    await controller.addSymbolLayer(
      _stopAreasSourceId,
      _stopAreaLabelsLayerId,
      SymbolLayerProperties(
        iconImage: _stopTagImageName,
        iconTextFit: 'both',
        iconTextFitPadding: [4, 8, 4, 8],
        iconAllowOverlap: false,
        iconIgnorePlacement: true,
        textField: [Expressions.get, 'name'],
        textSize: 11,
        textColor: '#263238',
        textAllowOverlap: false,
        textIgnorePlacement: true,
      ),
      minzoom: _stopPointsMinZoom,
    );

    // --- Stop points (platforms): small labelled dots, really close up. ---
    await controller.addSource(
      _stopsSourceId,
      GeojsonSourceProperties(
        data: {
          'type': 'FeatureCollection',
          'features': const [],
        },
      ),
    );
    await controller.addCircleLayer(
      _stopsSourceId,
      _stopsLayerId,
      const CircleLayerProperties(
        circleRadius: 12,
        circleColor: '#ECEFF1',
        circleOpacity: 0.95,
        circleStrokeWidth: 1.25,
        circleStrokeColor: '#78909C',
      ),
      minzoom: _stopPointsMinZoom,
    );
    // Platform letter (name fallback) centered inside the point's circle.
    await controller.addSymbolLayer(
      _stopsSourceId,
      _stopsLabelsLayerId,
      const SymbolLayerProperties(
        textField: [Expressions.get, 'label'],
        textSize: 10,
        textColor: '#263238',
        textHaloColor: '#FFFFFF',
        textHaloWidth: 0.8,
        textAllowOverlap: true,
        textIgnorePlacement: true,
      ),
      minzoom: _stopPointsMinZoom,
    );
    _stopsReady = true;
  }

  /// Adds the layer that draws the open journey's own stops. The general stop
  /// layers are hidden while it is shown, so exactly one set of stops is on the
  /// map at a time.
  Future<void> _setupJourneyStopsLayer(
    MapLibreMapController controller,
  ) async {
    await controller.addSource(
      _journeyStopsSourceId,
      GeojsonSourceProperties(data: _emptyFeatureCollectionMap),
    );
    // Color and border come per feature, from the line the journey runs on.
    await controller.addCircleLayer(
      _journeyStopsSourceId,
      _journeyStopsLayerId,
      CircleLayerProperties(
        circleRadius: 7,
        circleColor: [Expressions.get, 'color'],
        circleStrokeWidth: 2,
        circleStrokeColor: [Expressions.get, 'borderColor'],
      ),
    );
  }

  /// Pushes the open journey's calls as its own stops, in the line's colors.
  /// Empty when no journey is open, or its calls carry no geometry.
  Future<void> _refreshJourneyStops() async {
    final controller = _mapController;
    if (controller == null || !_styleReady) return;
    final departure = _journeyDeparture;
    final calls = _journeyCalls;
    Map<String, dynamic> data = _emptyFeatureCollectionMap;
    if (departure != null && calls != null) {
      final color = departure.backgroundColor ?? '#1d4ed8';
      final border =
          departure.borderColor ?? departure.foregroundColor ?? '#ffffff';
      data = {
        'type': 'FeatureCollection',
        'features': [
          for (final call in calls)
            if (call.latitude != null && call.longitude != null)
              {
                'type': 'Feature',
                'properties': {
                  'name': call.name,
                  'color': color,
                  'borderColor': border,
                },
                'geometry': {
                  'type': 'Point',
                  'coordinates': [call.longitude, call.latitude],
                },
              },
        ],
      };
    }
    try {
      await controller.setGeoJsonSource(_journeyStopsSourceId, data);
    } catch (e) {
      debugPrint('journey stops update failed: $e');
    }
    await _applyLayerVisibility();
  }

  /// Refreshes the stops sources from the transit DB for the current
  /// viewport — only when zoomed in, to keep queries bounded. Stop areas
  /// feed the zoom 13+ dots; stop points (platforms) join at 16+.
  Future<void> _refreshStops() async {
    if (!_stopsReady ||
        !_options.showStops ||
        // The open journey draws its own stops instead.
        _journeyDeparture != null ||
        _zoom <= _stopsMinZoom) {
      // Nothing is drawn, so nothing should be tappable either.
      _stopAreas = const [];
      _stopPoints = const [];
      return;
    }
    final controller = _mapController;
    if (controller == null) return;
    try {
      final areas = await client.transit.getStopAreasInBounds(
        north: _viewport.northeast.latitude,
        south: _viewport.southwest.latitude,
        east: _viewport.northeast.longitude,
        west: _viewport.southwest.longitude,
      );
      _stopAreas = areas;
      // Cleared before the platform fetch so a stale list cannot answer taps.
      _stopPoints = const [];
      await controller.setGeoJsonSource(_stopAreasSourceId, {
        'type': 'FeatureCollection',
        'features': [
          for (final a in areas)
            {
              'type': 'Feature',
              'id': a.externalId,
              'properties': {
                'name': a.name,
                'gid': a.externalId,
                'lat': a.latitude,
                'lon': a.longitude,
              },
              'geometry': {
                'type': 'Point',
                'coordinates': [a.longitude, a.latitude],
              },
            },
        ],
      });

      if (_zoom >= _stopPointsMinZoom) {
        final stops = await client.transit.getStopPointsInBounds(
          north: _viewport.northeast.latitude,
          south: _viewport.southwest.latitude,
          east: _viewport.northeast.longitude,
          west: _viewport.southwest.longitude,
        );
        _stopPoints = stops;
        await controller.setGeoJsonSource(_stopsSourceId, {
          'type': 'FeatureCollection',
          'features': [
            for (final s in stops)
              {
                'type': 'Feature',
                'id': s.externalId,
                'properties': {
                  'label': (s.platform?.isNotEmpty ?? false)
                      ? s.platform
                      : s.name,
                  'gid': s.externalId,
                  'lat': s.latitude,
                  'lon': s.longitude,
                },
                'geometry': {
                  'type': 'Point',
                  'coordinates': [s.longitude, s.latitude],
                },
              },
          ],
        });
      }
    } catch (e) {
      debugPrint('_stop refresh failed: $e');
    }
  }

  /// Tap on the map.
  ///
  /// A stop point opens a departure list scoped to that platform. A stop area
  /// zooms in so its platforms become visible and selectable. Above the
  /// platform zoom both are drawn, so the platform wins: that is what the user
  /// is aiming at.
  Future<void> _onStopClick(LatLng tapped) async {
    final probes = _zoom >= _stopPointsMinZoom
        ? const [true, false]
        : const [false];
    for (final stopPoints in probes) {
      final hit = _nearestStop(tapped: tapped, stopPoints: stopPoints);
      if (hit == null) continue;
      if (stopPoints) {
        await _selectStop(hit.gid, false);
      } else {
        await _selectStopArea(hit.gid, hit.position);
      }
      return;
    }
  }

  /// Nearest drawn stop to [tapped], within the tap tolerance.
  ///
  /// Replaces MapLibre's exact-point hit test: the stop-area dots are only a
  /// few pixels across at low zoom, which made them nearly impossible to tap.
  ({String gid, LatLng position})? _nearestStop({
    required LatLng tapped,
    required bool stopPoints,
  }) {
    final tolerance = _tapToleranceDegrees();
    if (tolerance <= 0) return null;
    final cosLat = math.cos(tapped.latitude * math.pi / 180);

    ({String gid, LatLng position})? best;
    var bestDistance = double.infinity;

    void consider(String gid, double latitude, double longitude) {
      final dLat = latitude - tapped.latitude;
      final dLon = (longitude - tapped.longitude) * cosLat;
      final distance = math.sqrt(dLat * dLat + dLon * dLon);
      if (distance > tolerance || distance >= bestDistance) return;
      bestDistance = distance;
      best = (gid: gid, position: LatLng(latitude, longitude));
    }

    if (stopPoints) {
      for (final stop in _stopPoints) {
        consider(stop.externalId, stop.latitude, stop.longitude);
      }
    } else {
      for (final area in _stopAreas) {
        consider(area.externalId, area.latitude, area.longitude);
      }
    }
    return best;
  }

  /// Drags the panel chrome to resize the bottom sheet. The list drives the
  /// sheet on its own; the header and chip bar sit outside that scrollable, so
  /// without this they would ignore vertical drags entirely.
  void _onSheetDrag(DragUpdateDetails details) {
    if (!_sheetController.isAttached) return;
    final height = _sheetParentHeightPx;
    if (height <= 0) return;
    final next = (_sheetController.size - details.delta.dy / height).clamp(
      _sheetMinSize,
      _sheetMaxSize,
    );
    _sheetController.jumpTo(next);
  }

  /// The sheet's own snap does not apply to programmatic moves, so a chrome
  /// drag has to settle itself: nearest size, or a whole step in the direction
  /// of a flick.
  void _onSheetDragEnd(DragEndDetails details) {
    if (!_sheetController.isAttached) return;
    final current = _sheetController.size;
    final velocity = details.velocity.pixelsPerSecond.dy;
    final target = velocity.abs() > _sheetFlingVelocity
        ? _stepSheetSize(current, velocity > 0 ? -1 : 1)
        : _nearestSheetSize(current);
    unawaited(_animateSheetTo(target));
  }

  /// Snap size nearest to [current].
  static double _nearestSheetSize(double current) {
    var best = _sheetSnapSizes.first;
    var bestDelta = (best - current).abs();
    for (final size in _sheetSnapSizes.skip(1)) {
      final delta = (size - current).abs();
      if (delta >= bestDelta) continue;
      best = size;
      bestDelta = delta;
    }
    return best;
  }

  /// Next snap size in [step]'s direction: -1 collapses, 1 expands.
  static double _stepSheetSize(double current, int step) {
    if (step < 0) {
      for (final size in _sheetSnapSizes) {
        if (size < current - _sheetSizeEpsilon) return size;
      }
      return _sheetSnapSizes.first;
    }
    for (final size in _sheetSnapSizes.reversed) {
      if (size > current + _sheetSizeEpsilon) return size;
    }
    return _sheetSnapSizes.last;
  }

  Future<void> _animateSheetTo(double size) async {
    if (!_sheetController.isAttached) return;
    try {
      await _sheetController.animateTo(
        size,
        duration: _sheetSnapDuration,
        curve: Curves.easeOutCubic,
      );
    } catch (_) {
      // The sheet was closed mid-animation.
    }
  }

  /// The tap tolerance in degrees of latitude, derived from the visible region
  /// so the target stays a constant size on screen at any zoom.
  double _tapToleranceDegrees() {
    final spanDegrees =
        _viewport.northeast.longitude - _viewport.southwest.longitude;
    if (spanDegrees <= 0 || _mapWidthPx <= 0) return 0;
    final metresPerDegreeLon =
        111320.0 * math.cos(_viewportCenter.latitude * math.pi / 180);
    final metresPerPixel = spanDegrees * metresPerDegreeLon / _mapWidthPx;
    return metresPerPixel * _stopTapRadius / 111320.0;
  }

  /// Selects a stop area and zooms in so its platforms become visible.
  ///
  /// The area's own departures are shown straight away; zooming in is what
  /// then lets the user pick a single platform instead.
  Future<void> _selectStopArea(String gid, LatLng position) async {
    unawaited(_selectStop(gid, true));
    final controller = _mapController;
    if (controller == null) return;
    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(position, _stopPointsMinZoom + 0.5),
    );
  }

  /// Picking a stop from the search uses the same zoom-and-departures path as a
  /// tap on the map.
  void _onStopAreaSelected(StopSearchResult stop) {
    unawaited(
      _selectStopArea(stop.externalId, LatLng(stop.latitude, stop.longitude)),
    );
  }

  /// Loads (and caches server-side) the departures and route lines for [gid].
  ///
  /// The server streams two states: the departures first, then the same list
  /// with the full route GeoJSON. The list renders on the first one.
  Future<void> _selectStop(String gid, bool isStopArea) async {
    _journeyTimer?.cancel();
    _journeyTimer = null;
    setState(() {
      _selectionGid = gid;
      _selectionIsArea = isStopArea;
      _departures = null;
      _departuresError = null;
      _departuresLoading = true;
      _nextStopFilter = null;
      // A new stop always opens on its list, not on the previous journey.
      _journeyDeparture = null;
      _journeyCalls = null;
      _journeyError = null;
      _journeyLoading = false;
    });
    // Re-subscribing also refreshes the list, so the periodic refresh keeps the
    // departures current without the user touching anything.
    _departuresTimer?.cancel();
    _departuresTimer = Timer.periodic(
      _departuresRefresh,
      (_) => unawaited(_autoRefresh()),
    );
    await _subscribe(gid, isStopArea);
  }

  /// Periodic refresh: re-subscribes without clearing what is on screen, so the
  /// list does not flash a spinner every [_departuresRefresh].
  Future<void> _autoRefresh() async {
    final gid = _selectionGid;
    if (gid == null) return;
    await _subscribe(gid, _selectionIsArea);
  }

  Future<void> _subscribe(String gid, bool isStopArea) async {
    final previous = _departuresSubscription;
    _departuresSubscription = null;
    await previous?.cancel();
    if (!mounted || _selectionGid != gid) return;
    _departuresSubscription = client.transit
        .watchStopDepartures(gid: gid, isStopArea: isStopArea)
        .listen(
          (update) => unawaited(_onDepartures(update)),
          onError: (Object e) {
            if (!mounted || _selectionGid != gid) return;
            setState(() {
              _departuresError = '$e';
              _departuresLoading = false;
            });
          },
        );
  }

  Future<void> _onDepartures(StopDeparturesResponse update) async {
    if (!mounted) return;
    final gid = _selectionGid;
    if (gid == null || update.stopGid != gid) return;
    // Drop a filter whose next stop is no longer served, so the map cannot be
    // left showing lines the list no longer has.
    final options = nextStopFilterOptions(update);
    final filter = options.contains(_nextStopFilter) ? _nextStopFilter : null;
    setState(() {
      _departures = update;
      _departuresError = null;
      _departuresLoading = false;
      _nextStopFilter = filter;
    });
    await _pushRouteShapes();
  }

  void _setNextStopFilter(String? value) {
    if (_nextStopFilter == value) return;
    setState(() => _nextStopFilter = value);
    unawaited(_pushRouteShapes());
  }

  /// Manual refresh: shows the loading state and restarts the periodic clock.
  Future<void> _refreshSelection() async {
    final gid = _selectionGid;
    if (gid == null) return;
    await _selectStop(gid, _selectionIsArea);
  }

  void _closeSelection() {
    _departuresTimer?.cancel();
    _departuresTimer = null;
    _journeyTimer?.cancel();
    _journeyTimer = null;
    unawaited(_departuresSubscription?.cancel());
    _departuresSubscription = null;
    setState(() {
      _selectionGid = null;
      _departures = null;
      _departuresError = null;
      _departuresLoading = false;
      _nextStopFilter = null;
      _journeyDeparture = null;
      _journeyCalls = null;
      _journeyError = null;
      _journeyLoading = false;
    });
    unawaited(_pushRouteShapes());
  }

  /// Jumps from a stop point to all departures of its parent stop area. The
  /// camera is left alone: the area is already on screen.
  Future<void> _openParentStopArea() async {
    final gid = _departures?.stopAreaGid;
    if (gid == null) return;
    await _selectStop(gid, true);
  }

  /// Opens the tapped departure's journey in place of the departures list, in
  /// the same sheet or side panel. Rows the upstream gave no details handle for
  /// are inert, so they never get here.
  Future<void> _openDeparture(DepartureItem departure) async {
    if (departure.stopPointGid == null || departure.detailsReference == null) {
      return;
    }
    setState(() {
      _journeyDeparture = departure;
      _journeyCalls = null;
      _journeyError = null;
      _journeyLoading = true;
    });
    // The calls carry their own realtime times, so the timeline is refetched on
    // the same clock as the departure list.
    _journeyTimer?.cancel();
    _journeyTimer = Timer.periodic(
      _departuresRefresh,
      (_) => unawaited(_loadJourney()),
    );
    // A journey starts unlocked: the camera chases its vehicle again.
    _followReleased = false;
    // Dim the other lines right away; the feed is scoped to the journey once
    // its calls arrive.
    unawaited(_pushRouteShapes());
    await _loadJourney();
    // Frame the journey to start with; the live feed re-centers it from here.
    unawaited(_followJourney());
  }

  /// Fetches — or refetches — the open journey's calls.
  Future<void> _loadJourney({bool showLoading = false}) async {
    final departure = _journeyDeparture;
    final stopPointGid = departure?.stopPointGid;
    final detailsReference = departure?.detailsReference;
    if (departure == null || stopPointGid == null || detailsReference == null) {
      return;
    }
    if (showLoading && mounted) setState(() => _journeyLoading = true);
    try {
      final calls = await client.transit.getServiceJourneyCalls(
        stopPointGid: stopPointGid,
        detailsReference: detailsReference,
      );
      if (!mounted || !identical(_journeyDeparture, departure)) return;
      setState(() {
        _journeyCalls = calls;
        _journeyError = null;
        _journeyLoading = false;
      });
      // Scope the feed to the whole journey, draw only its line and stops, and
      // dim the rest. The camera is left where it is: it is framed when the
      // journey opens and on every live update of the vehicle.
      _stream.follow(_journeyBounds() ?? _viewport);
      unawaited(_refreshJourneyStops());
      unawaited(_pushRouteShapes());
    } catch (e) {
      if (!mounted || !identical(_journeyDeparture, departure)) return;
      setState(() {
        _journeyError = '$e';
        _journeyLoading = false;
      });
    }
  }

  /// Back to the departures list, which stayed loaded underneath.
  void _closeJourney() {
    _journeyTimer?.cancel();
    _journeyTimer = null;
    setState(() {
      _journeyDeparture = null;
      _journeyCalls = null;
      _journeyError = null;
      _journeyLoading = false;
    });
    // Back to the stop's own selection: feed scoped to the viewport, every
    // line's shapes and the general stops, nothing dimmed.
    _stream.follow(_viewport);
    unawaited(_refreshJourneyStops());
    unawaited(_refreshStops());
    unawaited(_pushRouteShapes());
  }

  /// Vehicle running the open journey, when the live feed covers it.
  _AnimatedVehicle? _journeyVehicle() {
    final gid = _journeyDeparture?.serviceJourneyGid;
    if (gid == null || gid.isEmpty) return null;
    for (final animated in _vehicles.values) {
      if (animated.current.serviceJourneyGid == gid) return animated;
    }
    return null;
  }

  /// Where the open journey is right now: the vehicle itself when the feed has
  /// it, otherwise the next stop it is due to call at.
  LatLng? _journeyFocus() {
    final vehicle = _journeyVehicle();
    if (vehicle != null) {
      // A marker that is animating sits between fixes: follow what is drawn.
      return _wantedMarkers.contains(vehicle.current.vehicleId)
          ? vehicle.renderedPosition
          : LatLng(vehicle.current.latitude, vehicle.current.longitude);
    }
    final calls = _journeyCalls;
    if (calls == null) return null;
    final now = DateTime.now();
    for (final call in calls) {
      final time =
          call.estimatedDepartureTime ??
          call.plannedDepartureTime ??
          call.estimatedArrivalTime ??
          call.plannedArrivalTime;
      if (time == null || time.isBefore(now)) continue;
      final latitude = call.latitude;
      final longitude = call.longitude;
      if (latitude == null || longitude == null) continue;
      return LatLng(latitude, longitude);
    }
    return null;
  }

  /// Box around the open journey's stops, wide enough to keep covering the
  /// vehicle between them.
  LatLngBounds? _journeyBounds() {
    final calls = _journeyCalls;
    if (calls == null) return null;
    double? north;
    double? south;
    double? east;
    double? west;
    for (final call in calls) {
      final latitude = call.latitude;
      final longitude = call.longitude;
      if (latitude == null || longitude == null) continue;
      north = north == null ? latitude : math.max(north, latitude);
      south = south == null ? latitude : math.min(south, latitude);
      east = east == null ? longitude : math.max(east, longitude);
      west = west == null ? longitude : math.min(west, longitude);
    }
    if (north == null || south == null || east == null || west == null) {
      return null;
    }
    final latPad = (north - south) * _journeyPadding + 0.01;
    final lngPad = (east - west) * _journeyPadding + 0.01;
    return LatLngBounds(
      southwest: LatLng(south - latPad, west - lngPad),
      northeast: LatLng(north + latPad, east + lngPad),
    );
  }

  /// Re-centers the map on the open journey's vehicle, gliding after it.
  Future<void> _followJourney() async {
    final controller = _mapController;
    final focus = _journeyFocus();
    if (controller == null || focus == null || _followReleased) return;
    try {
      await controller.animateCamera(
        CameraUpdate.newLatLng(_aboveSheet(focus)),
        duration: _followInterval,
      );
    } catch (e) {
      // The map can go away while a move is in flight.
      debugPrint('journey follow failed: $e');
    }
  }

  /// The user moved the map: stop chasing the open journey's vehicle until
  /// another journey is opened.
  void _releaseJourneyFollow() => _followReleased = true;

  /// [target] moved south by half of what the bottom sheet covers, so that when
  /// the camera aims at it the vehicle lands in the middle of the map left
  /// visible above the sheet, not of the whole map.
  LatLng _aboveSheet(LatLng target) {
    if (!_sheetController.isAttached) return target;
    final sheet = _sheetController.size.clamp(0.0, 1.0);
    final span = _viewport.northeast.latitude - _viewport.southwest.latitude;
    if (sheet <= 0 || !span.isFinite || span <= 0) return target;
    final latitude = target.latitude - span * sheet / 2;
    return LatLng(latitude.clamp(-90.0, 90.0).toDouble(), target.longitude);
  }

  /// The selection pane: the open journey's timeline, otherwise the departures
  /// list. A bottom sheet on narrow layouts, a docked panel on wide ones.
  Widget _selectionPanel({ScrollController? scrollController}) {
    final departure = _journeyDeparture;
    if (departure != null) {
      return ServiceJourneyTimelinePanel(
        departure: departure,
        calls: _journeyCalls,
        loading: _journeyLoading,
        error: _journeyError,
        onBack: _closeJourney,
        onRefresh: () => unawaited(_loadJourney(showLoading: true)),
        scrollController: scrollController,
      );
    }
    return StopDeparturesPanel(
      data: _departures,
      loading: _departuresLoading,
      error: _departuresError,
      onClose: _closeSelection,
      onRefresh: _refreshSelection,
      onOpenDeparture: _openDeparture,
      onOpenStopArea: _departures?.stopAreaGid == null
          ? null
          : _openParentStopArea,
      nextStopFilter: _nextStopFilter,
      onNextStopFilterChanged: _setNextStopFilter,
      scrollController: scrollController,
    );
  }

  /// Applies new view options, rebuilding the layers only when a setting that
  /// is fixed at creation time changed.
  void _applyOptions(VehicleViewOptions next) {
    final needsRebuild = !_options.sameLayers(next);
    final stopsToggled = _options.showStops != next.showStops;
    final zonesToggledOn = !_options.showZones && next.showZones;
    setState(() => _options = next);
    if (needsRebuild) {
      unawaited(_rebuildLayers());
      return;
    }
    unawaited(_applyLayerVisibility());
    if (zonesToggledOn) unawaited(_loadZones());
    if (stopsToggled) unawaited(_refreshStops());
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
        // Vehicles unrelated to the selected stop fade out.
        circleOpacity: [Expressions.get, 'opacity'],
        circleStrokeWidth: 1.5,
        circleStrokeColor: '#ffffff',
        circleStrokeOpacity: [Expressions.get, 'opacity'],
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
        textOpacity: [Expressions.get, 'opacity'],
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
        iconOpacity: [Expressions.get, 'opacity'],
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

  /// Route lines and tariff zones: created once per style load, then shown or
  /// hidden from the view options.
  Future<void> _setupRouteLayers(MapLibreMapController controller) async {
    await controller.addSource(
      _routesSourceId,
      GeojsonSourceProperties(data: _emptyFeatureCollectionMap),
    );
    await controller.addLineLayer(
      _routesSourceId,
      _routesCasingLayerId,
      const LineLayerProperties(
        lineColor: '#ffffff',
        lineWidth: 7,
        lineOpacity: 0.8,
        lineCap: 'round',
        lineJoin: 'round',
      ),
    );
    await controller.addLineLayer(
      _routesSourceId,
      _routesLayerId,
      const LineLayerProperties(
        lineColor: [Expressions.get, 'color'],
        lineWidth: 3.5,
        lineOpacity: 0.95,
        lineCap: 'round',
        lineJoin: 'round',
      ),
    );
  }

  Future<void> _setupZoneLayers(MapLibreMapController controller) async {
    await controller.addSource(
      _zonesSourceId,
      GeojsonSourceProperties(data: _emptyFeatureCollectionMap),
    );
    await controller.addFillLayer(
      _zonesSourceId,
      _zonesFillLayerId,
      const FillLayerProperties(
        fillColor: [Expressions.get, 'color'],
        fillOpacity: 0.12,
      ),
    );
    await controller.addLineLayer(
      _zonesSourceId,
      _zonesOutlineLayerId,
      const LineLayerProperties(
        lineColor: [Expressions.get, 'color'],
        lineWidth: 1.5,
        lineOpacity: 0.6,
      ),
    );
  }

  /// Lazily fetches tariff zones once, the first time they are shown.
  Future<void> _loadZones() async {
    if (_zonesRequested) return;
    final controller = _mapController;
    if (controller == null || !_styleReady) return;
    _zonesRequested = true;
    try {
      final zones = await client.transit.getZones();
      final features = <Map<String, dynamic>>[];
      for (final zone in zones) {
        final geometryGeoJson = zone.geometryGeoJson;
        if (geometryGeoJson == null || geometryGeoJson.isEmpty) continue;
        Object? geometry;
        try {
          geometry = jsonDecode(geometryGeoJson);
        } catch (_) {
          continue;
        }
        features.add({
          'type': 'Feature',
          'id': zone.externalId,
          'properties': {
            'name': zone.name,
            'color': (zone.color?.isNotEmpty ?? false) ? zone.color : '#7E57C2',
          },
          'geometry': geometry,
        });
      }
      await controller.setGeoJsonSource(_zonesSourceId, {
        'type': 'FeatureCollection',
        'features': features,
      });
      _zonesReady = true;
      await _applyLayerVisibility();
    } catch (e) {
      debugPrint('zone load failed: $e');
      _zonesRequested = false;
    }
  }

  /// Pushes the selected stop's route lines into the map source. A `String`
  /// data value would be fetched as a remote URL, so this always passes a map.
  ///
  /// A next-stop filter narrows this to the same lines the list shows.
  Future<void> _pushRouteShapes() async {
    final controller = _mapController;
    if (controller == null || !_styleReady) return;
    Map<String, dynamic> data = _emptyFeatureCollectionMap;
    final geoJson = _departures?.routeShapesGeoJson;
    if (geoJson != null && geoJson.isNotEmpty) {
      try {
        data = jsonDecode(geoJson) as Map<String, dynamic>;
      } catch (e) {
        debugPrint('route shapes decode failed: $e');
      }
    }
    final filter = _nextStopFilter;
    if (filter != null) data = _filterRoutesByNextStop(data, filter);
    // An open journey draws only its own line.
    final journey = _journeyDeparture;
    if (journey != null) {
      data = _filterRoutesByLine(data, journey.lineShortName);
    }
    try {
      await controller.setGeoJsonSource(_routesSourceId, data);
    } catch (e) {
      debugPrint('route source update failed: $e');
    }
    // The selection also changes which vehicles are dimmed.
    _refreshVehicleSources();
    await _applyLayerVisibility();
  }

  /// Keeps only the route features whose journey continues to [nextStop].
  static Map<String, dynamic> _filterRoutesByNextStop(
    Map<String, dynamic> collection,
    String nextStop,
  ) {
    return _filterRoutes(
      collection,
      (feature) => _routeString(feature, 'nextStop') == nextStop,
    );
  }

  /// Keeps only the route features drawn for the line [shortName].
  static Map<String, dynamic> _filterRoutesByLine(
    Map<String, dynamic> collection,
    String shortName,
  ) {
    return _filterRoutes(
      collection,
      (feature) => _routeString(feature, 'shortName') == shortName,
    );
  }

  static Map<String, dynamic> _filterRoutes(
    Map<String, dynamic> collection,
    bool Function(Map<String, dynamic> feature) keep,
  ) {
    final features = collection['features'];
    if (features is! List) return collection;
    return {
      ...collection,
      'features': [
        for (final feature in features)
          if (feature is Map<String, dynamic> && keep(feature)) feature,
      ],
    };
  }

  static Object? _routeProperty(Map<String, dynamic> feature, String key) {
    final properties = feature['properties'];
    return properties is Map<String, dynamic> ? properties[key] : null;
  }

  static String? _routeString(Map<String, dynamic> feature, String key) {
    final value = _routeProperty(feature, key);
    return value is String ? value : null;
  }

  /// Wires the `showRoutes` / `showStops` / `showZones` toggles to the layers
  /// they control.
  Future<void> _applyLayerVisibility() async {
    final controller = _mapController;
    if (controller == null || !_styleReady) return;
    final hasRoutes =
        _options.showRoutes && (_departures?.departures.isNotEmpty ?? false);
    final zonesVisible = _options.showZones && _zonesReady;
    // An open journey replaces the general stops with its own.
    final journeyOpen = _journeyDeparture != null;
    final stopsVisible = _options.showStops && !journeyOpen;
    final journeyStopsVisible =
        _options.showStops &&
        journeyOpen &&
        (_journeyCalls?.isNotEmpty ?? false);
    final entries = <(String, bool)>[
      (_routesCasingLayerId, hasRoutes),
      (_routesLayerId, hasRoutes),
      (_stopAreaCirclesLayerId, stopsVisible),
      (_stopAreaLabelsLayerId, stopsVisible),
      (_stopsLayerId, stopsVisible),
      (_stopsLabelsLayerId, stopsVisible),
      (_journeyStopsLayerId, journeyStopsVisible),
      (_zonesFillLayerId, zonesVisible),
      (_zonesOutlineLayerId, zonesVisible),
    ];
    for (final (layerId, visible) in entries) {
      try {
        await controller.setLayerVisibility(layerId, visible);
      } catch (e) {
        debugPrint('setLayerVisibility $layerId failed: $e');
      }
    }
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
      await _ensureStopTagImage(controller);
    } catch (e) {
      debugPrint('marker image setup failed: $e');
    }
    try {
      await _setupZoneLayers(controller);
      await _setupRouteLayers(controller);
      await _setupStopsLayer(controller);
      await _setupJourneyStopsLayer(controller);
      await _setupClusterLayers(controller);
      await _setupMarkerLayers(controller);
    } catch (e) {
      debugPrint('layer setup failed: $e');
    }
    await _pushRouteShapes();
    await _refreshJourneyStops();
    if (_options.showZones) unawaited(_loadZones());
    await _applyLayerVisibility();
    // The map now has a size: shrink the feed from the startup box to the
    // viewport the user actually sees.
    await _updateViewport();
    await _syncSymbolsToZoom();
    await _refreshStops();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _sourceTimer?.cancel();
    _stream.dispose();
    _departuresTimer?.cancel();
    _journeyTimer?.cancel();
    _departuresSubscription?.cancel();
    super.dispose();
  }

  /// Map fills the content area; on wide layouts the departures panel docks
  /// beside it, on narrow layouts it slides up as a bottom sheet.
  Widget _buildContent(BoxConstraints constraints) {
    final wide = constraints.maxWidth >= _wideLayoutBreakpoint;
    // Remember the map's own width, so a tap tolerance in logical pixels can be
    // converted to degrees.
    final panelWidth = wide && _selectionGid != null
        ? _departuresPanelWidth
        : 0.0;
    _mapWidthPx = math.max(1, constraints.maxWidth - panelWidth);
    _sheetParentHeightPx = math.max(1, constraints.maxHeight);
    final map = Stack(
      children: [
        Listener(
          // A finger moving over the map is the user taking over the camera, so
          // the follow stops. Our own camera moves never come through here.
          onPointerMove: (_) => _releaseJourneyFollow(),
          child: MapLibreMap(
            initialCameraPosition: _initialCamera,
            styleString: MapLibreStyles.openfreemapLiberty,
            onMapCreated: (controller) => _mapController = controller,
            onStyleLoadedCallback: _onStyleLoaded,
            onCameraIdle: _onCameraIdle,
            trackCameraPosition: true,
            // Show every vehicle even when markers collide.
            annotationOrder: const [AnnotationType.symbol],
            // Circle taps only reach onMapClick with this flag on.
            featureTapsTriggersMapClick: true,
            onMapClick: (point, latLng) => _onStopClick(latLng),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: SafeArea(
            minimum: const EdgeInsets.all(12),
            bottom: false,
            right: false,
            child: IconButton.filledTonal(
              onPressed: _openViewOptions,
              tooltip: 'View options',
              icon: Icon(
                _options.showsAllKinds ? Icons.tune : Icons.filter_alt_off,
              ),
            ),
          ),
        ),
        if (wide)
          Positioned(
            top: 0,
            left: 68,
            right: 68,
            child: SafeArea(
              minimum: const EdgeInsets.only(top: 12),
              left: false,
              right: false,
              bottom: false,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: StopAreaSearchBar(
                    wide: true,
                    onStopAreaSelected: _onStopAreaSelected,
                    recentSearches: stopSearchStore.recentQueries,
                    onSearchCommitted: stopSearchStore.recordSearch,
                  ),
                ),
              ),
            ),
          )
        else if (_selectionGid == null)
          // Narrow: the search peeks from the bottom, so the bar is directly
          // tappable without a trigger. It gives way to the departures sheet
          // once a stop is selected.
          Positioned.fill(
            child: StopAreaSearchBar(
              wide: false,
              onStopAreaSelected: _onStopAreaSelected,
              recentSearches: stopSearchStore.recentQueries,
              onSearchCommitted: stopSearchStore.recordSearch,
            ),
          ),
        if (!wide && _selectionGid != null)
          Positioned.fill(
            child: DraggableScrollableSheet(
              controller: _sheetController,
              initialChildSize: _sheetInitialSize,
              minChildSize: _sheetMinSize,
              maxChildSize: _sheetMaxSize,
              // These are the sizes the sheet settles on when a drag is released.
              snap: true,
              snapSizes: _sheetSnapSizes,
              snapAnimationDuration: _sheetSnapDuration,
              builder: (context, scrollController) => Material(
                elevation: 8,
                clipBehavior: Clip.antiAlias,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: GestureDetector(
                  // Inside the list the sheet follows the scroll itself; this
                  // catches the header and chip bar, which sit outside it.
                  onVerticalDragUpdate: _onSheetDrag,
                  onVerticalDragEnd: _onSheetDragEnd,
                  child: _selectionPanel(scrollController: scrollController),
                ),
              ),
            ),
          ),
      ],
    );

    if (!wide) return map;
    return Row(
      children: [
        Expanded(child: map),
        if (_selectionGid != null)
          SizedBox(
            width: _departuresPanelWidth,
            child: _selectionPanel(),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!_connected) _statusBanner(context),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => _buildContent(constraints),
          ),
        ),
      ],
    );
  }

  /// Shown while the live feed is not connected, with a retry. The banner is
  /// drawn under the status bar, but its content respects the top safe area.
  Widget _statusBanner(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      color: colors.errorContainer,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _error ?? 'Disconnected from the live feed.',
                  style: TextStyle(color: colors.onErrorContainer),
                ),
              ),
              TextButton(
                onPressed: _reconnect,
                child: const Text('Reconnect'),
              ),
            ],
          ),
        ),
      ),
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
///
/// A vehicle is only animated once it is on screen: [settle] places a marker
/// that is drawn for the first time at its current fix, so it does not glide in
/// from wherever it happened to be rendered last.
class _AnimatedVehicle {
  _AnimatedVehicle({required this.current, required DateTime now})
    : _lastUpdate = now {
    settle();
  }

  VehiclePosition current;

  /// Train lines show a pictogram in the marker body instead of the number.
  bool get isTrain => displayLabel.toLowerCase().contains('tåg');

  late double _fromLat;
  late double _fromLng;
  double _fromCourse = 0;

  late double _renderedLat;
  late double _renderedLng;
  double _renderedCourse = 0;

  /// Seconds into the current segment / total segment seconds.
  late double _segmentElapsed;
  late double _segmentDuration;

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

  /// Places the vehicle at its latest fix without animating: the next segment
  /// starts from there. Used when a marker is drawn for the first time, so it
  /// appears where the vehicle actually is instead of gliding in.
  void settle() {
    final course = current.course ?? _renderedCourse;
    _fromLat = current.latitude;
    _fromLng = current.longitude;
    _fromCourse = course;
    _renderedLat = current.latitude;
    _renderedLng = current.longitude;
    _renderedCourse = course;
    _segmentElapsed = 1;
    _segmentDuration = 1;
    _speedMs = 0;
    _segmentLenMeters = 0;
  }

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
