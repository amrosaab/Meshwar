// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../bookingpage/presentation/page/booking/page/booking_page.dart';
import '../../../bookingpage/presentation/page/invoice/page/invoice_page.dart';
import '../../../loading/application/loader_bloc.dart';
import '../../../userprofile/presentation/pages/driver_profile_pages.dart';
import '../../application/home_bloc.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_text.dart';
import '../../domain/models/stop_address_model.dart';
import '../widgets/bottom_navigationbar_widget.dart';
import '../widgets/get_location_permission.dart';
import '../widgets/home_body_main_widget.dart';
import '../widgets/home_page_shimmer.dart';
import '../widgets/send_receive_delivery.dart';
import '../../../account/presentation/pages/account_page.dart';
import '../../../account/presentation/pages/history/page/history_page.dart';
import '../../../account/presentation/pages/wallet/page/wallet_page.dart';
import '../../../account/presentation/pages/history/page/trip_summary_history.dart';
import 'confirm_location_page.dart';
import 'destination_page.dart';
import 'on_going_rides.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/homePage';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  int _bottomNavIndex = 0;
  late HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Create bloc ONCE in initState
    _homeBloc = HomeBloc()
      ..add(GetDirectionEvent())
      ..add(GetRideModulesEvent())
      ..add(GetUserDetailsEvent());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _homeBloc.nearByVechileSubscription?.pause();
    }
    if (state == AppLifecycleState.resumed) {
      _homeBloc.nearByVechileSubscription?.resume();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _homeBloc.nearByVechileSubscription?.cancel();
    _homeBloc.nearByVechileSubscription = null;
    _homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      CustomLoader.dismiss(context);
    });
    final size = MediaQuery.of(context).size;
    return builderWidget(size);
  }

  Widget builderWidget(Size size) {
    return BlocProvider<HomeBloc>.value(
      value: _homeBloc,
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) async {
          final homeBloc = context.read<HomeBloc>();

          if (state is DocumentApprovedFailureState) {
            homeBloc.isLoading = false;
            Navigator.pushNamedAndRemoveUntil(
              context,
              DriverProfilePage.routeName,
                  (route) => false,
              arguments: const DriverProfilePageArguments(from: 'onboarding'),
            );
          }

          // Handle other states
          if (state is HomeLoadingStopState ||
              state is HomeUpdateState ||
              state is OnGoingRidesSuccessState ||
              state is UpcomingRidesSuccessState ||
              state is OnGoingRidesFailureState ||
              state is UpcomingRidesFailureState ||
              state is ServiceNotAvailableState) {
            homeBloc.isLoading = false;
          } else if (state is VechileStreamMarkerState) {
            if (homeBloc.nearByVechileSubscription == null) {
              homeBloc.nearByVechileCheckStream(context, this);
            }
          } else if (state is UpdateZoneLocationState) {
            if (homeBloc.mapType == 'google_map') {
              context.read<LoaderBloc>().add(GoogleUpdateUserLocationEvent());
            } else {
              context.read<LoaderBloc>().add(UpdateUserLocationEvent());
            }
          } else if (state is LogoutState) {
            if (homeBloc.nearByVechileSubscription != null) {
              homeBloc.nearByVechileSubscription?.cancel();
              homeBloc.nearByVechileSubscription = null;
            }
            Navigator.pushNamedAndRemoveUntil(
                context, LoginPage.routeName, (route) => false);
            await AppSharedPreference.setLoginStatus(false);
          } else if (state is PromotionsPopupVisibleState) {
          } else if (state is GetLocationPermissionState) {
            showDialog(
              context: context,
              builder: (_) {
                return GetLocationPermissionWidget(cont: context);
              },
            );
          } else if (state is NavigateToOnGoingRidesPageState) {
            Navigator.pushNamed(context, OnGoingRidesPage.routeName,
                arguments: OnGoingRidesPageArguments(
                  userData: homeBloc.userData!,
                  mapType: homeBloc.mapType,
                  selectedServiceIndex: homeBloc.selectedServiceIndex,
                )).then(
                  (value) {
                if (!context.mounted) return;
                homeBloc.add(GetUserDetailsEvent());
              },
            );
          } else if (state is UserOnTripState &&
              state.tripData.acceptedAt == '') {
            if (homeBloc.nearByVechileSubscription != null) {
              homeBloc.nearByVechileSubscription?.cancel();
              homeBloc.nearByVechileSubscription = null;
            }
            Navigator.pushNamedAndRemoveUntil(
              context,
              BookingPage.routeName,
                  (route) => false,
              arguments: BookingPageArguments(
                picklat: state.tripData.pickLat,
                picklng: state.tripData.pickLng,
                droplat: state.tripData.dropLat,
                droplng: state.tripData.dropLng,
                pickupAddressList: homeBloc.pickupAddressList,
                stopAddressList: homeBloc.stopAddressList,
                userData: homeBloc.userData!,
                transportType: state.tripData.transportType,
                polyString: state.tripData.polyLine,
                distance: (double.parse(state.tripData.totalDistance) * 1000)
                    .toString(),
                duration: state.tripData.totalTime.toString(),
                isRentalRide: state.tripData.isRental,
                isWithoutDestinationRide: ((state.tripData.dropLat.isEmpty &&
                    state.tripData.dropLng.isEmpty) &&
                    !state.tripData.isRental)
                    ? true
                    : false,
                isOutstationRide: state.tripData.isOutStation == "1",
                mapType: homeBloc.mapType,
                isMyself: homeBloc.isMyselfSelected,
                contactName: homeBloc.selectedContactName,
                contactNumber: homeBloc.selectedContactMobile,
                isBiddingRide: state.tripData.isBidRide == 1,
                selectedServiceIndex: homeBloc.selectedServiceIndex,
              ),
            );
          } else if (state is DeliverySelectState) {
            CustomLoader.dismiss(context);
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              enableDrag: false,
              isScrollControlled: true,
              builder: (_) {
                return SendOrReceiveDelivery(cont: context);
              },
            );
          } else if (state is DestinationSelectState) {
            CustomLoader.dismiss(context);
            Navigator.pushNamed(
              context,
              DestinationPage.routeName,
              arguments: DestinationPageArguments(
                title: 'Taxi',
                pickupAddress: homeBloc.currentLocation,
                pickupLatLng: homeBloc.currentLatLng,
                dropAddress: state.dropAddress,
                dropLatLng: state.dropLatLng,
                userData: homeBloc.userData!,
                pickUpChange: state.isPickupChange,
                transportType: state.transportType,
                isOutstationRide: false,
                isBiddingRide: state.isBiddingRide,
                isSharedRide: state.isSharedRide,
                mapType: homeBloc.mapType,
                selectedServiceIndex: homeBloc.selectedServiceIndex,
              ),
            );
          } else if (state is OutStationSelectState) {
            CustomLoader.dismiss(context);
            Navigator.pushNamed(
              context,
              DestinationPage.routeName,
              arguments: DestinationPageArguments(
                title: homeBloc.selectedServiceType!.transportType == 'taxi'
                    ? 'Taxi'
                    : 'Delivery',
                pickupAddress: homeBloc.currentLocation,
                pickupLatLng: homeBloc.currentLatLng,
                userData: homeBloc.userData!,
                pickUpChange: false,
                transportType: homeBloc.transportType,
                isOutstationRide: true,
                mapType: homeBloc.mapType,
                selectedServiceIndex: homeBloc.selectedServiceIndex,
              ),
            );
          } else if (state is RecentSearchPlaceSelectState) {
            if (state.serviceTypeIndex == 1) {
              // Delivery
              CustomLoader.dismiss(context);
              showModalBottomSheet(
                context: context,
                isDismissible: true,
                enableDrag: false,
                isScrollControlled: true,
                builder: (_) {
                  return SendOrReceiveDelivery(cont: context);
                },
              );
            } else if (state.serviceTypeIndex == 3 &&
                state.transportType.toLowerCase() == 'delivery') {
              CustomLoader.dismiss(context);
              Navigator.pushNamed(
                context,
                DestinationPage.routeName,
                arguments: DestinationPageArguments(
                  title: homeBloc.selectedServiceType!.transportType == 'taxi'
                      ? 'Taxi'
                      : 'Delivery',
                  pickupAddress: homeBloc.currentLocation,
                  pickupLatLng: homeBloc.currentLatLng,
                  userData: homeBloc.userData!,
                  pickUpChange: false,
                  transportType: homeBloc.transportType,
                  isOutstationRide: true,
                  mapType: homeBloc.mapType,
                  selectedServiceIndex: homeBloc.selectedServiceIndex,
                ),
              );
            } else if (homeBloc.pickupAddressList.isNotEmpty &&
                homeBloc.stopAddressList.length == 1) {
              if (homeBloc.nearByVechileSubscription != null) {
                homeBloc.nearByVechileSubscription?.cancel();
                homeBloc.nearByVechileSubscription = null;
              }
              Navigator.pushNamed(
                context,
                BookingPage.routeName,
                arguments: BookingPageArguments(
                  picklat: context
                      .read<HomeBloc>()
                      .pickupAddressList
                      .first
                      .lat
                      .toString(),
                  picklng: context
                      .read<HomeBloc>()
                      .pickupAddressList
                      .first
                      .lng
                      .toString(),
                  droplat: context
                      .read<HomeBloc>()
                      .stopAddressList
                      .last
                      .lat
                      .toString(),
                  droplng: context
                      .read<HomeBloc>()
                      .stopAddressList
                      .last
                      .lng
                      .toString(),
                  userData: homeBloc.userData!,
                  transportType: state.transportType,
                  pickupAddressList: homeBloc.pickupAddressList,
                  stopAddressList: homeBloc.stopAddressList,
                  polyString: '',
                  distance: '',
                  duration: '',
                  isOutstationRide: state.serviceTypeIndex == 3,
                  mapType: homeBloc.mapType,
                  isMyself: homeBloc.isMyselfSelected,
                  contactName: homeBloc.selectedContactName,
                  contactNumber: homeBloc.selectedContactMobile,
                  isBiddingRide: state.serviceTypeIndex == 4,
                  isSharedRide: state.serviceTypeIndex == 5,
                  isRentalRide: state.serviceTypeIndex == 2,
                  selectedServiceIndex: homeBloc.selectedServiceIndex,
                ),
              ).then(
                    (value) {
                  if (!context.mounted) return;
                  homeBloc.stopAddressList.clear();
                },
              );
            } else {
              homeBloc.stopAddressList.clear();
            }
          } else if (state is ConfirmRideAddressState) {
            if (homeBloc.selectedServiceIndex != 1 &&
                homeBloc.pickupAddressList.isNotEmpty &&
                homeBloc.stopAddressList.length == 1) {
              if (homeBloc.nearByVechileSubscription != null) {
                homeBloc.nearByVechileSubscription?.cancel();
                homeBloc.nearByVechileSubscription = null;
              }
              Navigator.pushNamed(
                context,
                BookingPage.routeName,
                arguments: BookingPageArguments(
                  picklat: context
                      .read<HomeBloc>()
                      .pickupAddressList
                      .first
                      .lat
                      .toString(),
                  picklng: context
                      .read<HomeBloc>()
                      .pickupAddressList
                      .first
                      .lng
                      .toString(),
                  droplat: context
                      .read<HomeBloc>()
                      .stopAddressList
                      .last
                      .lat
                      .toString(),
                  droplng: context
                      .read<HomeBloc>()
                      .stopAddressList
                      .last
                      .lng
                      .toString(),
                  userData: homeBloc.userData!,
                  transportType: homeBloc.transportType,
                  pickupAddressList: homeBloc.pickupAddressList,
                  stopAddressList: homeBloc.stopAddressList,
                  polyString: '',
                  distance: '',
                  duration: '',
                  isOutstationRide: homeBloc.selectedServiceIndex == 3,
                  mapType: homeBloc.mapType,
                  isMyself: homeBloc.isMyselfSelected,
                  contactName: homeBloc.selectedContactName,
                  contactNumber: homeBloc.selectedContactMobile,
                  isBiddingRide: homeBloc.selectedServiceIndex == 4,
                  isSharedRide: homeBloc.selectedServiceIndex == 5,
                  isRentalRide: homeBloc.selectedServiceIndex == 2,
                  selectedServiceIndex: homeBloc.selectedServiceIndex,
                ),
              ).then(
                    (value) {
                  if (!context.mounted) return;
                  homeBloc.stopAddressList.clear();
                },
              );
            } else if (homeBloc.selectedServiceIndex != 1) {
              homeBloc.stopAddressList.clear();
            }
          } else if (state is RentalSelectState) {
            Navigator.pushNamed(context, ConfirmLocationPage.routeName,
                arguments: ConfirmLocationPageArguments(
                  userData: homeBloc.userData!,
                  isPickupEdit: true,
                  isOutstationRide: false,
                  isEditAddress: false,
                  mapType: homeBloc.mapType,
                  transportType: homeBloc.transportType,
                  selectedServiceIndex: homeBloc.selectedServiceIndex,
                )).then(
                  (value) {
                if (!context.mounted) return;
                if (value != null) {
                  if (homeBloc.nearByVechileSubscription != null) {
                    homeBloc.nearByVechileSubscription?.cancel();
                    homeBloc.nearByVechileSubscription = null;
                  }
                  homeBloc.pickupAddressList.clear();
                  final add = value as AddressModel;
                  homeBloc.pickupAddressList.add(add);
                  Navigator.pushNamed(
                    context,
                    BookingPage.routeName,
                    arguments: BookingPageArguments(
                      picklat: context
                          .read<HomeBloc>()
                          .pickupAddressList[0]
                          .lat
                          .toString(),
                      picklng: context
                          .read<HomeBloc>()
                          .pickupAddressList[0]
                          .lng
                          .toString(),
                      droplat: '',
                      droplng: '',
                      userData: homeBloc.userData!,
                      transportType: homeBloc.transportType,
                      pickupAddressList: homeBloc.pickupAddressList,
                      stopAddressList: [],
                      polyString: '',
                      distance: '',
                      duration: '',
                      mapType: homeBloc.mapType,
                      isOutstationRide: homeBloc.selectedServiceIndex == 3,
                      isRentalRide: true,
                      isMyself: homeBloc.isMyselfSelected,
                      contactName: homeBloc.selectedContactName,
                      contactNumber: homeBloc.selectedContactMobile,
                      isBiddingRide: false,
                      isSharedRide: false,
                      selectedServiceIndex: homeBloc.selectedServiceIndex,
                    ),
                  );
                }
              },
            );
          } else if (state is RideWithoutDestinationState) {
            Navigator.pushNamed(context, ConfirmLocationPage.routeName,
                arguments: ConfirmLocationPageArguments(
                  userData: homeBloc.userData!,
                  isPickupEdit: true,
                  isEditAddress: false,
                  isOutstationRide: false,
                  mapType: homeBloc.mapType,
                  transportType: homeBloc.transportType,
                  selectedServiceIndex: homeBloc.selectedServiceIndex,
                )).then(
                  (value) {
                if (!context.mounted) return;
                if (value != null) {
                  if (homeBloc.nearByVechileSubscription != null) {
                    homeBloc.nearByVechileSubscription?.cancel();
                    homeBloc.nearByVechileSubscription = null;
                  }
                  homeBloc.pickupAddressList.clear();
                  final add = value as AddressModel;
                  homeBloc.pickupAddressList.add(add);
                  Navigator.pushNamed(
                    context,
                    BookingPage.routeName,
                    arguments: BookingPageArguments(
                      picklat: context
                          .read<HomeBloc>()
                          .pickupAddressList[0]
                          .lat
                          .toString(),
                      picklng: context
                          .read<HomeBloc>()
                          .pickupAddressList[0]
                          .lng
                          .toString(),
                      droplat: '',
                      droplng: '',
                      userData: homeBloc.userData!,
                      transportType: 'taxi',
                      pickupAddressList: homeBloc.pickupAddressList,
                      stopAddressList: [],
                      polyString: '',
                      distance: '',
                      duration: '',
                      mapType: homeBloc.mapType,
                      isRentalRide: false,
                      isOutstationRide: homeBloc.selectedServiceIndex == 3,
                      isWithoutDestinationRide: true,
                      isMyself: homeBloc.isMyselfSelected,
                      contactName: homeBloc.selectedContactName,
                      contactNumber: homeBloc.selectedContactMobile,
                      isBiddingRide: false,
                      isSharedRide: false,
                      selectedServiceIndex: homeBloc.selectedServiceIndex,
                    ),
                  );
                }
              },
            );
          } else if (state is UserOnTripState) {
            if (homeBloc.nearByVechileSubscription != null) {
              homeBloc.nearByVechileSubscription?.cancel();
              homeBloc.nearByVechileSubscription = null;
            }
            Navigator.pushNamedAndRemoveUntil(
                context, BookingPage.routeName, (route) => false,
                arguments: BookingPageArguments(
                  picklat: state.tripData.pickLat,
                  picklng: state.tripData.pickLng,
                  droplat: state.tripData.dropLat,
                  droplng: state.tripData.dropLng,
                  pickupAddressList: homeBloc.pickupAddressList,
                  stopAddressList: homeBloc.stopAddressList,
                  userData: homeBloc.userData!,
                  transportType: state.tripData.transportType,
                  polyString: state.tripData.polyLine,
                  distance: (double.parse(state.tripData.totalDistance) * 1000)
                      .toString(),
                  duration: state.tripData.totalTime.toString(),
                  requestId: state.tripData.id,
                  mapType: homeBloc.mapType,
                  isOutstationRide: state.tripData.isOutStation == "1",
                  isMyself: homeBloc.isMyselfSelected,
                  contactName: homeBloc.selectedContactName,
                  contactNumber: homeBloc.selectedContactMobile,
                  isBiddingRide: state.tripData.isBidRide == 1,
                  selectedServiceIndex: homeBloc.selectedServiceIndex,
                ));
          } else if (state is UserTripSummaryState) {
            if (homeBloc.nearByVechileSubscription != null) {
              homeBloc.nearByVechileSubscription?.cancel();
              homeBloc.nearByVechileSubscription = null;
            }
            Navigator.pushNamedAndRemoveUntil(
              context,
              InvoicePage.routeName,
                  (route) => false,
              arguments: InvoicePageArguments(
                  requestData: state.requestData,
                  requestBillData: state.requestBillData,
                  driverData: state.driverData,
                  rideRepository: state.rideRepository),
            );
          } else if (state is ServiceNotAvailableState) {
            homeBloc.stopAddressList.clear();
            showDialog(
              context: context,
              builder: (_) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  insetPadding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceStrong(context),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: AppColors.surfaceBorder(context)),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.meshwarRed.withOpacity(0.15),
                              blurRadius: 30,
                              spreadRadius: -8,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                                alignment: homeBloc.textDirection == 'rtl'
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(Icons.close_rounded,
                                        color: AppColors.darkGrey, size: 22))),
                            Container(
                              height: 48,
                              width: 48,
                              margin: const EdgeInsets.only(bottom: 14),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.red,
                              ),
                              child: const Icon(Icons.info_outline_rounded,
                                  color: Colors.white, size: 24),
                            ),
                            MyText(
                              text: state.message,
                              maxLines: 4,
                              textAlign: TextAlign.center,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Theme.of(context).primaryColorDark),
                            ),
                            const SizedBox(height: 18),
                            CustomButton(
                              width: double.infinity,
                              buttonName: AppLocalizations.of(context)!.okText,
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is ChangeBottomNavIndexState) {
            setState(() {
              _bottomNavIndex = state.index;
            });
            if (state.pushTripSummary &&
                state.historyData != null &&
                state.historyIndex != null) {
              Navigator.pushNamed(
                context,
                HistoryTripSummaryPage.routeName,
                arguments: TripHistoryPageArguments(
                  historyData: state.historyData!,
                  historyIndex: state.historyIndex!,
                  isSupportTicketEnabled: context
                      .read<HomeBloc>()
                      .userData
                      ?.enableSupportTicketFeature ??
                      '0',
                  pageNumber: 1,
                ),
              );
            }
            // } else if (state is DocumentApprovedFailureState) {
            //   Navigator.pushNamedAndRemoveUntil(
            //     context,
            //     DriverProfilePage.routeName,
            //     (route) => false,
            //     arguments: const DriverProfilePageArguments(from: 'onboarding'),
            //   );
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final homeBloc = context.read<HomeBloc>();
            if (homeBloc.mapType == 'google_map' &&
                homeBloc.googleMapController != null) {
              Future.microtask(() {
                if (!context.mounted) return;

                try {
                  if (Theme.of(context).brightness == Brightness.dark) {
                    homeBloc.googleMapController!
                        .setMapStyle(homeBloc.darkMapString);
                  } else {
                    homeBloc.googleMapController!
                        .setMapStyle(homeBloc.lightMapString);
                  }
                } catch (_) {
                  // silently ignore disposed controller
                }
              });
            }

            return PopScope(
              canPop: _bottomNavIndex == 0,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                setState(() {
                  _bottomNavIndex = 0;
                });
              },
              child: SafeArea(
                bottom: false,
                top: false,
                child: Material(
                  child: Directionality(
                    textDirection: homeBloc.textDirection == 'rtl'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: Scaffold(
                        backgroundColor: Colors.transparent,
                        extendBody: true,
                        body: (homeBloc.userData != null &&
                            ((homeBloc.userData!.onTripRequest == null ||
                                homeBloc.userData!.onTripRequest ==
                                    "") ||
                                (homeBloc.userData!.metaRequest == null ||
                                    homeBloc.userData!.metaRequest == "")))
                            ? IndexedStack(
                          index: _bottomNavIndex,
                          children: [
                            HomeBodyMainWidget(home: homeBloc),
                            HistoryPage(
                              arg: HistoryPageArguments(
                                isSupportTicketEnabled: homeBloc
                                    .userData!.enableSupportTicketFeature,
                                userData: homeBloc.userData!,
                              ),
                            ),
                            WalletHistoryPage(
                              arg: WalletPageArguments(
                                  userData: homeBloc.userData!),
                            ),
                            AccountPage(
                              arg: AccountPageArguments(
                                  userData: homeBloc.userData!,
                                  selectedServiceIndex:
                                  homeBloc.selectedServiceIndex),
                            ),
                          ],
                        )
                            : HomePageShimmer(size: size),
                        bottomNavigationBar: homeBloc.userData != null
                            ? BottomNavigationbarWidget(
                          index: _bottomNavIndex,
                          userData: homeBloc.userData!,
                          onTap: (index) {
                            setState(() {
                              _bottomNavIndex = index;
                            });
                          },
                        )
                            : const SizedBox.shrink()),
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