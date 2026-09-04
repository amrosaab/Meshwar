// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart' as fmlt;

import '../../../../../../common/common.dart';
import '../../../../../../common/vehicle_marker_helper.dart';
import '../../../../../../core/utils/avatar_glow.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../application/booking_bloc.dart';

class BookingMapWidget extends StatefulWidget {
  final BuildContext cont;
  final String mapType;
  final double bottomPadding;

  const BookingMapWidget({
    super.key,
    required this.cont,
    required this.mapType,
    this.bottomPadding = 0,
  });

  @override
  State<BookingMapWidget> createState() => _BookingMapWidgetState();
}

class _BookingMapWidgetState extends State<BookingMapWidget> {
  // Tracks the last bound we actually animated the camera to, so we only
  // re-fit when pickup/drop/route endpoints genuinely change — not on every
  // high-frequency car-position tick from bookingBloc.markerNotifier.
  LatLngBounds? _lastFittedBound;

  // Pushes the southern edge of the bounds outward before fitting, so the
  // fitted route sits in the visible area ABOVE the bottom sheet instead of
  // being centered through it. newLatLngBounds only takes one uniform
  // padding value (no per-edge insets like native Android/iOS SDKs), so
  // this is the standard workaround: make the box itself asymmetric instead
  // of the padding.
  LatLngBounds _expandBoundsForSheet(LatLngBounds bound, double fraction) {
    final latSpan = bound.northeast.latitude - bound.southwest.latitude;
    final safeSpan = latSpan.abs() < 0.0005 ? 0.01 : latSpan;
    return LatLngBounds(
      southwest: LatLng(
        bound.southwest.latitude - safeSpan * fraction,
        bound.southwest.longitude,
      ),
      northeast: bound.northeast,
    );
  }

