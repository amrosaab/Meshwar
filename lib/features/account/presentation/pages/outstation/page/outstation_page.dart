// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../../../../../../common/liquid_glass_container.dart';
import '../../../../../../common/pickup_icon.dart';
import '../../../../../../core/utils/custom_appbar.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../home/presentation/pages/home_page.dart';
import '../../../../application/acc_bloc.dart';
import '../../../../domain/models/history_model.dart';
import '../../history/widget/history_card_shimmer.dart';
import '../widget/outstation_offered_page.dart';
import '../../history/page/trip_summary_history.dart';

class OutstationHistoryPage extends StatelessWidget {
  final OutstationHistoryPageArguments arg;
  static const String routeName = '/outstationHistory';

  const OutstationHistoryPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(HistoryGetEvent(historyFilter: 'out_station=1')),
      child: BlocBuilder<AccBloc, AccState>(
        builder: (context, state) {
          return Directionality(
            textDirection: context.read<AccBloc>().textDirection == 'rtl'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: SafeArea(
              top: false,
              bottom: false,
              child: Scaffold(
                appBar: CustomAppBar(
                  title: AppLocalizations.of(context)!.outStation,
                  automaticallyImplyLeading: true,
                  onBackTap: () {
                    if (arg.isFromBooking) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, HomePage.routeName, (route) => false);
                    } else {
                      Navigator.of(context).pop();
                    }
                    context.read<AccBloc>().scrollController.dispose();
                  },
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    controller: context.read<AccBloc>().scrollController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: size.width * 0.05),
                        if (context.read<AccBloc>().isLoading)
                          HistoryShimmer(size: size),
                        if (!context.read<AccBloc>().isLoading &&
                            context.read<AccBloc>().historyList.isEmpty)
                          SizedBox(
                            height: size.height * 0.65,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 32, vertical: size.height * 0.06),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    LiquidGlassContainer(
                                      circular: true,
                                      width: 148,
                                      height: 148,
                                      blurSigma: 14,
                                      fillOpacity: 0.1,
                                      child: Center(
                                        child: Image.asset(
                                          AppImages.noOutstation,
                                          width: 92,
                                          height: 92,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: size.width * 0.05),
                                    MyText(
                                      text: AppLocalizations.of(context)!.noHistory,
                                      textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        color: Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    MyText(
                                      text: AppLocalizations.of(context)!
                                          .noHistoryText,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                          color:
                                          Theme.of(context).disabledColor,
                                          fontSize: 16),
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SizedBox(
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                              context.read<AccBloc>().historyList.length,
                              itemBuilder: (_, index) {
                                final history = context
                                    .read<AccBloc>()
                                    .historyList
                                    .elementAt(index);
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: InkWell(
                                        onTap: () {
                                          if (history.isLater == true) {
                                            if (history.isOutStation == 1 &&
                                                history.driverDetail == null) {
                                              Navigator.pushNamed(context,
                                                  OutStationOfferedPage.routeName,
                                                  arguments:
                                                  OutStationOfferedPageArguments(
                                                    requestId: history.id,
                                                    currencySymbol: history
                                                        .requestedCurrencySymbol,
                                                    dropAddress:
                                                    history.dropAddress,
                                                    pickAddress:
                                                    history.pickAddress,
                                                    updatedAt: history
                                                        .tripStartTimeWithDate,
                                                    offeredFare: history
                                                        .offerredRideFare
                                                        .toString(),
                                                  )).then(
                                                    (value) {
                                                  if (!context.mounted) return;
                                                  context
                                                      .read<AccBloc>()
                                                      .historyList
                                                      .clear();
                                                  context.read<AccBloc>().add(
                                                      HistoryGetEvent(
                                                          historyFilter:
                                                          'out_station=1'));
                                                },
                                              );
                                            } else {
                                              Navigator.pushNamed(
                                                context,
                                                HistoryTripSummaryPage.routeName,
                                                arguments:
                                                TripHistoryPageArguments(
                                                    historyData: history,
                                                    isSupportTicketEnabled:
                                                    '0',
                                                    pageNumber: context
                                                        .read<AccBloc>()
                                                        .historyPaginations!
                                                        .pagination
                                                        .currentPage),
                                              ).then((value) {
                                                if (!context.mounted) return;
                                                context
                                                    .read<AccBloc>()
                                                    .historyList
                                                    .clear();
                                                context.read<AccBloc>().add(
                                                  HistoryGetEvent(
                                                      historyFilter:
                                                      'out_station=1'),
                                                );
                                                context
                                                    .read<AccBloc>()
                                                    .add(AccUpdateEvent());
                                              });
                                            }
                                          } else {
                                            Navigator.pushNamed(
                                              context,
                                              HistoryTripSummaryPage.routeName,
                                              arguments: TripHistoryPageArguments(
                                                  historyData: history,
                                                  isSupportTicketEnabled: '0',
                                                  pageNumber: context
                                                      .read<AccBloc>()
                                                      .historyPaginations!
                                                      .pagination
                                                      .currentPage),
                                            );
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              bottom: size.width * 0.03),
                                          child: LiquidGlassContainer(
                                            borderRadius: 16,
                                            child: Column(
                                              children: [
                                                // === Pickup & Drop Address Section ===
                                                Padding(
                                                  padding: const EdgeInsets.all(16),
                                                  child: Column(
                                                    children: [
                                                      // Pickup
                                                      Row(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Container(
                                                            margin: const EdgeInsets
                                                                .only(top: 2),
                                                            child:
                                                            const PickupIcon(),
                                                          ),
                                                          const SizedBox(width: 12),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                MyText(
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                                  maxLines: 2,
                                                                  text: history
                                                                      .pickAddress,
                                                                  textStyle: Theme.of(
                                                                      context)
                                                                      .textTheme
                                                                      .bodyMedium!
                                                                      .copyWith(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                    height: 1.4,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 4),
                                                                MyText(
                                                                  text: history
                                                                      .cvTripStartTime,
                                                                  textStyle: Theme.of(
                                                                      context)
                                                                      .textTheme
                                                                      .bodySmall!
                                                                      .copyWith(
                                                                    color: AppColors
                                                                        .greyHintColor,
                                                                    fontSize:
                                                                    12,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      if (!history.isRental &&
                                                          history.dropAddress
                                                              .isNotEmpty) ...[
                                                        const SizedBox(height: 12),
                                                        // Drop
                                                        Row(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Container(
                                                              margin:
                                                              const EdgeInsets
                                                                  .only(top: 2),
                                                              child:
                                                              const DropIcon(),
                                                            ),
                                                            const SizedBox(
                                                                width: 12),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  MyText(
                                                                    overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                    maxLines: 2,
                                                                    text: history
                                                                        .dropAddress,
                                                                    textStyle: Theme.of(
                                                                        context)
                                                                        .textTheme
                                                                        .bodyMedium!
                                                                        .copyWith(
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                      height:
                                                                      1.4,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height: 4),
                                                                  MyText(
                                                                    text: history
                                                                        .cvCompletedAt,
                                                                    textStyle: Theme.of(
                                                                        context)
                                                                        .textTheme
                                                                        .bodySmall!
                                                                        .copyWith(
                                                                      color: AppColors
                                                                          .greyHintColor,
                                                                      fontSize:
                                                                      12,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),

                                                // Divider
                                                Container(
                                                  height: 1,
                                                  color: AppColors.surfaceBorder(context),
                                                ),

                                                // === Bottom Section ===
                                                Padding(
                                                  padding: const EdgeInsets.all(16),
                                                  child: (history.isOutStation != 1)
                                                      ? _buildRegularTripDetails(
                                                      context, history, size)
                                                      : _buildOutstationTripDetails(
                                                      context, history, size),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        if (context.read<AccBloc>().loadMore)
                          Center(
                            child: SizedBox(
                                height: size.width * 0.08,
                                width: size.width * 0.08,
                                child: const CircularProgressIndicator()),
                          ),
                        SizedBox(height: size.width * 0.2),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Regular City Ride
Widget _buildRegularTripDetails(
    BuildContext context, HistoryData history, Size size) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Left: Vehicle Info
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              text: history.laterRide == true
                  ? history.tripStartTimeWithDate
                  : history.isCompleted == 1
                  ? history.convertedCompletedAt
                  : history.isCancelled == 1
                  ? history.convertedCancelledAt
                  : history.convertedCreatedAt,
              textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).disabledColor.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CachedNetworkImage(
                  imageUrl: history.vehicleTypeImage,
                  height: 48,
                  width: 48,
                  placeholder: (_, __) => const Loader(),
                  errorWidget: (_, __, ___) => Image.asset(AppImages.noImage),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: history.vehicleTypeName,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      MyText(
                        text: history.carColor,
                        textStyle:
                        Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.greyHintColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // Right: Status + Price
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (history.isCompleted == 1 ||
              history.isCancelled == 1 ||
              history.isLater == true)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: history.isCompleted == 1
                    ? AppColors.green
                    : history.isCancelled == 1
                    ? AppColors.red
                    : AppColors.secondaryDark,
                borderRadius: BorderRadius.circular(18),
              ),
              child: MyText(
                text: history.isCompleted == 1
                    ? AppLocalizations.of(context)!.completed
                    : history.isCancelled == 1
                    ? AppLocalizations.of(context)!.cancelled
                    : (history.isRental == false)
                    ? AppLocalizations.of(context)!.upcoming
                // : 'Rental ${history.rentalPackageName}',
                    : AppLocalizations.of(context)!
                    .rental
                    .replaceAll('111', history.rentalPackageName),
                textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
          const SizedBox(height: 12),
          MyText(
            text: (history.isBidRide == 1)
                ? '${history.requestedCurrencySymbol} ${history.acceptedRideFare}'
                : (history.isCompleted == 1)
                ? '${history.requestBill.data.requestedCurrencySymbol} ${history.requestBill.data.totalAmount}'
                : '${history.requestedCurrencySymbol} ${history.requestEtaAmount}',
            textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColorDark,
              fontSize: 18,
            ),
          ),
        ],
      ),
    ],
  );
}

// Outstation Ride
Widget _buildOutstationTripDetails(
    BuildContext context, HistoryData history, Size size) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Trip Type Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.yellowColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.yellowColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyText(
                  text: (history.isOutStation == 1 && history.isRoundTrip != '')
                      ? AppLocalizations.of(context)!.roundTrip
                      : AppLocalizations.of(context)!.oneWayTrip,
                  textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    color: AppColors.yellowColor,
                  ),
                ),
                if (history.isOutStation == 1 && history.isRoundTrip != '')
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(Icons.import_export,
                        size: 14, color: AppColors.yellowColor),
                  ),
              ],
            ),
          ),

          // Assignment Status Badge (if applicable)
          if (history.isOutStation == 1 &&
              history.isCancelled != 1 &&
              history.isCompleted != 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: (history.driverDetail != null)
                    ? AppColors.green.withOpacity(0.15)
                    : AppColors.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: (history.driverDetail != null)
                      ? AppColors.green.withOpacity(0.3)
                      : AppColors.red.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: MyText(
                text: (history.driverDetail != null)
                    ? AppLocalizations.of(context)!.assigned
                    : AppLocalizations.of(context)!.unAssigned,
                textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: (history.driverDetail != null)
                      ? AppColors.green
                      : AppColors.red,
                ),
              ),
            ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vehicle Info
          Expanded(
            child: Row(
              children: [
                CachedNetworkImage(
                  imageUrl: history.vehicleTypeImage,
                  height: 48,
                  width: 48,
                  placeholder: (_, __) => const Loader(),
                  errorWidget: (_, __, ___) => Image.asset(AppImages.noImage),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: history.vehicleTypeName,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      MyText(
                        text: history.carColor,
                        textStyle:
                        Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.greyHintColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Date + Payment + Price
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MyText(
                text: (history.laterRide == true)
                    ? history.tripStartTimeWithDate
                    : history.isCompleted == 1
                    ? history.convertedCompletedAt
                    : history.isCancelled == 1
                    ? history.convertedCancelledAt
                    : history.convertedCreatedAt,
                textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: AppColors.greyHintColor,
                  fontSize: 12,
                ),
              ),
              if (history.returnTime.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: MyText(
                    text: history.returnTime,
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 12),
                  ),
                ),
              const SizedBox(height: 12),

              // Final Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: MyText(
                      text: (history.paymentOpt == '1')
                          ? AppLocalizations.of(context)!.cash
                          : (history.paymentOpt == '2')
                          ? AppLocalizations.of(context)!.wallet
                          : AppLocalizations.of(context)!.card,
                      textStyle:
                      Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                  MyText(
                    text: (history.isOutStation == 1)
                        ? '${history.requestedCurrencySymbol} ${history.offerredRideFare}'
                        : (history.isBidRide == 1)
                        ? '${history.requestedCurrencySymbol} ${history.acceptedRideFare}'
                        : (history.isCompleted == 1)
                        ? '${history.requestBill.data.requestedCurrencySymbol} ${history.requestBill.data.totalAmount}'
                        : '${history.requestedCurrencySymbol} ${history.requestEtaAmount}',
                    textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}//