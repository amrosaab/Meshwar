// ignore_for_file: deprecated_member_use

import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/app_arguments.dart';
import '../../../../common/app_colors.dart';
import '../../../../common/ride_type_label.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/presentation/pages/outstation/widget/outstation_offered_page.dart';
import '../../../account/presentation/pages/history/page/trip_summary_history.dart';
import '../../application/home_bloc.dart';

class HomeUpcomingRidesWidget extends StatelessWidget {
  final BuildContext cont;
  const HomeUpcomingRidesWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider(
                items: List.generate(
                  (context.read<HomeBloc>().upcomingRideList.length > 3
                      ? 3
                      : context.read<HomeBloc>().upcomingRideList.length),
                  (index) {
                    final ride = context
                        .read<HomeBloc>()
                        .upcomingRideList
                        .elementAt(index);
                    final rideTypeText = rideTypeLabel(context, ride);
                    final outstationTripType =
                        outstationTripTypeLabel(context, ride);
                    final rideTitle = outstationTripType.isNotEmpty
                        ? '$rideTypeText - $outstationTripType'
                        : rideTypeText;
                    final rideTitleText = rideTitle.isNotEmpty
                        ? rideTitle
                        : (ride.vehicleTypeName);
                    return InkWell(
                      onTap: () {
                        if (ride.isOutStation == 1) {
                          if (ride.isBidRide == 1 &&
                              ride.acceptedRideFare == 0) {
                            Navigator.pushNamed(
                              context,
                              OutStationOfferedPage.routeName,
                              arguments: OutStationOfferedPageArguments(
                                requestId: ride.id,
                                currencySymbol: ride.requestedCurrencySymbol,
                                dropAddress: ride.dropAddress,
                                pickAddress: ride.pickAddress,
                                updatedAt: ride.tripStartTimeWithDate,
                                offeredFare: ride.offerredRideFare.toString(),
                              ),
                            ).then((value) {
                              if (!context.mounted) return;
                              context.read<HomeBloc>().add(GetDirectionEvent());
                            });
                          } else {
                            Navigator.pushNamed(
                              context,
                              HistoryTripSummaryPage.routeName,
                              arguments: TripHistoryPageArguments(
                                historyData: ride,
                                isSupportTicketEnabled: '0',
                                pageNumber: 1,
                              ),
                            ).then((value) {
                              if (!context.mounted) return;
                              context.read<HomeBloc>().add(GetDirectionEvent());
                            });
                          }
                        } else {
                          context.read<HomeBloc>().add(
                                ChangeBottomNavIndexEvent(
                                  index: 1, // History Tab
                                  pushTripSummary: true,
                                  historyData: ride,
                                  historyIndex: index,
                                ),
                              );
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            right: 6, bottom: 6, top: 2, left: 1),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              (Theme.of(context).brightness == Brightness.dark)
                                  ? const Color.fromARGB(255, 31, 32, 32)
                                  : const Color(0xFFF8F9FC),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .shadowColor
                                  .withOpacity(0.08),
                              blurRadius: 3,
                              //spreadRadius: 0.1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: size.width * 0.01,
                                right: size.width * 0.01,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(
                                    text: (ride.laterRide == true)
                                        ? ride.tripStartTimeWithDate
                                        : ride.convertedCreatedAt,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: AppColors.greyHintColor,
                                          fontSize: 10,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: size.height * 0.015),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 42,
                                  width: 42,
                                  decoration: BoxDecoration(
                                    color: (Theme.of(context).brightness ==
                                            Brightness.dark)
                                        ? const Color.fromARGB(
                                            255, 255, 255, 255)
                                        : Theme.of(context)
                                            .scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                        color: const Color(0xffE6ECF5),
                                        width: .4),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.calendar_month_outlined,
                                      size: 20,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                SizedBox(width: size.width * 0.02),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: MyText(
                                              text: rideTitleText,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14,
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          MyText(
                                            text: (ride.isOutStation == 1 ||
                                                    ride.isBidRide == 1)
                                                ? '${ride.requestedCurrencySymbol} ${ride.acceptedRideFare.toString()}'
                                                : '${ride.requestedCurrencySymbol} ${ride.requestEtaAmount.toString()}',
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                MyText(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .pickupTime,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                        color: AppColors
                                                            .greyHintColor,
                                                        fontSize: 10,
                                                      ),
                                                ),
                                                //const SizedBox(width: 4),
                                                Flexible(
                                                  child: MyText(
                                                    text: ride.cvTripStartTime,
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                          color: AppColors
                                                              .greyHintColor,
                                                          fontSize: 10,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          MyText(
                                            text: 'EST.',
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  color:
                                                      AppColors.greyHintColor,
                                                  fontSize: 11,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                options: CarouselOptions(
                  height: size.width * 0.3,
                  // aspectRatio: 16 / 9,
                  viewportFraction: 1.0,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlay: false,
                  autoPlayInterval: const Duration(seconds: 2),
                  autoPlayAnimationDuration: const Duration(milliseconds: 300),
                  autoPlayCurve: Curves.ease,
                  enlargeCenterPage: false,
                  // enlargeFactor: 0.3,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    context.read<HomeBloc>().onGoingRideIndex = index;
                    context.read<HomeBloc>().add(UpdateEvent());
                  },
                ),
              ),
              if (context.read<HomeBloc>().upcomingRideList.length > 1) ...[
                SizedBox(height: size.width * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    (context.read<HomeBloc>().upcomingRideList.length > 3
                        ? 3
                        : context.read<HomeBloc>().upcomingRideList.length),
                    (index) {
                      final isSelected =
                          context.read<HomeBloc>().onGoingRideIndex == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        height: 6,
                        width: isSelected ? 20 : 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : AppColors.greyHeader.withOpacity(0.5),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
