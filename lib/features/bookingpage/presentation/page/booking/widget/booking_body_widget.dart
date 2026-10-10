import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_navigation_icon.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/booking_bloc.dart';
import 'bidding_ride/bidding_waiting_for_driver.dart';
import 'booking_map_widget.dart';
import 'delivery_booking_widget.dart';
import 'eta_list_shimmer.dart';
import 'no_vehicle_found.dart';
import 'on_ride/on_ride_bottom_sheet.dart';
import 'ride_preview_widget.dart';
import 'waiting_for_driver.dart';

class BookingBodyWidget extends StatefulWidget {
  final BuildContext cont;
  final BookingPageArguments arg;

  const BookingBodyWidget({super.key, required this.cont, required this.arg});

  @override
  State<BookingBodyWidget> createState() => _BookingBodyWidgetState();
}

class _BookingBodyWidgetState extends State<BookingBodyWidget> {
  final GlobalKey _onTripContentKey = GlobalKey();
  final DraggableScrollableController _onTripSheetController =
      DraggableScrollableController();
  double? _onTripFittedSize;
  bool _onTripFitScheduled = false;
  String? _fittedRideId;
  Timer? _mapViewportMeasure;

  final GlobalKey _bottomContentKey = GlobalKey();
  double _bottomContentHeight = 0;
  bool _bottomContentMeasureScheduled = false;

  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().draggableController.addListener(() {});
  }

  @override
  void dispose() {
    _mapViewportMeasure?.cancel();
    _onTripSheetController.dispose();
    super.dispose();
  }

  void _scheduleMapViewportMeasure() {
    _mapViewportMeasure?.cancel();
    // Measure only after a sheet drag settles. Changing native map padding on
    // every drag frame makes its camera chase a moving viewport.
    _mapViewportMeasure = Timer(const Duration(milliseconds: 220), () {
      if (!mounted) return;
      _scheduleBottomContentMeasure();
      WidgetsBinding.instance.scheduleFrame();
    });
  }

  void _scheduleBottomContentMeasure() {
    if (_bottomContentMeasureScheduled) return;
    _bottomContentMeasureScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bottomContentMeasureScheduled = false;
      if (!mounted) return;
      final renderBox =
          _bottomContentKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null || !renderBox.hasSize) return;

      final measuredHeight = renderBox.size.height;
      if ((measuredHeight - _bottomContentHeight).abs() < 1) return;

      setState(() {
        _bottomContentHeight = measuredHeight;
      });
    });
  }

  void _scheduleOnTripFit(double screenHeight) {
    if (_onTripFitScheduled) return;
    _onTripFitScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onTripFitScheduled = false;
      final renderBox =
          _onTripContentKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null || !renderBox.hasSize) return;

      final bloc = context.read<BookingBloc>();
      final rideId = bloc.requestData?.id;
      if (rideId == null ||
          bloc.driverData == null ||
          rideId == _fittedRideId) {
        return;
      }
      final contentHeight = renderBox.size.height;
      if (contentHeight < 100) {
        return; // Don't fit if content isn't rendered yet
      }

      // Capped well below the old 0.95: on the first measurement pass,
      // content occasionally measures taller than its final settled height
      // (images/layout not fully resolved yet), so the sheet could balloon
      // to swallow nearly the entire screen — hiding the map and its
      // controls — until a later, unrelated rebuild happened to re-measure
      // and correct it. Content taller than the cap simply scrolls within
      // the sheet (it's already wrapped in a SingleChildScrollView), so
      // capping here only bounds the worst case, it doesn't clip anything.
      final fraction = ((contentHeight + 50) / screenHeight).clamp(0.4, 0.58);

      if (_onTripFittedSize != null &&
          (fraction - _onTripFittedSize!).abs() < 0.01) {
        _fittedRideId = rideId;
        return;
      }
      _fittedRideId = rideId;
      _onTripFittedSize = fraction;

      if (_onTripSheetController.isAttached) {
        _onTripSheetController.animateTo(
          fraction,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      } else if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bookingBloc = context.read<BookingBloc>();

    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        _scheduleBottomContentMeasure();

        final hasEta = (!bookingBloc.isRentalRide &&
                bookingBloc.etaDetailsList.isNotEmpty) ||
            (bookingBloc.isRentalRide &&
                bookingBloc.rentalEtaDetailsList.isNotEmpty);

        return LayoutBuilder(builder: (context, constraints) {
          // Real height of the area the sheet lives in (the Scaffold body,
          // minus its bottomNavigationBar) — NOT the full screen. Using
          // MediaQuery height here inflated the sheet position and left a gap
          // between the sheet and the floating controls.
          final sheetAreaHeight = constraints.maxHeight;
          return Stack(
            children: [
              // 1. Map Layer
              Stack(
                children: [
                  if (bookingBloc.animation != null)
                    BookingMapWidget(
                      cont: context,
                      mapType: bookingBloc.mapType,
                      bottomPadding: _bottomContentHeight,
                      viewportSize: constraints.biggest,
                    ),
                  if (!bookingBloc.isNormalRideSearching &&
                      !bookingBloc.isBiddingRideSearching)
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.all(size.width * 0.05),
                        child: Row(
                          children: [
                            if ((bookingBloc.isRentalRide &&
                                    bookingBloc
                                        .rentalEtaDetailsList.isNotEmpty) ||
                                !bookingBloc.isRentalRide)
                              NavigationIconWidget(
                                onTap: () {
                                  bookingBloc.add(BookingNavigatorPopEvent());
                                },
                                icon: Icon(Icons.arrow_back_ios_new_rounded,
                                    size: 20,
                                    color: Theme.of(context).primaryColorDark),
                                isShadowWidget: true,
                              ),
                          ],
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: size.height * 0.55,
                    right: size.width * 0.03,
                    child: Column(
                      children: [
                        if (bookingBloc.requestData != null &&
                            bookingBloc.requestData!.isTripStart == 1) ...[
                          InkWell(
                            onTap: () async {
                              await Share.share(
                                  'Your Driver is ${bookingBloc.driverData!.name}. ${bookingBloc.driverData!.carColor} ${bookingBloc.driverData!.carMakeName} ${bookingBloc.driverData!.carModelName}, Vehicle Number: ${bookingBloc.driverData!.carNumber}. Track with link: ${AppConstants.baseUrl}track/request/${bookingBloc.requestData!.id}');
                            },
                            child: Container(
                              height: size.width * 0.11,
                              width: size.width * 0.11,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.surface(context),
                                border: Border.all(
                                  width: 1.2,
                                  color: AppColors.surfaceBorder(context),
                                ),
                                boxShadow: AppColors.surfaceShadow(context),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.share,
                                size: size.width * 0.05,
                                color: Theme.of(context).primaryColorDark,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              bookingBloc.add(SOSEvent());
                            },
                            child: Container(
                              height: size.width * 0.18,
                              width: size.width * 0.18,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(AppImages.sosImage),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              // 2. Bottom Content Layer
              if (bookingBloc.isBiddingRideSearching)
                Positioned.fill(
                  child: NotificationListener<DraggableScrollableNotification>(
                    onNotification: (notification) {
                      // Update the shared position notifier only — no bloc event,
                      // so dragging the sheet never rebuilds the map/screen.
                      bookingBloc.updateSheetPosition(
                          notification.extent * sheetAreaHeight);
                      _scheduleMapViewportMeasure();
                      return true;
                    },
                    child: DraggableScrollableSheet(
                      initialChildSize: 0.6,
                      minChildSize: 0.3,
                      maxChildSize: 0.6,
                      builder: (context, scrollController) {
                        return Container(
                          key: _bottomContentKey,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.bgAsphalt
                                    : Colors.white,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(28)),
                            boxShadow: AppColors.surfaceShadow(context),
                          ),
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: BiddingWaitingForDriverConfirmation(
                              maximumTime: double.parse(
                                bookingBloc.userData!
                                    .maximumTimeForFindDriversForRegularRide,
                              ),
                              isOutstationRide: bookingBloc.isOutstationRide,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              else if (bookingBloc.isNormalRideSearching)
                Positioned.fill(
                  child: NotificationListener<DraggableScrollableNotification>(
                    onNotification: (notification) {
                      // Update the shared position notifier only — no bloc event,
                      // so dragging the sheet never rebuilds the map/screen.
                      bookingBloc.updateSheetPosition(
                          notification.extent * sheetAreaHeight);
                      _scheduleMapViewportMeasure();
                      return true;
                    },
                    child: DraggableScrollableSheet(
                      initialChildSize: 0.35,
                      minChildSize: 0.35,
                      maxChildSize: 0.94,
                      snap: true,
                      snapSizes: const [0.6],
                      snapAnimationDuration: const Duration(milliseconds: 320),
                      builder: (context, scrollController) {
                        return Container(
                          key: _bottomContentKey,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.bgVoid
                                    : AppColors.lightBg,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(28)),
                            boxShadow: AppColors.surfaceShadow(context),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: WaitingForDriverConfirmation(
                              maximumTime: double.parse(
                                bookingBloc.userData!
                                    .maximumTimeForFindDriversForRegularRide,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              else if (bookingBloc.isTripStart)
                Positioned.fill(
                  child: NotificationListener<DraggableScrollableNotification>(
                    onNotification: (notification) {
                      // Update the shared position notifier only — no bloc event,
                      // so dragging the sheet never rebuilds the map/screen.
                      bookingBloc.updateSheetPosition(
                          notification.extent * sheetAreaHeight);
                      _scheduleMapViewportMeasure();
                      return true;
                    },
                    child: DraggableScrollableSheet(
                      controller: _onTripSheetController,
                      initialChildSize: _onTripFittedSize ?? 0.56,
                      minChildSize: 0.3,
                      maxChildSize: 0.9,
                      builder: (context, scrollController) {
                        _scheduleOnTripFit(sheetAreaHeight);
                        return Container(
                          key: _bottomContentKey,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceStrong(context),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                            boxShadow: AppColors.surfaceShadow(context),
                          ),
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Container(
                              key: _onTripContentKey,
                              child: const OnRideBottomSheet(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              else if (hasEta)
                Positioned.fill(
                  child: NotificationListener<DraggableScrollableNotification>(
                    onNotification: (notification) {
                      // Update the shared position notifier only — no bloc event,
                      // so dragging the sheet never rebuilds the map/screen.
                      bookingBloc.updateSheetPosition(
                          notification.extent * sheetAreaHeight);
                      _scheduleMapViewportMeasure();
                      return true;
                    },
                    child: DraggableScrollableSheet(
                      controller: bookingBloc.draggableController,
                      snap: true,
                      initialChildSize: (widget.arg.stopAddressList.length == 1
                              ? bookingBloc.currentSize
                              : (widget.arg.stopAddressList.length == 2
                                  ? bookingBloc.currentSizeTwo
                                  : bookingBloc.currentSizeThree))
                          .clamp(0.1, bookingBloc.maxChildSize),
                      minChildSize: (widget.arg.stopAddressList.length == 1
                              ? bookingBloc.minChildSize
                              : (widget.arg.stopAddressList.length == 2
                                  ? bookingBloc.minChildSizeTwo
                                  : bookingBloc.minChildSizeThree))
                          .clamp(0.1, bookingBloc.maxChildSize),
                      maxChildSize: bookingBloc.maxChildSize,
                      builder: (context, scrollController) {
                        return Container(
                          key: _bottomContentKey,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceStrong(context),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                            border: Border(
                                top: BorderSide(
                                    color: AppColors.surfaceBorder(context))),
                            boxShadow: AppColors.surfaceShadow(context),
                          ),
                          child: SingleChildScrollView(
                            controller: scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: bookingBloc.detailView
                                ? DeliveryBookingWidget(
                                    cont: context,
                                    arg: widget.arg,
                                    eta: bookingBloc.isRentalRide
                                        ? bookingBloc.rentalEtaDetailsList[
                                            bookingBloc.selectedVehicleIndex]
                                        : bookingBloc.isMultiTypeVechiles
                                            ? bookingBloc.sortedEtaDetailsList[
                                                bookingBloc
                                                    .selectedVehicleIndex]
                                            : bookingBloc.etaDetailsList[
                                                bookingBloc
                                                    .selectedVehicleIndex],
                                  )
                                : RidePreviewWidget(
                                    cont: context, arg: widget.arg),
                          ),
                        );
                      },
                    ),
                  ),
                )
              else
                Align(
                  alignment: Alignment.bottomCenter,
                  child: KeyedSubtree(
                    key: _bottomContentKey,
                    child: bookingBloc.isEtaLoading
                        ? EtaListShimmer(size: size)
                        : bookingBloc.isEtaApiCompleted
                            ? NoVehicleFound(size: size)
                            : const SizedBox.shrink(),
                  ),
                ),
//////
              // 3. Map Controls Layer — follows the sheet via a ValueListenable so
              // dragging never rebuilds this subtree (only the `bottom` inset).
              if (!bookingBloc.isNormalRideSearching &&
                  !bookingBloc.isBiddingRideSearching)
                ValueListenableBuilder<double>(
                  valueListenable: bookingBloc.sheetPositionNotifier,
                  builder: (context, pos, child) {
                    // Visible sheet height in px. Fall back to the current
                    // sheet variant's own known initial fraction until the
                    // first drag notification arrives (the measured content
                    // height was unreliable). The on-ride sheet
                    // (isTripStart) opens far taller (~0.56, sometimes more
                    // once fitted) than the ride-preview sheet's ~0.37 —
                    // using the flat 0.37 fallback for it left these controls
                    // positioned as if the sheet were much shorter than it
                    // actually is, so they rendered overlapping the sheet's
                    // own content instead of sitting above it in the map.
                    final restingFraction = bookingBloc.isTripStart
                        ? (_onTripFittedSize ?? 0.56)
                        : 0.37;
                    final sheetPx = (pos > 24 && pos < sheetAreaHeight)
                        ? pos
                        : sheetAreaHeight * restingFraction;
                    // Hide the controls once the sheet covers most of the map —
                    // there's no room for them and nothing to pan.
                    if (sheetPx > sheetAreaHeight * 0.6) {
                      return const SizedBox.shrink();
                    }
                    final ceiling = sheetAreaHeight -
                        MediaQuery.paddingOf(context).top -
                        112;
                    return Positioned(
                      bottom: (sheetPx + 10)
                          .clamp(12.0, ceiling < 12 ? 12.0 : ceiling),
                      right: 16,
                      child: child!,
                    );
                  },
                  child: _MapControls(bookingBloc: bookingBloc),
                ),
            ],
          );
        });
      },
    );
  }
}

/// Floating map controls (layer switcher + recenter) in a modern squircle
/// style. Handed to the ValueListenableBuilder as its cached `child`, so
/// dragging the sheet only re-runs the `Positioned` inset, never this subtree.
class _MapControls extends StatelessWidget {
  const _MapControls({required this.bookingBloc});

  final BookingBloc bookingBloc;

  // Re-fits the camera to the full pickup/drop/route extent — matches this
  // button's actual job of bringing the whole trip back into view after the
  // rider has panned/zoomed away. Falls back to a plain GPS "locate me" only
  // when there's no bound yet (or for rentals, which may not have one).
  void _recenter() {
    final bound = bookingBloc.bound;
    final isRental = bookingBloc.requestData?.isRental ?? false;

    if (bookingBloc.googleMapController != null) {
      if (isRental || bound == null) {
        bookingBloc.add(BookingLocateMeEvent(
          mapType: bookingBloc.mapType,
          controller: bookingBloc.googleMapController,
        ));
      } else {
        bookingBloc.requestRouteOverview();
      }
    } else if (bookingBloc.fmController != null) {
      if (bound == null) {
        bookingBloc.add(BookingLocateMeEvent(
          mapType: bookingBloc.mapType,
          controller: bookingBloc.fmController,
        ));
      } else {
        bookingBloc.requestRouteOverview();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (bookingBloc.isNormalRideSearching ||
        bookingBloc.isBiddingRideSearching) {
      return const SizedBox.shrink();
    }
    final onSurface = Theme.of(context).primaryColorDark;

    // Layers + locate-me merged into a single floating card (instead of two
    // separate boxes) with one shared shadow, matching the grouped controls
    // cluster on the Select-from-Map screen.
    if (bookingBloc.mapType != 'google_map') {
      return _ControlButton(
        icon: Icons.my_location_rounded,
        iconColor: Colors.white,
        gradient: AppColors.beaconGradient,
        onTap: _recenter,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 20,
            spreadRadius: -4,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // PopupMenuButton wraps its icon in an IconButton that enforces
            // its own ~48px minimum tap target regardless of the icon's own
            // size — this SizedBox forces the button's actual layout box to
            // match the divider/locate-me width exactly so it doesn't
            // overflow past the ClipRRect's rounded corners.
            SizedBox(
              height: 46,
              width: 46,
              child: PopupMenuButton<MapType>(
                offset: const Offset(-8, 52),
                color: AppColors.surfaceStrong(context),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: AppColors.surfaceBorder(context)),
                ),
                elevation: 8,
                onSelected: (mapType) =>
                    bookingBloc.add(UpdateMapTypeEvent(mapType)),
                itemBuilder: (context) => [
                  _mapTypeItem(context, MapType.normal,
                      AppLocalizations.of(context)!.normal, Icons.map_outlined),
                  _mapTypeItem(
                      context,
                      MapType.satellite,
                      AppLocalizations.of(context)!.satellite,
                      Icons.satellite_alt_outlined),
                  _mapTypeItem(
                      context,
                      MapType.terrain,
                      AppLocalizations.of(context)!.terrain,
                      Icons.terrain_outlined),
                  _mapTypeItem(
                      context,
                      MapType.hybrid,
                      AppLocalizations.of(context)!.hybrid,
                      Icons.layers_outlined),
                ],
                icon: Center(
                  child: Icon(Icons.layers_rounded, color: onSurface),
                ),
              ),
            ),
            Container(
              height: 1,
              width: 46,
              color: AppColors.surfaceBorder(context),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _recenter,
                child: Container(
                  height: 46,
                  width: 46,
                  decoration: const BoxDecoration(
                    gradient: AppColors.beaconGradient,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.my_location_rounded,
                      size: 21,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<MapType> _mapTypeItem(
      BuildContext context, MapType value, String label, IconData icon) {
    final color = Theme.of(context).primaryColorDark;
    return PopupMenuItem(
      value: value,
      height: 42,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          MyText(
            text: label,
            textStyle:
                Theme.of(context).textTheme.bodyMedium!.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.iconColor,
    this.gradient,
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Gradient? gradient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: SizedBox(
            height: 46,
            width: 46,
            child: Icon(icon, size: 21, color: iconColor),
          ),
        ),
      ),
    );
  }
}
