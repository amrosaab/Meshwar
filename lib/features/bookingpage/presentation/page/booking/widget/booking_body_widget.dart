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
import 'package:latlong2/latlong.dart' as fmlt;

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
    _onTripSheetController.dispose();
    super.dispose();
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
      final renderBox = _onTripContentKey.currentContext?.findRenderObject()
      as RenderBox?;
      if (renderBox == null || !renderBox.hasSize) return;

      final contentHeight = renderBox.size.height;
      if (contentHeight < 100) return; // Don't fit if content isn't rendered yet

      final fraction =
      ((contentHeight + 50) / screenHeight).clamp(0.4, 0.95);

      if (_onTripFittedSize != null &&
          (fraction - _onTripFittedSize!).abs() < 0.01) {
        return;
      }
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
                  ),
                if (!bookingBloc.isNormalRideSearching && !bookingBloc.isBiddingRideSearching)
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(size.width * 0.05),
                      child: Row(
                        children: [
                          if ((bookingBloc.isRentalRide && bookingBloc.rentalEtaDetailsList.isNotEmpty) || !bookingBloc.isRentalRide)
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
                    bookingBloc.onRideBottomPosition = notification.extent * size.height;
                    bookingBloc.add(UpdateEvent());
                    return true;
                  },
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.6,
                    minChildSize: 0.3,
                    maxChildSize: 0.6,
                    builder: (context, scrollController) {
                      return Container(
                        key: _bottomContentKey,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceStrong(context),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          boxShadow: AppColors.surfaceShadow(context),
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: BiddingWaitingForDriverConfirmation(
                            maximumTime: double.parse(
                              bookingBloc.userData!.maximumTimeForFindDriversForRegularRide,
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
                    bookingBloc.onRideBottomPosition = notification.extent * size.height;
                    bookingBloc.add(UpdateEvent());
                    return true;
                  },
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.35,
                    minChildSize: 0.35,
                    maxChildSize: 0.6,
                    builder: (context, scrollController) {
                      return Container(
                        key: _bottomContentKey,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceStrong(context),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          boxShadow: AppColors.surfaceShadow(context),
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: WaitingForDriverConfirmation(
                            maximumTime: double.parse(
                              bookingBloc.userData!.maximumTimeForFindDriversForRegularRide,
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
                    bookingBloc.onRideBottomPosition = notification.extent * size.height;
                    bookingBloc.add(UpdateEvent());
                    return true;
                  },
                  child: DraggableScrollableSheet(
                    controller: _onTripSheetController,
                    initialChildSize: _onTripFittedSize ?? 0.56,
                    minChildSize: 0.3,
                    maxChildSize: 0.9,
                    builder: (context, scrollController) {
                      _scheduleOnTripFit(size.height);
                      return Container(
                        key: _bottomContentKey,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceStrong(context),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                    bookingBloc.onRideBottomPosition = notification.extent * size.height;
                    bookingBloc.add(UpdateEvent());
                    return true;
                  },
                  child: DraggableScrollableSheet(
                    controller: bookingBloc.draggableController,
                    initialChildSize: (widget.arg.stopAddressList.length == 1
                        ? bookingBloc.currentSize 
                        : (widget.arg.stopAddressList.length == 2 
                            ? bookingBloc.currentSizeTwo 
                            : bookingBloc.currentSizeThree)).clamp(0.1, bookingBloc.maxChildSize),
                    minChildSize: (widget.arg.stopAddressList.length == 1
                        ? bookingBloc.minChildSize 
                        : (widget.arg.stopAddressList.length == 2 
                            ? bookingBloc.minChildSizeTwo 
                            : bookingBloc.minChildSizeThree)).clamp(0.1, bookingBloc.maxChildSize),
                    maxChildSize: bookingBloc.maxChildSize,
                    builder: (context, scrollController) {
                      return Container(
                        key: _bottomContentKey,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceStrong(context),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          border: Border(top: BorderSide(color: AppColors.surfaceBorder(context))),
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
                                ? bookingBloc.rentalEtaDetailsList[bookingBloc.selectedVehicleIndex]
                                : bookingBloc.isMultiTypeVechiles
                                ? bookingBloc.sortedEtaDetailsList[bookingBloc.selectedVehicleIndex]
                                : bookingBloc.etaDetailsList[bookingBloc.selectedVehicleIndex],
                          )
                              : RidePreviewWidget(cont: context, arg: widget.arg),
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

            // 3. Map Controls Layer
            Positioned(
              bottom: (bookingBloc.onRideBottomPosition > 0 ? bookingBloc.onRideBottomPosition-80 : _bottomContentHeight) + 16,
              right: 16,
              child: Column(
                children: [
                  if (!bookingBloc.isNormalRideSearching && !bookingBloc.isBiddingRideSearching) ...[
                    if (bookingBloc.mapType == 'google_map')
                      PopupMenuButton<MapType>(
                        color: AppColors.surfaceStrong(context),
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.surface(context),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.surfaceBorder(context)),
                          ),
                          child: Icon(Icons.layers, color: Theme.of(context).primaryColorDark),
                        ),
                        onSelected: (mapType) {
                          bookingBloc.add(UpdateMapTypeEvent(mapType));
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              value: MapType.normal,
                              child: MyText(
                                  text: AppLocalizations.of(context)!.normal,
                                  textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColorDark))),
                          PopupMenuItem(
                              value: MapType.satellite,
                              child: MyText(
                                  text: AppLocalizations.of(context)!.satellite,
                                  textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColorDark))),
                          PopupMenuItem(
                            value: MapType.terrain,
                            child: MyText(
                                text: AppLocalizations.of(context)!.terrain,
                                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColorDark)),
                          ),
                          PopupMenuItem(
                            value: MapType.hybrid,
                            child: MyText(
                                text: AppLocalizations.of(context)!.hybrid,
                                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColorDark)),
                          ),
                        ],
                      ),
                    InkWell(
                      onTap: () {
                        if (bookingBloc.googleMapController != null && bookingBloc.bound != null) {
                          if (bookingBloc.requestData != null && bookingBloc.requestData!.isRental) {
                            bookingBloc.add(BookingLocateMeEvent(
                                mapType: bookingBloc.mapType,
                                controller: (bookingBloc.mapType == 'google_map') ? bookingBloc.googleMapController : bookingBloc.fmController));
                          } else {
                            bookingBloc.googleMapController?.animateCamera(CameraUpdate.newLatLngBounds(bookingBloc.bound!, 100));
                          }
                        } else if (bookingBloc.fmController != null) {
                          bookingBloc.fmController?.move(
                              fmlt.LatLng(bookingBloc.bound!.northeast.latitude, bookingBloc.bound!.northeast.longitude), 14);
                        }
                      },
                      child: Container(
                        height: size.width * 0.11,
                        width: size.width * 0.11,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                          border: Border.all(width: 1.2, color: AppColors.primary),
                          boxShadow: AppColors.surfaceShadow(context),
                        ),
                        child: Center(
                          child: Icon(Icons.my_location, size: size.width * 0.05, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