  void _fitToRoute(BookingBloc bookingBloc, Size size) {
    final bound = bookingBloc.bound;
    final controller = bookingBloc.googleMapController;
    if (bound == null || controller == null) return;
    if (_lastFittedBound == bound) return;
    _lastFittedBound = bound;

    final latSpan = (bound.northeast.latitude - bound.southwest.latitude).abs();
    final lngSpan = (bound.northeast.longitude - bound.southwest.longitude).abs();
    // Pickup and drop are the same point (or effectively so, e.g. before a
    // drop location has been chosen) — newLatLngBounds on a zero-span box
    // either throws or zooms in absurdly far, so fall back to a plain
    // centered zoom instead.
    final isEffectivelyAPoint = latSpan < 0.0004 && lngSpan < 0.0004;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isEffectivelyAPoint) {
        controller.animateCamera(
          CameraUpdate.newLatLngZoom(bound.southwest, 16),
        );
        return;
      }
      final bottomFraction =
      ((widget.bottomPadding + 60) / size.height).clamp(0.05, 0.55);
      final expanded = _expandBoundsForSheet(bound, bottomFraction + 0.12);
      final padding = size.width * 0.11;
      controller.animateCamera(CameraUpdate.newLatLngBounds(expanded, padding));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: widget.cont.read<BookingBloc>(),
      child: BlocBuilder<BookingBloc, BookingState>(
        // buildWhen removed for now — bookingBloc exposes markerList,
        // polylines, etc. as getters on the bloc itself, not on
        // BookingState, so send booking_bloc.dart / the state file to
        // wire this back up against the real fields.
        builder: (context, state) {
          final bookingBloc = context.read<BookingBloc>();

          // Runs on every BookingBloc state emission (pickup/drop changed,
          // ride-state transitions, etc.) — NOT on the inner
          // ValueListenableBuilder below, which fires many times a second
          // for the moving-car marker and must stay untouched by this.
          _fitToRoute(bookingBloc, size);

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
                key: ValueKey('googleMapBox_${widget.bottomPadding}'),
                height: size.height,
                width: size.width,
                // ExcludeSemantics: this map's pins/routes carry no
                // accessibility labels, and the moving car marker
                // rebuilds this subtree many times a second during
                // animateCar's ticker. Without a semantics tree here,
                // there is nothing for debugCheckForParentData to
                // find inconsistent — this removes the crash at its
                // source instead of just reducing how often it fires.
                child: ExcludeSemantics(
                  child: ValueListenableBuilder<int>(
                    // Rebuilds only this map on every car-animation
                    // tick, via bookingBloc.markerNotifier — instead
                    // of that tick emitting a BookingState and
                    // rebuilding the whole booking screen (see
                    // updateMarkers() in the bloc).
                    valueListenable: bookingBloc.markerNotifier,
                    builder: (context, _, __) {
                      return GoogleMap(
                        mapType: bookingBloc.selectedMapType,
                        padding: EdgeInsets.fromLTRB(
                          size.width * 0.05,
                          MediaQuery.of(context).padding.top + 20,
                          size.width * 0.05,
                          widget.bottomPadding + 20,
                        ),
                        gestureRecognizers: {
                          Factory<OneSequenceGestureRecognizer>(
                                () => EagerGestureRecognizer(),
                          ),
                        },
                        onMapCreated: (GoogleMapController controller) async {
                          bookingBloc.googleMapController = controller;

                          // Set Map Style
                          try {
                            if (Theme.of(context).brightness == Brightness.dark) {
                              await controller.setMapStyle(bookingBloc.darkMapString);
                            } else {
                              await controller.setMapStyle(bookingBloc.lightMapString);
                            }
                          } catch (e) {
                            debugPrint("Error setting map style: $e");
                          }

                          await VehicleMarkerHelper.ensureInitialized();

                          // Fit bounds immediately upon creation if they
                          // exist. _fitToRoute guards against duplicate
                          // work itself (via _lastFittedBound), and will
                          // also re-run automatically on every future
                          // BookingState change through build() above —
                          // this call just covers the case where bound was
                          // already available before the map even finished
                          // creating.
                          _fitToRoute(bookingBloc, size);
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
                        markers: Set.from(bookingBloc.markerList),
                        polylines: (bookingBloc.isNormalRideSearching ||
                            bookingBloc.isBiddingRideSearching)
                            ? {}
                            : (bookingBloc.requestData != null)
                            ? bookingBloc.polylines
                            : {
                          Polyline(
                            polylineId:
                            const PolylineId('greyRoute'),
                            points: bookingBloc.polylist,
                            color: Colors.grey,
                            width: 3,
                            jointType: JointType.round,
                            startCap: Cap.roundCap,
                            endCap: Cap.roundCap,
                          ),
                          Polyline(
                            polylineId: const PolylineId(
                                'animatedRoute'),
                            points: bookingBloc.polylist,
                            color: Theme.of(context)
                                .brightness ==
                                Brightness.dark
                                ? Colors.white
                                : Colors.black87,
                            width: 4,
                            jointType: JointType.round,
                            startCap: Cap.roundCap,
                            endCap: Cap.roundCap,
                          ),
                        },
                        rotateGesturesEnabled: true,
                        zoomGesturesEnabled: true,
                        scrollGesturesEnabled: true,
                      );
                    },
                  ),
                ),
              ),
              if (bookingBloc.isNormalRideSearching ||
                  bookingBloc.isBiddingRideSearching)
                Positioned(
                  key: const ValueKey('searchingAvatarGlowGoogle'),
                  top: size.width * 0.65,
                  child: ExcludeSemantics(
                    child: AvatarGlow(
                      glowColor: AppColors.meshwarRed,
                      glowRadiusFactor: 2.5,
                      glowCount: 8,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: Image.asset(
                          AppImages.confirmationPin,
                          height: 30,
                        ),
                      ),
                    ),
                  ),
                ),
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
                      return fm.FlutterMap(
                        mapController: bookingBloc.fmController,
                        options: fm.MapOptions(
                          onTap: (tapPosition, latLng) {},
                          onMapEvent: (v) async {},
                          onPositionChanged: (p, l) async {},
                          initialCenter: fmlt.LatLng(
                              AppConstants.currentLocations.latitude,
                              AppConstants.currentLocations.longitude),
                          initialZoom: 16,
                          minZoom: 5,
                          maxZoom: 20,
                          // Use interaction constraints to keep map center above bottom sheet
                          interactionOptions: const fm.InteractionOptions(
                            flags: fm.InteractiveFlag.all,
                          ),
                        ),
                        children: [
                          fm.TileLayer(
                            key: const ValueKey('tileLayer'),
                            urlTemplate: (bookingBloc.userData!.osmMapSettings
                                .enableMapbox ==
                                true &&
                                bookingBloc.userData!.osmMapSettings
                                    .mapboxPublicKey.isNotEmpty)
                                ? 'https://api.mapbox.com/styles/v1/{style}/tiles/{z}/{x}/{y}?access_token=${bookingBloc.userData!.osmMapSettings.mapboxPublicKey}'
                                : (bookingBloc.userData!.osmMapSettings
                                .enableThunderforest ==
                                true &&
                                bookingBloc.userData!.osmMapSettings
                                    .thunderforestApiKey.isNotEmpty)
                                ? 'https://tile.thunderforest.com/cycle/{z}/{x}/{y}.png?apikey=${bookingBloc.userData!.osmMapSettings.thunderforestApiKey}'
                                : (bookingBloc.userData!.osmMapSettings
                                .enableStadia ==
                                true &&
                                bookingBloc.userData!.osmMapSettings
                                    .stadiaApiKey.isNotEmpty)
                                ? 'https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}.png?api_key=${bookingBloc.userData!.osmMapSettings.stadiaApiKey}'
                                : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'package name here',
                            tileProvider:
                            const FMTCStore('mapStore').getTileProvider(),
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
                              if (!bookingBloc.isNormalRideSearching &&
                                  !bookingBloc.isBiddingRideSearching &&
                                  bookingBloc.requestData == null &&
                                  bookingBloc.fmpoly.isNotEmpty &&
                                  !bookingBloc.isTripStart)
                                fm.Polyline(
                                  points: bookingBloc.fmpoly,
                                  color: Theme.of(context).dividerColor,
                                  strokeWidth: 2,
                                ),
                            ],
                          ),
                          AnimatedBuilder(
                            key: const ValueKey('animatedRoute'),
                            animation: bookingBloc.animation!,
                            builder: (context, child) {
                              final showAnimated =
                                  !bookingBloc.isNormalRideSearching &&
                                      !bookingBloc.isBiddingRideSearching &&
                                      bookingBloc.requestData == null &&
                                      bookingBloc.fmpoly.isNotEmpty &&
                                      !bookingBloc.isTripStart;

                              List<fmlt.LatLng> animatedPoints = const [];
                              if (showAnimated) {
                                final fmpoly = bookingBloc.fmpoly;
                                animatedPoints =
                                    bookingBloc.getFlutterMapAnimatedPolyline(
                                        fmpoly, bookingBloc.animation!.value);
                                // Stop the animation if requestData is not null
                                if (bookingBloc.requestData != null) {
                                  bookingBloc.animationController?.stop();
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
                                      color: Theme.of(context).brightness ==
                                          Brightness.dark
                                          ? Colors.white
                                          : Colors.black87,
                                      strokeWidth: 3,
                                    ),
                                ],
                              );
                            },
                          ),
                          fm.PolylineLayer(
                            key: const ValueKey('onRideRoute'),
                            polylines: <fm.Polyline>[
                              if (!bookingBloc.isNormalRideSearching &&
                                  !bookingBloc.isBiddingRideSearching &&
                                  bookingBloc.requestData != null &&
                                  oSMOnRidePolylinePoints.isNotEmpty)
                                fm.Polyline(
                                  points: oSMOnRidePolylinePoints,
                                  color: Theme.of(context).brightness ==
                                      Brightness.dark
                                      ? Colors.white
                                      : Colors.black87,
                                  strokeWidth: 3,
                                ),
                            ],
                          ),
                          const fm.RichAttributionWidget(
                            key: ValueKey('attribution'),
                            attributions: [],
                          ),
                          fm.MarkerLayer(
                            key: const ValueKey('vehicleMarkers'),
                            markers: List.generate(
                                bookingBloc.markerList.length, (index) {
                              final marker = bookingBloc.markerList
                                  .elementAt(index);
                              return fm.Marker(
                                key: ValueKey(
                                    marker.markerId.value.toString()),
                                point: fmlt.LatLng(
                                    marker.position.latitude,
                                    marker.position.longitude),
                                alignment: Alignment.topCenter,
                                child: RotationTransition(
                                  turns: AlwaysStoppedAnimation(
                                    ((marker.rotation.isNaN ||
                                        marker.rotation.isInfinite)
                                        ? 0.0
                                        : marker.rotation) /
                                        360,
                                  ),
                                  child: Image.asset(
                                    marker.markerId.value.toString() ==
                                        'pick'
                                        ? AppImages.pickPin
                                        : (marker.markerId.value
                                        .toString() ==
                                        'drop' ||
                                        marker.markerId.value
                                            .toString()
                                            .contains('drop'))
                                        ? AppImages.dropPin
                                        : (marker.markerId.value
                                        .toString()
                                        .contains('truck'))
                                        ? AppImages.truck
                                        : marker.markerId.value
                                        .toString()
                                        .contains(
                                        'motor_bike')
                                        ? AppImages.bike
                                        : marker.markerId
                                        .value
                                        .toString()
                                        .contains(
                                        'auto')
                                        ? AppImages.auto
                                        : marker
                                        .markerId
                                        .value
                                        .toString()
                                        .contains(
                                        'lcv')
                                        ? AppImages
                                        .lcv
                                        : marker
                                        .markerId
                                        .value
                                        .toString()
                                        .contains(
                                        'ehcv')
                                        ? AppImages
                                        .ehcv
                                        : marker.markerId.value.toString().contains('hatchback')
                                        ? AppImages.hatchBack
                                        : marker.markerId.value.toString().contains('hcv')
                                        ? AppImages.hcv
                                        : marker.markerId.value.toString().contains('mcv')
                                        ? AppImages.mcv
                                        : marker.markerId.value.toString().contains('luxury')
                                        ? AppImages.luxury
                                        : marker.markerId.value.toString().contains('premium')
                                        ? AppImages.premium
                                        : marker.markerId.value.toString().contains('suv')
                                        ? AppImages.suv
                                        : (marker.markerId.value.toString().contains('car'))
                                        ? AppImages.car
                                        : '',
                                    width: 16,
                                    height: 30,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return const SizedBox();
                                    },
                                  ),
                                ),
                              );
                            }),
                          ),
                          fm.MarkerLayer(
                            key: const ValueKey('distanceMarker'),
                            markers: (bookingBloc.markerList.any((element) =>
                                element.markerId.value
                                    .toString()
                                    .contains('distance')))
                                ? List.generate(1, (index) {
                              final marker = bookingBloc.markerList
                                  .firstWhere((element) => element
                                  .markerId.value
                                  .toString()
                                  .contains('distance'));
                              return fm.Marker(
                                key: const ValueKey('distanceMarker'),
                                point: fmlt.LatLng(
                                    marker.position.latitude,
                                    marker.position.longitude),
                                alignment: Alignment.bottomCenter,
                                height: 54,
                                width: 110,
                                child: RotationTransition(
                                  turns: AlwaysStoppedAnimation(
                                    ((marker.rotation.isNaN ||
                                        marker.rotation.isInfinite)
                                        ? 0.0
                                        : marker.rotation) /
                                        360,
                                  ),
                                  child: Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            top: 10),
                                        height: 44,
                                        width: 110,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(14),
                                          color: AppColors.surfaceStrong(
                                              context),
                                          boxShadow:
                                          AppColors.surfaceShadow(
                                              context),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 44,
                                              height: 44,
                                              decoration:
                                              const BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius
                                                      .only(
                                                      topLeft:
                                                      Radius.circular(14),
                                                      bottomLeft:
                                                      Radius.circular(14)),
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
                                                    textStyle:
                                                    AppTextStyle
                                                        .normalStyle()
                                                        .copyWith(
                                                        color: AppColors
                                                            .white,
                                                        fontWeight:
                                                        FontWeight
                                                            .w600,
                                                        fontSize:
                                                        12),
                                                  ),
                                                  MyText(
                                                    text: bookingBloc
                                                        .userData!
                                                        .distanceUnit,
                                                    textStyle:
                                                    AppTextStyle
                                                        .normalStyle()
                                                        .copyWith(
                                                        color: AppColors
                                                            .white,
                                                        fontSize:
                                                        10),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                alignment:
                                                Alignment.center,
                                                height: 44,
                                                child: MyText(
                                                  text: ((bookingBloc
                                                      .fmDuration) >
                                                      60)
                                                      ? '${(bookingBloc.fmDuration / 60).toStringAsFixed(0)} hrs'
                                                      : '${bookingBloc.fmDuration.toStringAsFixed(0)} mins',
                                                  textStyle: AppTextStyle
                                                      .normalStyle()
                                                      .copyWith(
                                                      color: Theme.of(
                                                          context)
                                                          .primaryColorDark,
                                                      fontWeight:
                                                      FontWeight
                                                          .w600,
                                                      fontSize: 12),
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
                      );
                    },
                  ),
                ),
              ),
              if (bookingBloc.isNormalRideSearching ||
                  bookingBloc.isBiddingRideSearching)
                Positioned(
                  key: const ValueKey('searchingAvatarGlowFm'),
                  top: size.width * 0.65,
                  child: ExcludeSemantics(
                    child: AvatarGlow(
                      glowColor: AppColors.meshwarRed,
                      glowRadiusFactor: 2.5,
                      glowCount: 8,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: Image.asset(
                          AppImages.confirmationPin,
                          height: 30,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
//