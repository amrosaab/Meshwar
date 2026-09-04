// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_dialoges.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../core/utils/custom_snack_bar.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../account/presentation/pages/outstation/page/outstation_page.dart';
import '../../../../../auth/presentation/pages/login_page.dart';
import '../../../../../home/presentation/pages/home_page.dart';
import '../../../../application/booking_bloc.dart';
import '../../../../domain/models/edit_location_model.dart';
import '../widget/booking_body_widget.dart';
import '../widget/bidding_ride/bidding_offer_price.dart';
import '../widget/bottom/booking_bottom_widget.dart';
import '../widget/bottom/select_booking_contact_list.dart';
import '../widget/bottom/select_booking_type_widget.dart';
import '../widget/on_ride/chat_with_driver.dart';
import '../widget/eta_detail_view.dart';
import '../widget/no_driver_found.dart';
import '../widget/rental_ride/rental_package_select.dart';
import '../widget/on_ride/select_cancel_reason.dart';
import '../widget/select_goods_type.dart';
import '../widget/on_ride/sos_notify.dart';
import '../../invoice/page/invoice_page.dart';
import 'edit_location_page.dart';

class BookingPage extends StatefulWidget {
  static const String routeName = '/booking';
  final BookingPageArguments arg;

  const BookingPage({super.key, required this.arg});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late BookingBloc _bookingBloc;
  @override
  void initState() {
    _bookingBloc = BookingBloc();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _bookingBloc.nearByVechileSubscription?.pause();
      _bookingBloc.etaDurationStream?.pause();
    }
    if (state == AppLifecycleState.resumed) {
      _bookingBloc.nearByVechileSubscription?.resume();
      _bookingBloc.etaDurationStream?.resume();
    }
  }

  @override
  void dispose() {
    _bookingBloc.add(BookingNavigatorPopEvent());
    CustomLoader.dismiss(context);
    _bookingBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return builderWidget();
  }

  Widget builderWidget() {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: _bookingBloc
        ..add(GetDirectionEvent(vsync: this))
        ..add(BookingInitEvent(arg: widget.arg, vsync: this)),
      child: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) async {
          final bookingBloc = context.read<BookingBloc>();
          if (state is BookingLoadingStartState) {
            CustomLoader.loader(context);
          } else if (state is BookingLoadingStopState) {
            CustomLoader.dismiss(context);
          } else if (state is BookingSuccessState) {
            bookingBloc.nearByVechileCheckStream(
                context,
                this,
                LatLng(double.parse(widget.arg.picklat),
                    double.parse(widget.arg.picklng)));
          } else if (state is LogoutState) {
            bookingBloc.nearByVechileSubscription?.cancel();
            Navigator.pushNamedAndRemoveUntil(
                context, LoginPage.routeName, (route) => false);
            await AppSharedPreference.setLoginStatus(false);
          } else if (state is BookingNavigatorPopState) {
            CustomLoader.dismiss(context);
            bookingBloc.nearByVechileSubscription?.cancel();
            if (bookingBloc.isPop) {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomePage.routeName, (route) => false);
            }
          } else if (state is SelectGoodsTypeState) {
            CustomLoader.dismiss(context);
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
              barrierColor: Colors.black54,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              builder: (_) {
                return SelectGoodsType(cont: context);
              },
            );
          } else if (state is ShowEtaInfoState) {
            CustomLoader.dismiss(context);
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              enableDrag: true,
              isScrollControlled: true,
              elevation: 0,
              barrierColor: Colors.black54,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              builder: (_) {
                return EtaDetailsWidget(
                  cont: context,
                  etaInfo: (!bookingBloc.isRentalRide)
                      ? bookingBloc.isMultiTypeVechiles
                      ? bookingBloc.sortedEtaDetailsList[state.infoIndex]
                      : bookingBloc.etaDetailsList[state.infoIndex]
                      : bookingBloc.rentalEtaDetailsList[state.infoIndex],
                  isReturnTime:
                  (bookingBloc.isOutstationRide && bookingBloc.isRoundTrip)
                      ? true
                      : false,
                );
              },
            );
          } else if (state is SelectBookingTypeState) {
            CustomLoader.dismiss(context);
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) {
                  return BlocProvider.value(
                    value: bookingBloc,
                    child: const SelectBookingTypeWidget(),
                  );
                });
          } else if (state is SelectContactDetailsState) {
            CustomLoader.dismiss(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: bookingBloc,
                  child: const SelectBookingContactList(),
                ),
              ),
            );
          } else if (state is ShowBiddingState) {
            bookingBloc.farePriceController.text = bookingBloc
                .isMultiTypeVechiles
                ? (bookingBloc.isOutstationRide && bookingBloc.isRoundTrip)
                ? (bookingBloc
                .sortedEtaDetailsList[
            bookingBloc.selectedVehicleIndex]
                .total *
                2)
                .toString()
                : bookingBloc
                .sortedEtaDetailsList[bookingBloc.selectedVehicleIndex]
                .total
                .toString()
                : (bookingBloc.isOutstationRide && bookingBloc.isRoundTrip)
                ? (bookingBloc
                .etaDetailsList[
            bookingBloc.selectedVehicleIndex]
                .total *
                2)
                .toString()
                : bookingBloc
                .etaDetailsList[bookingBloc.selectedVehicleIndex].total
                .toString();
            // Initialize bidding flags based on the just-set fare and allowed range
            try {
              final bool multi = bookingBloc.isMultiTypeVechiles;
              final String lowPct = multi
                  ? bookingBloc
                  .sortedEtaDetailsList[bookingBloc.selectedVehicleIndex]
                  .biddingLowPercentage
                  : bookingBloc.etaDetailsList[bookingBloc.selectedVehicleIndex]
                  .biddingLowPercentage;
              final String highPct = multi
                  ? bookingBloc
                  .sortedEtaDetailsList[bookingBloc.selectedVehicleIndex]
                  .biddingHighPercentage
                  : bookingBloc.etaDetailsList[bookingBloc.selectedVehicleIndex]
                  .biddingHighPercentage;

              final double baseTotal = multi
                  ? (bookingBloc.isOutstationRide && bookingBloc.isRoundTrip)
                  ? (bookingBloc
                  .sortedEtaDetailsList[
              bookingBloc.selectedVehicleIndex]
                  .total *
                  2)
                  : bookingBloc
                  .sortedEtaDetailsList[
              bookingBloc.selectedVehicleIndex]
                  .total
                  : (bookingBloc.isOutstationRide && bookingBloc.isRoundTrip)
                  ? (bookingBloc
                  .etaDetailsList[bookingBloc.selectedVehicleIndex]
                  .total *
                  2)
                  : bookingBloc
                  .etaDetailsList[bookingBloc.selectedVehicleIndex]
                  .total;
              final double current =
                  double.tryParse(bookingBloc.farePriceController.text) ??
                      baseTotal;
              final double minAllowed = (lowPct == '0')
                  ? 0.0
                  : baseTotal - ((double.parse(lowPct) / 100) * baseTotal);
              final double maxAllowed = (highPct == '0')
                  ? double.infinity
                  : baseTotal + ((double.parse(highPct) / 100) * baseTotal);
              bookingBloc.isBiddingDecreaseLimitReach = current <= minAllowed;
              bookingBloc.isBiddingIncreaseLimitReach =
                  maxAllowed != double.infinity && current >= maxAllowed;
            } catch (e) {
              bookingBloc.isBiddingDecreaseLimitReach = false;
              bookingBloc.isBiddingIncreaseLimitReach = false;
            }
            CustomLoader.dismiss(context);
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              enableDrag: true,
              elevation: 0,
              isScrollControlled: true,
              barrierColor: Colors.black54,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              builder: (_) {
                return BiddingOfferingPriceWidget(
                    cont: context, arg: widget.arg);
              },
            );
          } else if (state is BiddingCreateRequestSuccessState) {
            bookingBloc.timerCount(context,
                isNormalRide: false,
                duration: int.parse(widget
                    .arg.userData.maximumTimeForFindDriversForRegularRide));
          } else if (state is BookingCreateRequestSuccessState) {
            bookingBloc.timerCount(context,
                isNormalRide: true,
                duration: int.parse(widget
                    .arg.userData.maximumTimeForFindDriversForRegularRide));
          } else if (state is BookingNoDriversFoundState) {
            CustomLoader.dismiss(context);
            showModalBottomSheet(
              context: context,
              isDismissible: false,
              enableDrag: false,
              elevation: 0,
              barrierColor: Colors.black54,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              builder: (_) {
                return BlocProvider.value(
                  value: bookingBloc,
                  child: const NoDriverFoundWidget(),
                );
              },
            );
          } else if (state is BookingLaterCreateRequestSuccessState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return PopScope(
                  canPop: false,
                  child: CustomSingleButtonDialoge(
                    title: AppLocalizations.of(context)!.success,
                    content:
                    AppLocalizations.of(context)!.rideScheduledSuccessfully,
                    btnName: AppLocalizations.of(context)!.okText,
                    onTap: () {
                      context
                          .read<BookingBloc>()
                          .nearByVechileSubscription
                          ?.cancel();
                      Navigator.pop(context);
                      if (state.isOutstation) {
                        Navigator.pushNamed(
                            context, OutstationHistoryPage.routeName,
                            arguments: OutstationHistoryPageArguments(
                                isFromBooking: true));
                      } else {
                        Navigator.pushNamedAndRemoveUntil(
                            context, HomePage.routeName, (route) => false);
                      }
                    },
                  ),
                );
              },
            );
          } else if (state is BookingOnTripRequestState) {
            Navigator.pop(context);
          } else if (state is CancelReasonState) {
            CustomLoader.dismiss(context);
            showModalBottomSheet(
              context: context,
              isDismissible: false,
              enableDrag: false,
              isScrollControlled: true,
              showDragHandle: false,
              elevation: 0,
              barrierColor: AppColors.transparent,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              useSafeArea: true,
              builder: (_) {
                return BlocProvider.value(
                  value: bookingBloc,
                  child: const SelectCancelReasonList(),
                );
              },
            );
          } else if (state is ChatWithDriverState) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: bookingBloc,
                      child: const ChatWithDriverWidget(),
                    )));
          } else if (state is TripRideCancelState) {
            if (state.isCancelByDriver) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return PopScope(
                    canPop: false,
                    child: CustomSingleButtonDialoge(
                      title: AppLocalizations.of(context)!.rideCancelled,
                      content:
                      AppLocalizations.of(context)!.rideCancelledByDriver,
                      btnName: AppLocalizations.of(context)!.okText,
                      onTap: () {
                        bookingBloc.nearByVechileSubscription?.cancel();
                        Navigator.pop(context);
                        bookingBloc.isTripStart = false;
                        Navigator.pushNamedAndRemoveUntil(
                            context, HomePage.routeName, (route) => false);
                      },
                    ),
                  );
                },
              );
            } else if (!state.isCancelByDriver) {
              bookingBloc.nearByVechileSubscription?.cancel();
              Navigator.pushNamedAndRemoveUntil(
                  context, HomePage.routeName, (route) => false);
            }
          } else if (state is SosState) {
            CustomLoader.dismiss(context);
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              enableDrag: true,
              useRootNavigator: true,
              isScrollControlled: true,
              elevation: 0,
              barrierColor: Colors.black54,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              builder: (_) {
                return BlocProvider.value(
                    value: bookingBloc, child: const SOSAlertWidget());
              },
            );
          } else if (state is TripCompletedState) {
            bookingBloc.nearByVechileSubscription?.cancel();
            Navigator.pushNamedAndRemoveUntil(
                context,
                InvoicePage.routeName,
                arguments: InvoicePageArguments(
                    requestData: bookingBloc.requestData!,
                    requestBillData: bookingBloc.requestBillData!,
                    driverData: bookingBloc.driverData!,
                    rideRepository: state.rideRepository),
                    (route) => false);
          } else if (state is EtaNotAvailableState) {
          } else if (state is RentalPackageSelectState) {
            bookingBloc.add(BookingRentalEtaRequestEvent(
              picklat: widget.arg.picklat,
              picklng: widget.arg.picklng,
              transporttype: bookingBloc.transportType,
              preferenceId: bookingBloc.selectPreference,
            ));
            WidgetsBinding.instance.addPostFrameCallback(
                  (timeStamp) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  isDismissible: true,
                  enableDrag: true,
                  barrierColor: Colors.black54,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  builder: (_) {
                    return BlocProvider.value(
                      value: bookingBloc,
                      child:
                      PopScope(canPop: false, child: packageList(context)),
                    );
                  },
                ).whenComplete(
                      () {
                    if (bookingBloc.rentalEtaDetailsList.isEmpty) {
                      bookingBloc.add(BookingNavigatorPopEvent());
                    }
                  },
                );
              },
            );
          } else if (state is RentalPackageConfirmState) {
            if (bookingBloc.rentalEtaDetailsList.isNotEmpty) {
              Navigator.pop(context);
            } else {
              showToast(message: AppLocalizations.of(context)!.noDriverFound);
            }
          } else if (state is EditLocationState) {
            Navigator.pushNamed(context, EditLocationPage.routeName,
                arguments: EditLocationPageArguments(
                    addressList: state.addressList,
                    requestData: state.requestData,
                    mapType: bookingBloc.mapType,
                    userData: bookingBloc.userData!,
                    selectedServiceIndex: widget.arg.selectedServiceIndex))
                .then(
                  (value) {
                if (value != null) {
                  if (value is EditLocation) {
                    bookingBloc.requestData = value.requestData;
                    bookingBloc.dropAddressList = value.dropAddressList;
                    bookingBloc.add(UpdateEvent());
                  }
                }
              },
            );
          } else if (state is DistanceTooLongState) {
            CustomLoader.dismiss(context);
            showModalBottomSheet(
              context: context,
              isDismissible: false,
              enableDrag: false,
              isScrollControlled: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) {
                return WillPopScope(
                  onWillPop: () async => false,
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 0,
                        right: 0,
                        top: 32,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: Image.asset(
                                  AppImages.distanceImage,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 24),
                              MyText(
                                text: AppLocalizations.of(context)!
                                    .maxDistanceTitle,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              MyText(
                                text: AppLocalizations.of(context)!
                                    .convertToOutstation,
                                textAlign: TextAlign.center,
                                textStyle:
                                Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 32),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomButton(
                                    buttonName:
                                    AppLocalizations.of(context)!.no,
                                    borderRadius: 5,
                                    isBorder: true,
                                    width: size.width * 0.4,
                                    height: size.width * 0.1,
                                    buttonColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    textSize: context
                                        .read<BookingBloc>()
                                        .languageCode ==
                                        'fr'
                                        ? 14
                                        : null,
                                    textColor: Theme.of(context).primaryColor,
                                    onTap: () {
                                      Navigator.pop(context);
                                      bookingBloc
                                          .add(BookingNavigatorPopEvent());
                                    },
                                  ),
                                  CustomButton(
                                    buttonName:
                                    AppLocalizations.of(context)!.yes,
                                    borderRadius: 5,
                                    width: size.width * 0.4,
                                    height: size.width * 0.1,
                                    buttonColor: Theme.of(context).primaryColor,
                                    textColor: AppColors.white,
                                    onTap: () {
                                      Navigator.pop(context);
                                      // Determine transport type for outstation ride based on user data
                                      final transportType = (widget.arg.userData
                                          .showTaxiOutstationRideFeature ==
                                          '1')
                                          ? 'taxi'
                                          : (widget.arg.userData
                                          .showDeliveryOutstationRideFeature ==
                                          '1')
                                          ? 'delivery'
                                          : widget.arg.transportType;

                                      bookingBloc.add(BookingInitEvent(
                                        vsync: this,
                                        arg: BookingPageArguments(
                                          picklat: widget.arg.picklat,
                                          picklng: widget.arg.picklng,
                                          droplat: widget.arg.droplat,
                                          droplng: widget.arg.droplng,
                                          pickupAddressList:
                                          widget.arg.pickupAddressList,
                                          stopAddressList:
                                          widget.arg.stopAddressList,
                                          userData: widget.arg.userData,
                                          transportType:
                                          transportType, // Use the determined transport type
                                          polyString: widget.arg.polyString,
                                          distance: widget.arg.distance,
                                          duration: widget.arg.duration,
                                          mapType: widget.arg.mapType,
                                          isOutstationRide:
                                          true, // Explicitly set to true for outstation ride
                                          preferenceId: widget.arg.preferenceId,
                                          selectedServiceIndex:
                                          widget.arg.selectedServiceIndex,
                                        ),
                                      ));
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is OutstationDistanceTooLongState) {
            showModalBottomSheet(
              context: context,
              isDismissible: false,
              enableDrag: false,
              isScrollControlled: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) {
                return WillPopScope(
                  onWillPop: () async => false,
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 0,
                        right: 0,
                        top: 32,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: Image.asset(
                                  AppImages.distanceImage,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 24),
                              MyText(
                                text: AppLocalizations.of(context)!
                                    .maxDistanceTitle,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              MyText(
                                text: AppLocalizations.of(context)!
                                    .maxDistanceText,
                                maxLines: 5,
                                textAlign: TextAlign.start,
                                textStyle:
                                Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 32),
                              CustomButton(
                                buttonName:
                                AppLocalizations.of(context)!.changeRoute,
                                borderRadius: 20,
                                buttonColor: Theme.of(context).primaryColor,
                                onTap: () {
                                  Navigator.pop(context);
                                  bookingBloc.add(BookingNavigatorPopEvent());
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
        child: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            final bookingBloc = context.read<BookingBloc>();
            return Material(
              child: Directionality(
                textDirection: bookingBloc.textDirection == 'rtl'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: PopScope(
                  canPop: true,
                  child: SafeArea(
                    top: false,
                    child: Scaffold(
                      resizeToAvoidBottomInset: false,
                      body: BookingBodyWidget(cont: context, arg: widget.arg),
                      bottomNavigationBar: (bookingBloc.isNormalRideSearching ||
                          bookingBloc.isBiddingRideSearching)
                          ? null
                          : (!bookingBloc.isTripStart)
                          ? ((!bookingBloc.isRentalRide &&
                          bookingBloc
                              .etaDetailsList.isNotEmpty) ||
                          (bookingBloc.isRentalRide &&
                              bookingBloc
                                  .rentalEtaDetailsList.isNotEmpty))
                          ? BookingBottomWidget(
                          cont: context, arg: widget.arg)
                          : null
                          : null,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}