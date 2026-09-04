// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_appbar.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../bookingpage/presentation/page/booking/page/booking_page.dart';
import '../../../bookingpage/presentation/page/invoice/page/invoice_page.dart';
import '../../application/home_bloc.dart';
import '../widgets/ongoing_rides_shimmer.dart';

class OnGoingRidesPage extends StatelessWidget {
  static const String routeName = '/onGoingRidesPage';
  final OnGoingRidesPageArguments arg;

  const OnGoingRidesPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => HomeBloc()
        ..add(GetDirectionEvent())
        ..add(GetOnGoingRidesEvent()),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) async {
          if (state is HomeInitialState) {
          }
          // else if (state is HomeLoadingStartState) {
          // }
          // else if (state is HomeLoadingStopState) {
          // }
          else if (state is LogoutState) {
            if (context.read<HomeBloc>().nearByVechileSubscription != null) {
              context.read<HomeBloc>().nearByVechileSubscription?.cancel();
              context.read<HomeBloc>().nearByVechileSubscription = null;
            }
            Navigator.pushNamedAndRemoveUntil(
                context, LoginPage.routeName, (route) => false);
            await AppSharedPreference.setLoginStatus(false);
          } else if (state is UserOnTripState) {
            if (context.read<HomeBloc>().nearByVechileSubscription != null) {
              context.read<HomeBloc>().nearByVechileSubscription?.cancel();
              context.read<HomeBloc>().nearByVechileSubscription = null;
            }
            Navigator.pushNamedAndRemoveUntil(
                context, BookingPage.routeName, (route) => false,
                arguments: BookingPageArguments(
                  picklat: state.tripData.pickLat,
                  picklng: state.tripData.pickLng,
                  droplat: state.tripData.dropLat,
                  droplng: state.tripData.dropLng,
                  pickupAddressList: context.read<HomeBloc>().pickupAddressList,
                  stopAddressList: context.read<HomeBloc>().stopAddressList,
                  userData: arg.userData,
                  transportType: state.tripData.transportType,
                  polyString: state.tripData.polyLine,
                  distance: (double.parse(state.tripData.totalDistance) * 1000)
                      .toString(),
                  duration: state.tripData.totalTime.toString(),
                  requestId: state.tripData.id,
                  isOutstationRide: state.tripData.isOutStation == "1",
                  mapType: arg.mapType,
                  isMyself: context.read<HomeBloc>().isMyselfSelected,
                  contactName: context.read<HomeBloc>().selectedContactName,
                  contactNumber: context.read<HomeBloc>().selectedContactMobile,
                  isBiddingRide: state.tripData.isBidRide == 1,
                  selectedServiceIndex: arg.selectedServiceIndex,
                ));
          } else if (state is UserTripSummaryState) {
            if (context.read<HomeBloc>().nearByVechileSubscription != null) {
              context.read<HomeBloc>().nearByVechileSubscription?.cancel();
              context.read<HomeBloc>().nearByVechileSubscription = null;
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
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Directionality(
              textDirection: context.read<HomeBloc>().textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: SafeArea(
                top: false,
                child: Scaffold(
                  appBar: CustomAppBar(
                    title: AppLocalizations.of(context)!.onGoingRides,
                    automaticallyImplyLeading: true,
                    titleFontSize: 18,
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(16),
                    child: context.read<HomeBloc>().isLoading
                        ? OngoingRidesShimmer(
                            size: size,
                          )
                        : (context.read<HomeBloc>().onGoingRideList.isEmpty)
                            ? Center(
                                child: MyText(
                                    text: AppLocalizations.of(context)!
                                        .noRidesFound))
                            : ListView.builder(
                                itemCount: context
                                    .read<HomeBloc>()
                                    .onGoingRideList
                                    .length,
                                padding:
                                    EdgeInsets.only(bottom: size.height * 0.08),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (_, index) {
                                  final ride = context
                                      .read<HomeBloc>()
                                      .onGoingRideList
                                      .elementAt(index);
                                  return InkWell(
                                    onTap: () {
                                      context.read<HomeBloc>().add(
                                          OnGoingRideOnTapEvent(
                                              selectedIndex: index));
                                    },
                                    child: SizedBox(
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(context)
                                                      .shadowColor,
                                                  blurRadius:
                                                      2, // Increase blur
                                                  spreadRadius:
                                                      0.5, // Spread evenly
                                                  offset: const Offset(0,
                                                      0), // Center shadow (all sides)
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    MyText(
                                                        text:
                                                            '${ride.creatededAtWithDate} ${ride.cvCreatedAt}'
                                                                .toString(),
                                                        textStyle: Theme.of(
                                                                context)
                                                            .textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                fontSize: 14,
                                                                color: Theme.of(
                                                                        context)
                                                                    .disabledColor
                                                                    .withAlpha((0.5 *
                                                                            255)
                                                                        .toInt()))),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    MyText(
                                                        text: ride.requestNumber
                                                            .toString(),
                                                        textStyle: Theme.of(
                                                                context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                    MyText(
                                                        text:
                                                            'OTP - ${ride.rideOtp}',
                                                        textStyle: Theme.of(
                                                                context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    MyText(
                                                        text: (ride.acceptedAt !=
                                                                    "" &&
                                                                ride.isDriverArrived ==
                                                                    0)
                                                            ? AppLocalizations.of(
                                                                    context)!
                                                                .accepted
                                                            : (ride.isDriverArrived ==
                                                                        1 &&
                                                                    ride.isTripStart ==
                                                                        0)
                                                                ? AppLocalizations.of(
                                                                        context)!
                                                                    .arrived
                                                                : (ride.isCompleted ==
                                                                        1)
                                                                    ? AppLocalizations.of(
                                                                            context)!
                                                                        .completed
                                                                    : AppLocalizations.of(
                                                                            context)!
                                                                        .tripStarted,
                                                        textStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: (ride.acceptedAt !=
                                                                              "" &&
                                                                          ride.isDriverArrived ==
                                                                              0)
                                                                      ? Theme.of(
                                                                              context)
                                                                          .primaryColorLight
                                                                      : (ride.isDriverArrived == 1 &&
                                                                              ride.isTripStart ==
                                                                                  0)
                                                                          ? Theme.of(context)
                                                                              .primaryColor
                                                                          : AppColors
                                                                              .green,
                                                                )),
                                                    MyText(
                                                        text: ride
                                                            .paymentTypeString
                                                            .toString(),
                                                        textStyle: Theme.of(
                                                                context)
                                                            .textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: size.width * 0.02),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    /// Route Indicator
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const SizedBox(
                                                            height: 6),
                                                        Container(
                                                          width: 12,
                                                          height: 12,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .lightGreen
                                                                .withOpacity(
                                                                    0.85),
                                                            shape:
                                                                BoxShape.circle,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: AppColors
                                                                    .lightGreen
                                                                    .withOpacity(
                                                                        0.25),
                                                                blurRadius: 6,
                                                                spreadRadius: 1,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        if (ride.dropAddress
                                                            .isNotEmpty) ...[
                                                          const SizedBox(
                                                              height: 6),
                                                          Container(
                                                            width: 1.8,
                                                            height: size.width *
                                                                0.13,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              gradient:
                                                                  LinearGradient(
                                                                begin: Alignment
                                                                    .topCenter,
                                                                end: Alignment
                                                                    .bottomCenter,
                                                                colors: [
                                                                  AppColors
                                                                      .lightGreen
                                                                      .withOpacity(
                                                                          0.8),
                                                                  Colors.grey
                                                                      .shade300
                                                                      .withOpacity(
                                                                          0.6),
                                                                  AppColors
                                                                      .errorLight
                                                                      .withOpacity(
                                                                          0.8),
                                                                ],
                                                                stops: const [
                                                                  0.0,
                                                                  0.45,
                                                                  1.0
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 6),
                                                          Icon(
                                                            Icons
                                                                .location_on_outlined,
                                                            color: AppColors
                                                                .errorLight
                                                                .withOpacity(
                                                                    0.9),
                                                            size: 20,
                                                          ),
                                                        ]
                                                      ],
                                                    ),

                                                    const SizedBox(width: 14),

                                                    /// Address
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              MyText(
                                                                text: AppLocalizations.of(
                                                                        context)!
                                                                    .pickup,
                                                                textStyle: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodySmall!
                                                                    .copyWith(
                                                                        color: AppColors
                                                                            .greyHintColor),
                                                              ),
                                                              MyText(
                                                                text: ride
                                                                    .cvTripStartTime,
                                                                textStyle: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodySmall!
                                                                    .copyWith(
                                                                        color: AppColors
                                                                            .greyHintColor,
                                                                        fontSize:
                                                                            11),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          MyText(
                                                            text: ride
                                                                .pickAddress,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        13),
                                                          ),
                                                          if (ride.dropAddress
                                                              .isNotEmpty) ...[
                                                            const SizedBox(
                                                                height: 16),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                MyText(
                                                                  text: AppLocalizations.of(
                                                                          context)!
                                                                      .drop,
                                                                  textStyle: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall!
                                                                      .copyWith(
                                                                          color:
                                                                              AppColors.greyHintColor),
                                                                ),
                                                                MyText(
                                                                  text: ride
                                                                      .cvCompletedAt,
                                                                  textStyle: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall!
                                                                      .copyWith(
                                                                          color: AppColors
                                                                              .greyHintColor,
                                                                          fontSize:
                                                                              11),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 8),
                                                            MyText(
                                                              text: ride
                                                                  .dropAddress,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textStyle: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          13),
                                                            ),
                                                          ]
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: size.height * 0.01),
                                                Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 12),
                                                  height: 1,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      begin:
                                                          Alignment.centerLeft,
                                                      end:
                                                          Alignment.centerRight,
                                                      colors: [
                                                        Colors.transparent,
                                                        Theme.of(context)
                                                            .dividerColor
                                                            .withOpacity(0.5),
                                                        Colors.transparent,
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    // Left: Vehicle Info
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              ClipOval(
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl: ride
                                                                          .driverDetail
                                                                          ?.data
                                                                          ?.profilePicture ??
                                                                      '',
                                                                  height:
                                                                      size.width *
                                                                          0.11,
                                                                  width:
                                                                      size.width *
                                                                          0.11,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      Shimmer
                                                                          .fromColors(
                                                                    baseColor: Colors
                                                                        .grey
                                                                        .shade300,
                                                                    highlightColor:
                                                                        Colors
                                                                            .grey
                                                                            .shade100,
                                                                    child:
                                                                        Container(
                                                                      height: size
                                                                              .width *
                                                                          0.11,
                                                                      width: size
                                                                              .width *
                                                                          0.11,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      Container(
                                                                    height: size
                                                                            .width *
                                                                        0.11,
                                                                    width: size
                                                                            .width *
                                                                        0.11,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: Colors
                                                                          .grey,
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .person,
                                                                      size: 25,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width:
                                                                      size.width *
                                                                          0.03),
                                                              Expanded(
                                                                child: MyText(
                                                                  text: ride
                                                                      .driverDetail
                                                                      .data
                                                                      .name,
                                                                  textStyle: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyLarge,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        MyText(
                                                          text: ride
                                                              .driverDetail
                                                              .data
                                                              .carNumber,
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                        ),
                                                        MyText(
                                                          text: ride
                                                              .driverDetail
                                                              .data
                                                              .vehicleTypeName
                                                              .toString(),
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                        ),
                                                      ],
                                                    )),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: size.width * 0.03)
                                        ],
                                      ),
                                    ),
                                  );
                                }),
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
