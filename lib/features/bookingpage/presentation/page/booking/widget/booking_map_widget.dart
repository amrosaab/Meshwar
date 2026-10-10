// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart' as fmlt;

import '../../../../../../common/common.dart';
import '../../../../../../common/vehicle_marker_helper.dart';
import '../../../../../../common/sedan_pose.dart';
import '../../../../../../common/route_camera.dart';
import '../../../../../../core/utils/avatar_glow.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../application/booking_bloc.dart';
import 'marker_widget.dart';
import 'driver_search_field.dart';

class BookingMapWidget extends StatefulWidget {
  final BuildContext cont;
  final String mapType;
  final double bottomPadding;
  final Size? viewportSize;

  const BookingMapWidget({
    super.key,
    required this.cont,
    required this.mapType,
    this.bottomPadding = 0,
    this.viewportSize,
  });

  @override
  State<BookingMapWidget> createState() => _BookingMapWidgetState();
}

class _BookingMapWidgetState extends State<BookingMapWidget>
    with SingleTickerProviderStateMixin {
  late final BookingBloc _bookingBloc;
  Timer? _cameraFitDebounce;
  int? _lastRequestedFit;
  int? _lastCompletedFit;
  bool _wasSearching = false;
  bool _userMovedMap = false;
  final ValueNotifier<Offset?> _searchAnchor = ValueNotifier(null);
  final ValueNotifier<_SearchMapTexture?> _searchTexture = ValueNotifier(null);
  final ValueNotifier<int> _searchViewRevision = ValueNotifier(0);
  double _searchZoom = 15;
  double _searchRotation = 0;
  double _vehicleCameraBearing = 0;
  double _vehicleCameraTilt = 0;
  final GlobalKey _flutterMapCaptureKey = GlobalKey();
  Timer? _searchProjectionTimer;
  Timer? _searchSnapshotTimer;
  bool _capturingSearch = false;
  int _searchCameraRevision = 0;
  bool _projectingSearch = false;
  bool _searchFieldActive = false;

  @override
  void initState() {
    super.initState();
    _bookingBloc = widget.cont.read<BookingBloc>();
    _bookingBloc.routeCameraRequest.addListener(_showRouteOverview);
  }

  bool get _isSearching =>
      _bookingBloc.isNormalRideSearching || _bookingBloc.isBiddingRideSearching;

  @override
  void didUpdateWidget(covariant BookingMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bottomPadding != widget.bottomPadding ||
        oldWidget.viewportSize != widget.viewportSize) {
      _queueSearchProjection();
      _invalidateSearchTexture();
      _queueSearchSnapshot();
    }
  }

  void _queueSearchProjection() {
    if (!_isSearching || (_searchProjectionTimer?.isActive ?? false)) return;
    // Projection follows map gestures and sheet padding, independently of the
    // animation ticker. No map camera changes are made by the search field.
    _searchProjectionTimer =
        Timer(const Duration(milliseconds: 32), _projectSearchPickup);
  }

  void _invalidateSearchTexture() {
    _searchCameraRevision++;
    _searchSnapshotTimer?.cancel();
    _replaceSearchTexture(null);
  }

  void _replaceSearchTexture(_SearchMapTexture? next) {
    final previous = _searchTexture.value;
    _searchTexture.value = next;
    if (previous != null && previous != next) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => previous.image.dispose());
    }
  }

  void _queueSearchSnapshot() {
    if (!_isSearching) return;
    _searchSnapshotTimer?.cancel();
    _searchSnapshotTimer =
        Timer(const Duration(milliseconds: 180), _captureSearchMap);
  }

  Future<void> _captureSearchMap() async {
    if (!mounted || !_isSearching) return;
    if (_capturingSearch) {
      _queueSearchSnapshot();
      return;
    }
    final revision = _searchCameraRevision;
    final center = _searchAnchor.value;
    if (center == null) {
      _queueSearchProjection();
      _queueSearchSnapshot();
      return;
    }
    final zoom = _searchZoom;
    final rotation = _searchRotation;
    _capturingSearch = true;
    ui.Image? image;
    try {
      if (widget.mapType == 'google_map') {
        final bytes = await _bookingBloc.googleMapController?.takeSnapshot();
        if (bytes == null) return;
        final codec = await ui.instantiateImageCodec(bytes);
        try {
          image = (await codec.getNextFrame()).image;
        } finally {
          codec.dispose();
        }
      } else {
        final boundary = _flutterMapCaptureKey.currentContext
            ?.findRenderObject() as RenderRepaintBoundary?;
        if (boundary == null || boundary.debugNeedsPaint) return;
        image = await boundary.toImage();
      }
      if (mounted && _isSearching && revision == _searchCameraRevision) {
        _replaceSearchTexture(_SearchMapTexture(
            image: image, center: center, zoom: zoom, rotation: rotation));
        image = null; // The search texture notifier now owns this frame.
      }
    } catch (error) {
      debugPrint('Driver search map snapshot unavailable: $error');
    } finally {
      image?.dispose();
      _capturingSearch = false;
    }
  }

  void _searchCameraMoved({double? zoom, double? rotation, double tilt = 0}) {
    if (rotation != null && rotation.isFinite) {
      final changed =
          SedanPose.turnDelta(_vehicleCameraBearing, rotation).abs() > 0.1 ||
              (_vehicleCameraTilt - tilt).abs() > 0.1;
      _vehicleCameraBearing = rotation;
      _vehicleCameraTilt = tilt.isFinite ? tilt : 0;
      if (changed && mounted) setState(() {});
    }
    if (!_isSearching) return;
    _searchCameraRevision++;
    _searchSnapshotTimer?.cancel();
    _searchZoom = zoom ?? _searchZoom;
    _searchRotation = rotation ?? _searchRotation;
    _searchViewRevision.value++;
    _queueSearchProjection();
    // The existing texture follows the pickup's screen projection and the
    // camera's zoom/rotation while gestures run. Refresh it once they settle.
    _queueSearchSnapshot();
  }

  Future<void> _projectSearchPickup() async {
    if (!mounted || !_isSearching || _projectingSearch) return;
    final pickups = _bookingBloc.pickUpAddressList;
    final point = pickups.isNotEmpty
        ? LatLng(pickups.first.lat, pickups.first.lng)
        : _endpointPin(_bookingBloc, pickup: true);
    if (point == null) return;
    _projectingSearch = true;
    try {
      Offset? anchor;
      if (widget.mapType == 'google_map') {
        final controller = _bookingBloc.googleMapController;
        if (controller == null) return;
        final pixelRatio = defaultTargetPlatform == TargetPlatform.android
            ? MediaQuery.devicePixelRatioOf(context)
            : 1.0;
        final screen = await controller.getScreenCoordinate(point);
        // Google Maps iOS returns UIKit points; Android returns physical pixels.
        anchor = Offset(screen.x / pixelRatio, screen.y / pixelRatio);
      } else {
        anchor = _bookingBloc.fmController?.camera
            .latLngToScreenOffset(fmlt.LatLng(point.latitude, point.longitude));
      }
      if (mounted &&
          _isSearching &&
          anchor != null &&
          anchor.dx.isFinite &&
          anchor.dy.isFinite) {
        _searchAnchor.value = anchor;
      }
    } catch (_) {
      // Projection is unavailable briefly while a native map attaches.
      // onMapCreated/onMapReady and camera events retry once it is ready.
    } finally {
      _projectingSearch = false;
    }
  }

  Widget _searchField() => Positioned.fill(
        child: AnimatedBuilder(
            animation: Listenable.merge(
                [_searchAnchor, _searchTexture, _searchViewRevision]),
            builder: (context, _) {
              final center = _searchAnchor.value;
              final texture = _searchTexture.value;
              if (center == null) return const SizedBox.shrink();
              return DriverSearchField(
                  center: center,
                  mapImage: texture?.image,
                  mapImageCenter: texture?.center,
                  mapScale: texture == null
                      ? 1
                      : math.pow(2, _searchZoom - texture.zoom).toDouble(),
                  mapRotation: texture == null
                      ? 0
                      : (_searchRotation - texture.rotation) * math.pi / 180);
            }),
      );

  void _showRouteOverview() {
    _userMovedMap = false;
    _lastCompletedFit = null;
    _lastRequestedFit = null;
    _fitToRoute(
        _bookingBloc, widget.viewportSize ?? MediaQuery.sizeOf(context));
  }

  @override
  void reassemble() {
    super.reassemble();
    // Re-evaluate camera calculations after a development hot reload.
    _userMovedMap = false;
    _lastRequestedFit = null;
    _lastCompletedFit = null;
  }

  EdgeInsets _viewportPadding(Size size) => RouteCamera.viewportPadding(size,
      sheetHeight: widget.bottomPadding,
      topInset: MediaQuery.paddingOf(context).top);

  // One-shot "draw-on" for the preview route: ~0.7s the first time a route
  // appears (and again when it changes), then idle at 1.0 — the map is not
  // rebuilt once it settles.
  late final AnimationController _routeReveal = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );
  late final Animation<double> _revealCurve =
      CurvedAnimation(parent: _routeReveal, curve: Curves.easeOutCubic);
  int _lastRevealPointCount = 0;

  void _maybeStartReveal(List<LatLng> points) {
    final key = points.length < 2
        ? 0
        : Object.hash(
            points.length,
            points.first.latitude,
            points.first.longitude,
            points.last.latitude,
            points.last.longitude);
    if (key == _lastRevealPointCount) return;
    _lastRevealPointCount = key;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (points.length < 2) {
        _routeReveal.value = 0;
      } else {
        _routeReveal.forward(from: 0);
      }
    });
  }

  // Reused list instance — google_maps_flutter compares Polyline.patterns with
  // listEquals, and PatternItem has no value equality, so a fresh list every
  // build would make the polyline look "changed" and the SDK would redraw it
  // on every unrelated rebuild.
  static final List<PatternItem> _stubPattern = <PatternItem>[
    PatternItem.dot,
    PatternItem.gap(8),
  ];

  String? _polyCacheKey;
  Set<Polyline> _polyCache = const {};

  /// Modern native route for the pre-request preview, drawn entirely by the map
  /// SDK so it stays in sync with tiles and gestures:
  ///   • a soft translucent brand casing,
  ///   • a thin full-length "planned" line,
  ///   • the bold SOLID brand core that draws on pickup → drop via [reveal],
  ///   • DOTTED stubs linking the exact pickup/drop/stop pins to the road.
  ///
  /// Memoised: the same Set instance is returned across unrelated rebuilds so
  /// the map SDK sees "no change" and never redraws the route.
  Set<Polyline> _previewPolylines(List<LatLng> points, bool isDark,
      double reveal, LatLng? pickup, LatLng? drop, List<LatLng> stops) {
    if (points.length < 2) return const {};

    final revealBucket = (reveal.clamp(0.0, 1.0) * 24).round();
    final stopsKey = stops.map((s) => '${s.latitude},${s.longitude}').join(';');
    final key = '${identityHashCode(points)}|$revealBucket|$isDark|'
        '${pickup?.latitude},${pickup?.longitude}|${drop?.latitude},${drop?.longitude}|'
        '$stopsKey';
    if (key == _polyCacheKey) return _polyCache;
    _polyCacheKey = key;

    final core = _sliceByFraction(points, reveal);
    final set = <Polyline>{
      // Soft wide casing.
      Polyline(
        polylineId: const PolylineId('routeCasing'),
        points: points,
        color: AppColors.meshwarRed.withOpacity(isDark ? 0.22 : 0.16),
        width: 14,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        zIndex: 0,
      ),
      // Thin full-length "planned" line.
      Polyline(
        polylineId: const PolylineId('routeTrack'),
        points: points,
        color: AppColors.meshwarRed.withOpacity(isDark ? 0.38 : 0.28),
        width: 4,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        zIndex: 1,
      ),
      // Dotted stubs from the exact pins to the snapped road.
      // Always drawn (even for a tiny gap) so pickup and drop get the same
      // treatment — a real-distance cutoff meant the drop stub silently
      // vanished whenever the snap gap was a few metres under the pickup's.
      if (pickup != null)
        Polyline(
          polylineId: const PolylineId('routeStubPickup'),
          points: [pickup, points.first],
          color: AppColors.meshwarRed.withOpacity(0.9),
          width: 6,
          patterns: _stubPattern,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          zIndex: 2,
        ),
      if (drop != null)
        Polyline(
          polylineId: const PolylineId('routeStubDrop'),
          points: [points.last, drop],
          color: AppColors.meshwarRed.withOpacity(0.9),
          width: 6,
          patterns: _stubPattern,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          zIndex: 2,
        ),
      // Dotted stubs for intermediate stops, from each stop pin to the
      // nearest point on the routed road (a stop's geocoded pin rarely sits
      // exactly on the snapped path the way pickup/drop's route-endpoint
      // vertices do).
      for (var i = 0; i < stops.length; i++)
        Polyline(
          polylineId: PolylineId('routeStubStop$i'),
          points: [stops[i], _nearestPoint(points, stops[i])],
          color: AppColors.meshwarRed.withOpacity(0.9),
          width: 6,
          patterns: _stubPattern,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          zIndex: 2,
        ),
      // Bold SOLID core — draws on pickup → drop.
      if (core.length >= 2)
        Polyline(
          polylineId: const PolylineId('routeCore'),
          points: core,
          color: AppColors.meshwarRed,
          width: 7,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          zIndex: 3,
        ),
    };
    _polyCache = set;
    return set;
  }

  // The final destination marker is always id "drop" (exact); numbered stops
  // are "drop0", "drop1", etc. `startsWith('drop')` used to match both, so on
  // any multi-stop route this returned the first stop instead of the real
  // destination — pulling the drop-side dotted connector to the wrong pin.
  LatLng? _endpointPin(BookingBloc b, {required bool pickup}) {
    for (final m in b.markerList) {
      if (m is! Marker) continue;
      final id = m.markerId.value.toString();
      if (pickup ? id == 'pick' : id == 'drop') {
        return m.position;
      }
    }
    return null;
  }

  // Intermediate stop pins ("drop0", "drop1", ...), in stop order.
  List<LatLng> _stopPins(BookingBloc b) {
    final byIndex = <int, LatLng>{};
    for (final m in b.markerList) {
      if (m is! Marker) continue;
      final match = RegExp(r'^drop(\d+)$').firstMatch(m.markerId.value);
      if (match != null) {
        byIndex[int.parse(match.group(1)!)] = m.position;
      }
    }
    final indices = byIndex.keys.toList()..sort();
    return [for (final i in indices) byIndex[i]!];
  }

  /// The vertex of [points] closest (by simple degree distance — plenty
  /// accurate for a short visual stub) to [target].
  LatLng _nearestPoint(List<LatLng> points, LatLng target) {
    var best = points.first;
    var bestDist = double.infinity;
    for (final p in points) {
      final dLat = p.latitude - target.latitude;
      final dLng = p.longitude - target.longitude;
      final dist = dLat * dLat + dLng * dLng;
      if (dist < bestDist) {
        bestDist = dist;
        best = p;
      }
    }
    return best;
  }

  /// First [fraction] (0–1) of a polyline, by vertex count — cheap and smooth
  /// enough for a sub-second reveal.
  List<LatLng> _sliceByFraction(List<LatLng> pts, double fraction) {
    if (pts.length < 2) return const [];
    if (fraction >= 1) return pts;
    final n =
        (pts.length * fraction.clamp(0.0, 1.0)).ceil().clamp(2, pts.length);
    return pts.sublist(0, n);
  }

  @override
  void dispose() {
    _cameraFitDebounce?.cancel();
    _searchProjectionTimer?.cancel();
    _searchSnapshotTimer?.cancel();
    _searchAnchor.dispose();
    _searchTexture.value?.image.dispose();
    _searchTexture.dispose();
    _searchViewRevision.dispose();
    _bookingBloc.routeCameraRequest.removeListener(_showRouteOverview);
    _routeReveal.dispose();
    super.dispose();
  }

  // ── flutter_map marker children ──────────────────────────────────────────
  // Google Maps rasterises MarkerWidget to a bitmap in the bloc; flutter_map
  // renders live widgets here, so the pins are drawn directly and the pickup
  // gets an animated pulse.
  static bool _isPick(String id) => id == 'pick';
  static bool _isDrop(String id) => id == 'drop' || id.contains('drop');

  Widget _fmMarkerChild(dynamic marker) {
    final sedan = VehicleMarkerHelper.sedanAssetFor(marker,
        cameraBearing: _vehicleCameraBearing, cameraTilt: _vehicleCameraTilt);
    if (sedan != null) return Image.asset(sedan, width: 64, height: 64);
    final id = marker.markerId.value.toString();

    if (_isPick(id)) {
      return const AvatarGlow(
        glowColor: AppColors.meshwarRed,
        glowRadiusFactor: 1.1,
        glowCount: 3,
        child: PickupPin(size: 30),
      );
    }
    if (_isDrop(id)) {
      final stop = RegExp(r'drop(\d+)').firstMatch(id);
      return DropPin(
        size: 32,
        label: stop != null ? '${int.parse(stop.group(1)!) + 1}' : null,
      );
    }

    final asset = id.contains('truck')
        ? AppImages.truck
        : id.contains('motor_bike')
            ? AppImages.bike
            : id.contains('auto')
                ? AppImages.auto
                : id.contains('lcv')
                    ? AppImages.lcv
                    : id.contains('ehcv')
                        ? AppImages.ehcv
                        : id.contains('hatchback')
                            ? AppImages.hatchBack
                            : id.contains('hcv')
                                ? AppImages.hcv
                                : id.contains('mcv')
                                    ? AppImages.mcv
                                    : id.contains('luxury')
                                        ? AppImages.luxury
                                        : id.contains('premium')
                                            ? AppImages.premium
                                            : id.contains('suv')
                                                ? AppImages.suv
                                                : id.contains('car')
                                                    ? AppImages.car
                                                    : '';
    if (asset.isEmpty) return const SizedBox();
    return Image.asset(
      asset,
      width: 16,
      height: 30,
      errorBuilder: (context, error, stackTrace) => const SizedBox(),
    );
  }

  void _fitToRoute(BookingBloc bookingBloc, Size size) {
    final searching =
        bookingBloc.isNormalRideSearching || bookingBloc.isBiddingRideSearching;
    if (searching) {
      _wasSearching = true;
      _cameraFitDebounce?.cancel();
      _lastRequestedFit = null;
      return;
    }
    if (_wasSearching) {
      _wasSearching = false;
      _userMovedMap = false;
      _lastCompletedFit = null;
    }
    if (_userMovedMap) return;
    final bounds =
        RouteCamera.boundsForPoints(bookingBloc.polylist) ?? bookingBloc.bound;
    if (bounds == null || size.isEmpty) return;
    if (widget.mapType == 'google_map' &&
        bookingBloc.googleMapController == null) {
      return;
    }
    if (widget.mapType != 'google_map' && bookingBloc.fmController == null) {
      return;
    }

    final padding = _viewportPadding(size);
    final key = Object.hash(bounds, size, padding);
    if (key == _lastRequestedFit || key == _lastCompletedFit) return;
    _lastRequestedFit = key;
    _cameraFitDebounce?.cancel();
    // Route and sheet updates can arrive together. Fit the latest geometry
    // once they settle, instead of queuing competing camera animations.
    _cameraFitDebounce = Timer(const Duration(milliseconds: 220), () async {
      if (!mounted || _userMovedMap || key != _lastRequestedFit) return;
      final camera = RouteCamera.fit(bounds, size, padding);
      try {
        if (widget.mapType == 'google_map') {
          await bookingBloc.googleMapController?.animateCamera(
            CameraUpdate.newCameraPosition(camera),
            duration: const Duration(milliseconds: 500),
          );
        } else {
          bookingBloc.fmController?.fitCamera(fm.CameraFit.bounds(
            bounds: fm.LatLngBounds(
              fmlt.LatLng(
                  bounds.southwest.latitude, bounds.southwest.longitude),
              fmlt.LatLng(
                  bounds.northeast.latitude, bounds.northeast.longitude),
            ),
            padding: padding + const EdgeInsets.all(32),
            maxZoom: 18,
          ));
        }
        _lastCompletedFit = key;
      } catch (error) {
        _lastRequestedFit = null;
        debugPrint('Route camera fit failed: $error');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.viewportSize ?? MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: widget.cont.read<BookingBloc>(),
      child: BlocBuilder<BookingBloc, BookingState>(
        // buildWhen removed for now — bookingBloc exposes markerList,
        // polylines, etc. as getters on the bloc itself, not on
        // BookingState, so send booking_bloc.dart / the state file to
        // wire this back up against the real fields.
        builder: (context, state) {
          final bookingBloc = context.read<BookingBloc>();

          if (_searchFieldActive != _isSearching) {
            _searchFieldActive = _isSearching;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              _searchAnchor.value = null;
              _invalidateSearchTexture();
              _queueSearchProjection();
              _queueSearchSnapshot();
            });
          }

          // Runs on every BookingBloc state emission (pickup/drop changed,
          // ride-state transitions, etc.) — NOT on the inner
          // ValueListenableBuilder below, which fires many times a second
          // for the moving-car marker and must stay untouched by this.
          _fitToRoute(bookingBloc, size);
          _maybeStartReveal(bookingBloc.polylist);

          final distance = const fmlt.Distance();
          final currentRoutePoints = bookingBloc.polylines
              .where((polyline) => polyline.polylineId.value == '1')
              .expand((polyline) => polyline.points)
              .map((point) => fmlt.LatLng(point.latitude, point.longitude))
              .toList();
          Marker? vehicleMarker;
          for (final marker in bookingBloc.markerList) {
            if (marker is Marker && marker.markerId.value.contains('#')) {
              vehicleMarker = marker;
              break;
            }
          }
          final vehiclePosition = (vehicleMarker != null)
              ? fmlt.LatLng(
                  vehicleMarker.position.latitude,
                  vehicleMarker.position.longitude,
                )
              : null;
          final onRideBasePoints = currentRoutePoints.isNotEmpty
              ? currentRoutePoints
              : bookingBloc.fmpoly;
          List<fmlt.LatLng> oSMOnRidePolylinePoints = onRideBasePoints;
          if (bookingBloc.requestData != null &&
              vehiclePosition != null &&
              onRideBasePoints.isNotEmpty) {
            var nearestIndex = 0;
            var nearestDistance = double.infinity;
            for (var i = 0; i < onRideBasePoints.length; i++) {
              final pointDistance =
                  distance(vehiclePosition, onRideBasePoints[i]);
              if (pointDistance < nearestDistance) {
                nearestDistance = pointDistance;
                nearestIndex = i;
              }
            }
            oSMOnRidePolylinePoints = onRideBasePoints.sublist(nearestIndex);
          }
          return (widget.mapType == 'google_map')
              // Google Map
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      // Stable key: a bottomPadding-dependent key was tearing
                      // down and recreating the whole GoogleMap platform view
                      // (white flash + full reload) on every sheet drag. The
                      // GoogleMap picks up padding changes on its own.
                      key: const ValueKey('googleMapBox'),
                      height: size.height,
                      width: size.width,
                      // ExcludeSemantics: this map's pins/routes carry no
                      // accessibility labels, and the moving car marker
                      // rebuilds this subtree many times a second during
                      // animateCar's ticker. Without a semantics tree here,
                      // there is nothing for debugCheckForParentData to
                      // find inconsistent — this removes the crash at its
                      // source instead of just reducing how often it fires.
                      child: Listener(
                        onPointerMove: (_) => _userMovedMap = true,
                        onPointerSignal: (_) => _userMovedMap = true,
                        child: ExcludeSemantics(
                          child: AnimatedBuilder(
                            // Drives the one-shot route draw-on. Rebuilds the map
                            // only for the ~0.7s the reveal runs, then never again.
                            animation: _revealCurve,
                            builder: (context, _) =>
                                ValueListenableBuilder<int>(
                              // Rebuilds only this map on every car-animation
                              // tick, via bookingBloc.markerNotifier — instead
                              // of that tick emitting a BookingState and
                              // rebuilding the whole booking screen (see
                              // updateMarkers() in the bloc).
                              valueListenable: bookingBloc.markerNotifier,
                              builder: (context, _, __) {
                                return GoogleMap(
                                  mapType: bookingBloc.selectedMapType,
                                  padding: _viewportPadding(size),
                                  gestureRecognizers: {
                                    Factory<OneSequenceGestureRecognizer>(
                                      () => EagerGestureRecognizer(),
                                    ),
                                  },
                                  onMapCreated:
                                      (GoogleMapController controller) async {
                                    bookingBloc.googleMapController =
                                        controller;

                                    // Set Map Style
                                    try {
                                      if (Theme.of(context).brightness ==
                                          Brightness.dark) {
                                        await controller.setMapStyle(
                                            bookingBloc.darkMapString);
                                      } else {
                                        await controller.setMapStyle(
                                            bookingBloc.lightMapString);
                                      }
                                    } catch (e) {
                                      debugPrint("Error setting map style: $e");
                                    }

                                    await VehicleMarkerHelper
                                        .ensureInitialized();

                                    // Geometry may arrive before the native map.
                                    // Fit once it is ready; later builds share the
                                    // same debounced fit and gesture policy.
                                    _fitToRoute(bookingBloc, size);
                                    _queueSearchProjection();
                                    _queueSearchSnapshot();
                                  },
                                  onCameraMove: (position) =>
                                      _searchCameraMoved(
                                          zoom: position.zoom,
                                          rotation: position.bearing,
                                          tilt: position.tilt),
                                  onCameraIdle: () {
                                    _queueSearchProjection();
                                    _queueSearchSnapshot();
                                  },
                                  compassEnabled: false,
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                      AppConstants.currentLocations.latitude,
                                      AppConstants.currentLocations.longitude,
                                    ),
                                    zoom: 15.0,
                                  ),
                                  minMaxZoomPreference:
                                      const MinMaxZoomPreference(0, 20),
                                  buildingsEnabled: false,
                                  zoomControlsEnabled: false,
                                  myLocationEnabled: (bookingBloc
                                              .isNormalRideSearching ||
                                          bookingBloc.isBiddingRideSearching ||
                                          (bookingBloc.requestData != null))
                                      ? false
                                      : true,
                                  myLocationButtonEnabled: false,
                                  markers: Set.from(bookingBloc.markerList
                                      .where((marker) =>
                                          !_isSearching ||
                                          marker.markerId.value != 'pick')
                                      .map((marker) =>
                                          VehicleMarkerHelper.projectForCamera(
                                            marker,
                                            cameraBearing:
                                                _vehicleCameraBearing,
                                            cameraTilt: _vehicleCameraTilt,
                                          ))),
                                  polylines: (bookingBloc
                                              .isNormalRideSearching ||
                                          bookingBloc.isBiddingRideSearching)
                                      ? {}
                                      : (bookingBloc.requestData != null)
                                          ? bookingBloc.polylines
                                          : _previewPolylines(
                                              bookingBloc.polylist,
                                              Theme.of(context).brightness ==
                                                  Brightness.dark,
                                              _revealCurve.value,
                                              _endpointPin(bookingBloc,
                                                  pickup: true),
                                              _endpointPin(bookingBloc,
                                                  pickup: false),
                                              _stopPins(bookingBloc),
                                            ),
                                  rotateGesturesEnabled: true,
                                  zoomGesturesEnabled: true,
                                  scrollGesturesEnabled: true,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (bookingBloc.isNormalRideSearching ||
                        bookingBloc.isBiddingRideSearching)
                      _searchField(),
                  ],
                )
              // Flutter Map
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      key: const ValueKey('flutterMapBox'),
                      height: size.height,
                      width: size.width,
                      // ExcludeSemantics: same reasoning as the GoogleMap
                      // branch above — no accessibility labels on any of
                      // this map's content, and the moving car marker
                      // rebuilds it many times a second.
                      child: ExcludeSemantics(
                        child: ValueListenableBuilder<int>(
                          // Same reasoning as the GoogleMap branch above.
                          valueListenable: bookingBloc.markerNotifier,
                          builder: (context, _, __) {
                            return RepaintBoundary(
                                key: _flutterMapCaptureKey,
                                child: fm.FlutterMap(
                                  mapController: bookingBloc.fmController,
                                  options: fm.MapOptions(
                                    onTap: (tapPosition, latLng) {},
                                    onMapEvent: (event) => _searchCameraMoved(
                                        zoom: event.camera.zoom,
                                        rotation: -event.camera.rotation),
                                    onPositionChanged: (position, hasGesture) {
                                      if (hasGesture) _userMovedMap = true;
                                    },
                                    onMapReady: () {
                                      _fitToRoute(bookingBloc, size);
                                      _queueSearchProjection();
                                      _queueSearchSnapshot();
                                    },
                                    initialCenter: fmlt.LatLng(
                                        AppConstants.currentLocations.latitude,
                                        AppConstants
                                            .currentLocations.longitude),
                                    initialZoom: 16,
                                    minZoom: 5,
                                    maxZoom: 20,
                                    // Use interaction constraints to keep map center above bottom sheet
                                    interactionOptions:
                                        const fm.InteractionOptions(
                                      flags: fm.InteractiveFlag.all,
                                    ),
                                  ),
                                  children: [
                                    fm.TileLayer(
                                      key: const ValueKey('tileLayer'),
                                      urlTemplate: (bookingBloc
                                                      .userData!
                                                      .osmMapSettings
                                                      .enableMapbox ==
                                                  true &&
                                              bookingBloc
                                                  .userData!
                                                  .osmMapSettings
                                                  .mapboxPublicKey
                                                  .isNotEmpty)
                                          ? 'https://api.mapbox.com/styles/v1/{style}/tiles/{z}/{x}/{y}?access_token=${bookingBloc.userData!.osmMapSettings.mapboxPublicKey}'
                                          : (bookingBloc
                                                          .userData!
                                                          .osmMapSettings
                                                          .enableThunderforest ==
                                                      true &&
                                                  bookingBloc
                                                      .userData!
                                                      .osmMapSettings
                                                      .thunderforestApiKey
                                                      .isNotEmpty)
                                              ? 'https://tile.thunderforest.com/cycle/{z}/{x}/{y}.png?apikey=${bookingBloc.userData!.osmMapSettings.thunderforestApiKey}'
                                              : (bookingBloc
                                                              .userData!
                                                              .osmMapSettings
                                                              .enableStadia ==
                                                          true &&
                                                      bookingBloc
                                                          .userData!
                                                          .osmMapSettings
                                                          .stadiaApiKey
                                                          .isNotEmpty)
                                                  ? 'https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}.png?api_key=${bookingBloc.userData!.osmMapSettings.stadiaApiKey}'
                                                  : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      userAgentPackageName: 'package name here',
                                      tileProvider: const FMTCStore('mapStore')
                                          .getTileProvider(),
                                    ),
                                    // Grey background polyline + animated overlay.
                                    // Always present (as an empty layer when hidden)
                                    // instead of being added/removed, and the
                                    // AnimatedBuilder always returns a PolylineLayer
                                    // (never swaps to a different widget type) so the
                                    // platform view's semantics tree never has to
                                    // reconcile a type change mid-animation.
                                    fm.PolylineLayer(
                                      key: const ValueKey('greyRoute'),
                                      polylines: <fm.Polyline>[
                                        if (!bookingBloc
                                                .isNormalRideSearching &&
                                            !bookingBloc
                                                .isBiddingRideSearching &&
                                            bookingBloc.requestData == null &&
                                            bookingBloc.fmpoly.isNotEmpty &&
                                            !bookingBloc.isTripStart) ...[
                                          // Brand casing.
                                          fm.Polyline(
                                            points: bookingBloc.fmpoly,
                                            color: AppColors.meshwarRed
                                                .withOpacity(0.16),
                                            strokeWidth: 11,
                                            strokeJoin: StrokeJoin.round,
                                          ),
                                          // Faint full-length track under the sweep.
                                          fm.Polyline(
                                            points: bookingBloc.fmpoly,
                                            color: AppColors.meshwarRed
                                                .withOpacity(0.30),
                                            strokeWidth: 4,
                                            strokeJoin: StrokeJoin.round,
                                          ),
                                        ],
                                      ],
                                    ),
                                    AnimatedBuilder(
                                      key: const ValueKey('animatedRoute'),
                                      animation: bookingBloc.animation!,
                                      builder: (context, child) {
                                        final showAnimated = !bookingBloc
                                                .isNormalRideSearching &&
                                            !bookingBloc
                                                .isBiddingRideSearching &&
                                            bookingBloc.requestData == null &&
                                            bookingBloc.fmpoly.isNotEmpty &&
                                            !bookingBloc.isTripStart;

                                        List<fmlt.LatLng> animatedPoints =
                                            const [];
                                        if (showAnimated) {
                                          final fmpoly = bookingBloc.fmpoly;
                                          animatedPoints = bookingBloc
                                              .getFlutterMapAnimatedPolyline(
                                                  fmpoly,
                                                  bookingBloc.animation!.value);
                                          // Stop the animation if requestData is not null
                                          if (bookingBloc.requestData != null) {
                                            bookingBloc.animationController
                                                ?.stop();
                                          }
                                        }

                                        // Always return a PolylineLayer (never a
                                        // Container) so the element/render-object
                                        // type never changes on this branch — only
                                        // its data does.
                                        return fm.PolylineLayer(
                                          polylines: <fm.Polyline>[
                                            if (animatedPoints.isNotEmpty)
                                              fm.Polyline(
                                                points: animatedPoints,
                                                color: AppColors.meshwarRed,
                                                strokeWidth: 5,
                                                strokeJoin: StrokeJoin.round,
                                              ),
                                          ],
                                        );
                                      },
                                    ),
                                    fm.PolylineLayer(
                                      key: const ValueKey('onRideRoute'),
                                      polylines: <fm.Polyline>[
                                        if (!bookingBloc
                                                .isNormalRideSearching &&
                                            !bookingBloc
                                                .isBiddingRideSearching &&
                                            bookingBloc.requestData != null &&
                                            oSMOnRidePolylinePoints
                                                .isNotEmpty) ...[
                                          fm.Polyline(
                                            points: oSMOnRidePolylinePoints,
                                            color: AppColors.meshwarRed
                                                .withOpacity(0.16),
                                            strokeWidth: 11,
                                            strokeJoin: StrokeJoin.round,
                                          ),
                                          fm.Polyline(
                                            points: oSMOnRidePolylinePoints,
                                            color: AppColors.meshwarRed,
                                            strokeWidth: 5,
                                            strokeJoin: StrokeJoin.round,
                                          ),
                                        ],
                                      ],
                                    ),
                                    const fm.RichAttributionWidget(
                                      key: ValueKey('attribution'),
                                      attributions: [],
                                    ),
                                    fm.MarkerLayer(
                                      key: const ValueKey('vehicleMarkers'),
                                      markers: List<fm.Marker?>.generate(
                                          bookingBloc.markerList.length,
                                          (index) {
                                        final marker = bookingBloc.markerList
                                            .elementAt(index);
                                        if (_isSearching &&
                                            marker.markerId.value == 'pick') {
                                          return null;
                                        }
                                        return fm.Marker(
                                          key: ValueKey(
                                              marker.markerId.value.toString()),
                                          point: fmlt.LatLng(
                                              marker.position.latitude,
                                              marker.position.longitude),
                                          width:
                                              VehicleMarkerHelper.isSedanMarker(
                                                      marker)
                                                  ? 64
                                                  : 48,
                                          height:
                                              VehicleMarkerHelper.isSedanMarker(
                                                      marker)
                                                  ? 64
                                                  : 48,
                                          rotate:
                                              VehicleMarkerHelper.isSedanMarker(
                                                  marker),
                                          alignment:
                                              VehicleMarkerHelper.isSedanMarker(
                                                      marker)
                                                  ? Alignment.center
                                                  : Alignment.topCenter,
                                          child: RotationTransition(
                                            turns: AlwaysStoppedAnimation(
                                              (VehicleMarkerHelper
                                                          .isSedanMarker(marker)
                                                      ? VehicleMarkerHelper
                                                          .rotationForCamera(
                                                              marker,
                                                              cameraBearing:
                                                                  _vehicleCameraBearing,
                                                              cameraTilt:
                                                                  _vehicleCameraTilt)
                                                      : (marker.rotation
                                                                  .isNaN ||
                                                              marker.rotation
                                                                  .isInfinite)
                                                          ? 0.0
                                                          : marker.rotation) /
                                                  360,
                                            ),
                                            child: _fmMarkerChild(marker),
                                          ),
                                        );
                                      }).whereType<fm.Marker>().toList(),
                                    ),
                                    fm.MarkerLayer(
                                      key: const ValueKey('distanceMarker'),
                                      markers:
                                          (bookingBloc.markerList.any(
                                                  (element) => element
                                                      .markerId.value
                                                      .toString()
                                                      .contains('distance')))
                                              ? List.generate(1, (index) {
                                                  final marker = bookingBloc
                                                      .markerList
                                                      .firstWhere((element) =>
                                                          element.markerId.value
                                                              .toString()
                                                              .contains(
                                                                  'distance'));
                                                  return fm.Marker(
                                                    key: const ValueKey(
                                                        'distanceMarker'),
                                                    point: fmlt.LatLng(
                                                        marker
                                                            .position.latitude,
                                                        marker.position
                                                            .longitude),
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    height: 54,
                                                    width: 110,
                                                    child: RotationTransition(
                                                      turns:
                                                          AlwaysStoppedAnimation(
                                                        ((marker.rotation
                                                                        .isNaN ||
                                                                    marker
                                                                        .rotation
                                                                        .isInfinite)
                                                                ? 0.0
                                                                : marker
                                                                    .rotation) /
                                                            360,
                                                      ),
                                                      child: Directionality(
                                                          textDirection:
                                                              TextDirection.ltr,
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 10),
                                                            height: 44,
                                                            width: 110,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          14),
                                                              color: AppColors
                                                                  .surfaceStrong(
                                                                      context),
                                                              boxShadow: AppColors
                                                                  .surfaceShadow(
                                                                      context),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width: 44,
                                                                  height: 44,
                                                                  decoration: const BoxDecoration(
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(
                                                                              14),
                                                                          bottomLeft: Radius.circular(
                                                                              14)),
                                                                      color: AppColors
                                                                          .meshwarRed),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      MyText(
                                                                        text: bookingBloc
                                                                            .fmDistance,
                                                                        textStyle: AppTextStyle.normalStyle().copyWith(
                                                                            color:
                                                                                AppColors.white,
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: 12),
                                                                      ),
                                                                      MyText(
                                                                        text: bookingBloc
                                                                            .userData!
                                                                            .distanceUnit,
                                                                        textStyle: AppTextStyle.normalStyle().copyWith(
                                                                            color:
                                                                                AppColors.white,
                                                                            fontSize: 10),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    height: 44,
                                                                    child:
                                                                        MyText(
                                                                      text: ((bookingBloc.fmDuration) >
                                                                              60)
                                                                          ? '${(bookingBloc.fmDuration / 60).toStringAsFixed(0)} hrs'
                                                                          : '${bookingBloc.fmDuration.toStringAsFixed(0)} mins',
                                                                      textStyle: AppTextStyle.normalStyle().copyWith(
                                                                          color: Theme.of(context)
                                                                              .primaryColorDark,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )),
                                                    ),
                                                  );
                                                })
                                              : const [],
                                    ),
                                  ],
                                ));
                          },
                        ),
                      ),
                    ),
                    if (bookingBloc.isNormalRideSearching ||
                        bookingBloc.isBiddingRideSearching)
                      _searchField(),
                  ],
                );
        },
      ),
    );
  }
}

class _SearchMapTexture {
  const _SearchMapTexture(
      {required this.image,
      required this.center,
      required this.zoom,
      required this.rotation});
  final ui.Image image;
  final Offset center;
  final double zoom, rotation;
}
//
