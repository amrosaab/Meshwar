import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../common/common.dart';
import '../../../../../../../core/utils/custom_button.dart';
import '../../../../../../../core/utils/custom_loader.dart';
import '../../../../../../../core/utils/custom_text.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../application/booking_bloc.dart';
import '../custom_timer.dart';

class BiddingWaitingForDriverConfirmation extends StatelessWidget {
  final double maximumTime;
  final bool isOutstationRide;
  const BiddingWaitingForDriverConfirmation(
      {super.key, required this.maximumTime, required this.isOutstationRide});

  bool _isDecreaseDisabled(BuildContext context) {
    final bloc = context.read<BookingBloc>();
    final double baseAmount = double.parse(bloc.requestData != null
        ? bloc.requestData!.requestEtaAmount
        : bloc.isMultiTypeVechiles
            ? bloc.sortedEtaDetailsList[bloc.selectedVehicleIndex].total
                .toString()
            : bloc.etaDetailsList[bloc.selectedVehicleIndex].total.toString());
    final String lowPct = bloc.requestData != null
        ? bloc.requestData!.biddingLowPercentage
        : (bloc.isMultiTypeVechiles
            ? bloc.sortedEtaDetailsList[bloc.selectedVehicleIndex]
                .biddingLowPercentage
            : bloc.etaDetailsList[bloc.selectedVehicleIndex]
                .biddingLowPercentage);
    final double minAllowed = (lowPct == '0')
        ? 0.0
        : baseAmount - ((double.parse(lowPct) / 100) * baseAmount);
    final double currentFare =
        double.tryParse(bloc.farePriceController.text) ?? baseAmount;
    return currentFare <= minAllowed;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        final timerDuration = context.read<BookingBloc>().timerDuration;
        return Container(
          width: size.width,
          padding: EdgeInsets.only(
              top: 12,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor,
                blurRadius: 4,
                spreadRadius: 0.5,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: context.read<BookingBloc>().biddingDriverList.isEmpty
              ? SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Modern drag handle indicator
                      Center(
                        child: Container(
                          width: size.width * 0.1,
                          height: size.width * 0.01,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .disabledColor
                                .withAlpha((0.3 * 255).toInt()),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      SizedBox(height: size.width * 0.04),

                      // Modern timer progress with gradient
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).shadowColor,
                              blurRadius: 4,
                              spreadRadius: 0.5,
                              offset: const Offset(0, 0),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.search_rounded,
                                        color: AppColors.white,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    MyText(
                                      text: AppLocalizations.of(context)!
                                          .lookingNearbyDrivers,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: size.width * 0.04),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: timerDuration / maximumTime,
                                minHeight: 8,
                                backgroundColor: isDarkMode
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .primaryColor
                              .withAlpha((0.1 * 255).toInt()),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 14,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 4),
                            MyText(
                              text:
                                  '${Duration(seconds: timerDuration).toString().substring(3, 7)} ${AppLocalizations.of(context)!.mins}',
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: size.width * 0.04),

                      // Offered fare info card
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).shadowColor,
                              blurRadius: 4,
                              spreadRadius: 0.5,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.local_offer_outlined,
                              size: 16,
                              color: Theme.of(context).disabledColor,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: MyText(
                                text:
                                    '${AppLocalizations.of(context)!.offeredRideFare.replaceAll('***', ':')} ${context.read<BookingBloc>().userData!.currencySymbol} ${context.read<BookingBloc>().farePriceController.text.isNotEmpty ? context.read<BookingBloc>().farePriceController.text : (context.read<BookingBloc>().requestData != null) ? context.read<BookingBloc>().requestData!.offerredRideFare : ''}',
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context).disabledColor),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: size.width * 0.04),

                      // Current fare label
                      MyText(
                        text: AppLocalizations.of(context)!.currentFare,
                        textStyle:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                      ),

                      SizedBox(height: size.width * 0.03),

                      // Price adjustment buttons with modern styling
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).shadowColor,
                              blurRadius: 4,
                              spreadRadius: 0.5,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Decrease button
                            _buildPriceButton(
                              context: context,
                              size: size,
                              icon: Icons.remove_rounded,
                              label:
                                  '-${double.parse(context.read<BookingBloc>().userData!.biddingAmountIncreaseOrDecrease.toString())}',
                              isDisabled: _isDecreaseDisabled(context),
                              isDecrease: true,
                              onTap: () {
                                if (!_isDecreaseDisabled(context)) {
                                  context.read<BookingBloc>().add(
                                      BiddingIncreaseOrDecreaseEvent(
                                          isIncrease: false,
                                          isOutStation: isOutstationRide));
                                }
                              },
                            ),

                            // Price input field
                            Container(
                              width: size.width * 0.35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).shadowColor,
                                    blurRadius: 4,
                                    spreadRadius: 0.5,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: TextField(
                                enabled: true,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                controller: context
                                    .read<BookingBloc>()
                                    .farePriceController,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    double typedFare =
                                        double.tryParse(value) ?? 0.0;
                                    double minFare = double.parse(context
                                                .read<BookingBloc>()
                                                .requestData !=
                                            null
                                        ? context
                                            .read<BookingBloc>()
                                            .requestData!
                                            .requestEtaAmount
                                        : context
                                                .read<BookingBloc>()
                                                .isMultiTypeVechiles
                                            ? context
                                                .read<BookingBloc>()
                                                .sortedEtaDetailsList[context
                                                    .read<BookingBloc>()
                                                    .selectedVehicleIndex]
                                                .total
                                                .toString()
                                            : context
                                                .read<BookingBloc>()
                                                .etaDetailsList[context
                                                    .read<BookingBloc>()
                                                    .selectedVehicleIndex]
                                                .total
                                                .toString());

                                    double maxFare = minFare +
                                        (minFare *
                                            (double.parse(context
                                                            .read<BookingBloc>()
                                                            .requestData !=
                                                        null
                                                    ? context
                                                        .read<BookingBloc>()
                                                        .requestData!
                                                        .biddingHighPercentage
                                                    : context
                                                            .read<BookingBloc>()
                                                            .isMultiTypeVechiles
                                                        ? context
                                                            .read<BookingBloc>()
                                                            .sortedEtaDetailsList[context
                                                                .read<
                                                                    BookingBloc>()
                                                                .selectedVehicleIndex]
                                                            .biddingHighPercentage
                                                        : context
                                                            .read<BookingBloc>()
                                                            .etaDetailsList[context
                                                                .read<
                                                                    BookingBloc>()
                                                                .selectedVehicleIndex]
                                                            .biddingHighPercentage) /
                                                100));

                                    if (typedFare < minFare) {
                                      context
                                          .read<BookingBloc>()
                                          .isBiddingDecreaseLimitReach = true;
                                      context
                                          .read<BookingBloc>()
                                          .isBiddingIncreaseLimitReach = false;
                                    } else if (typedFare > maxFare) {
                                      context
                                          .read<BookingBloc>()
                                          .isBiddingIncreaseLimitReach = true;
                                      context
                                          .read<BookingBloc>()
                                          .isBiddingDecreaseLimitReach = false;
                                    } else {
                                      context
                                          .read<BookingBloc>()
                                          .isBiddingIncreaseLimitReach = false;
                                      context
                                          .read<BookingBloc>()
                                          .isBiddingDecreaseLimitReach = false;
                                    }
                                  }
                                },
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 30),
                                  prefixText:
                                      '${context.read<BookingBloc>().userData!.currencySymbol} ',
                                  prefixStyle: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                  hintText:
                                      context.read<BookingBloc>().requestData !=
                                              null
                                          ? context
                                              .read<BookingBloc>()
                                              .requestData!
                                              .offerredRideFare
                                          : '',
                                ),
                              ),
                            ),

                            // Increase button
                            _buildPriceButton(
                              context: context,
                              size: size,
                              icon: Icons.add_rounded,
                              label:
                                  '+${double.parse(context.read<BookingBloc>().userData!.biddingAmountIncreaseOrDecrease.toString())}',
                              isDisabled: context
                                  .read<BookingBloc>()
                                  .isBiddingIncreaseLimitReach,
                              isDecrease: false,
                              onTap: () {
                                if (!context
                                    .read<BookingBloc>()
                                    .isBiddingIncreaseLimitReach) {
                                  context.read<BookingBloc>().add(
                                      BiddingIncreaseOrDecreaseEvent(
                                          isIncrease: true,
                                          isOutStation: isOutstationRide));
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: size.width * 0.05),

                      // Action buttons with modern styling
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.5,
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isDismissible: true,
                                    isScrollControlled: true,
                                    enableDrag: false,
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20.0),
                                      ),
                                    ),
                                    builder: (_) {
                                      return BlocProvider.value(
                                          value: context.read<BookingBloc>(),
                                          child: SafeArea(
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Center(
                                                      child: Image.asset(
                                                          AppImages.cancelGif,
                                                          height: size.width *
                                                              0.2)),
                                                  Center(
                                                    child: MyText(
                                                      text: AppLocalizations.of(
                                                              context)!
                                                          .cancelRide,
                                                      textStyle: Theme.of(
                                                              context)
                                                          .textTheme
                                                          .displayLarge!
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColorDark),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          size.width * 0.05),
                                                  Center(
                                                    child: MyText(
                                                      text: AppLocalizations.of(
                                                              context)!
                                                          .cancelRideText,
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .titleLarge,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          size.width * 0.05),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      CustomButton(
                                                        buttonName:
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .cancelRide,
                                                        borderRadius: 5,
                                                        width: size.width * 0.4,
                                                        height:
                                                            size.width * 0.1,
                                                        isBorder: true,
                                                        buttonColor: Theme.of(
                                                                context)
                                                            .scaffoldBackgroundColor,
                                                        textSize: context
                                                                    .read<
                                                                        BookingBloc>()
                                                                    .languageCode ==
                                                                'fr'
                                                            ? 14
                                                            : null,
                                                        textColor:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                        onTap: () {
                                                          context
                                                              .read<
                                                                  BookingBloc>()
                                                              .timerCount(
                                                                  context,
                                                                  isNormalRide:
                                                                      false,
                                                                  isCloseTimer:
                                                                      true,
                                                                  duration: 0);
                                                          context
                                                              .read<
                                                                  BookingBloc>()
                                                              .add(
                                                                BookingCancelRequestEvent(
                                                                    requestId: context
                                                                        .read<
                                                                            BookingBloc>()
                                                                        .requestData!
                                                                        .id),
                                                              );
                                                        },
                                                      ),
                                                      CustomButton(
                                                        buttonName:
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .back,
                                                        borderRadius: 5,
                                                        width: size.width * 0.4,
                                                        height:
                                                            size.width * 0.1,
                                                        buttonColor:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                        textColor:
                                                            AppColors.white,
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: size.width * 0.1),
                                                ],
                                              ),
                                            ),
                                          ));
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.close_rounded,
                                      color: Theme.of(context).primaryColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppLocalizations.of(context)!.cancel,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).primaryColor,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).primaryColor,
                                    Theme.of(context)
                                        .primaryColor
                                        .withAlpha((0.8 * 255).toInt()),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withAlpha((0.3 * 255).toInt()),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: context.read<BookingBloc>().isLoading
                                    ? null
                                    : () {
                                        final currencySymbol = context
                                                .read<BookingBloc>()
                                                .isMultiTypeVechiles
                                            ? context
                                                .read<BookingBloc>()
                                                .sortedEtaDetailsList[context
                                                    .read<BookingBloc>()
                                                    .selectedVehicleIndex]
                                                .currency
                                            : context
                                                .read<BookingBloc>()
                                                .etaDetailsList[context
                                                    .read<BookingBloc>()
                                                    .selectedVehicleIndex]
                                                .currency;
                                        final total = double.parse(context
                                                .read<BookingBloc>()
                                                .isMultiTypeVechiles
                                            ? context
                                                .read<BookingBloc>()
                                                .sortedEtaDetailsList[context
                                                    .read<BookingBloc>()
                                                    .selectedVehicleIndex]
                                                .total
                                                .toString()
                                            : context
                                                .read<BookingBloc>()
                                                .etaDetailsList[context
                                                    .read<BookingBloc>()
                                                    .selectedVehicleIndex]
                                                .total
                                                .toString());

                                        final lowPercentage = double.parse(
                                            context
                                                    .read<BookingBloc>()
                                                    .isMultiTypeVechiles
                                                ? context
                                                    .read<BookingBloc>()
                                                    .sortedEtaDetailsList[context
                                                        .read<BookingBloc>()
                                                        .selectedVehicleIndex]
                                                    .biddingLowPercentage
                                                : context
                                                    .read<BookingBloc>()
                                                    .etaDetailsList[context
                                                        .read<BookingBloc>()
                                                        .selectedVehicleIndex]
                                                    .biddingLowPercentage);
                                        final highPercentage = double.parse(
                                            context
                                                    .read<BookingBloc>()
                                                    .isMultiTypeVechiles
                                                ? context
                                                    .read<BookingBloc>()
                                                    .sortedEtaDetailsList[context
                                                        .read<BookingBloc>()
                                                        .selectedVehicleIndex]
                                                    .biddingHighPercentage
                                                : context
                                                    .read<BookingBloc>()
                                                    .etaDetailsList[context
                                                        .read<BookingBloc>()
                                                        .selectedVehicleIndex]
                                                    .biddingHighPercentage);

                                        double roundToTwoDecimals(
                                            double number) {
                                          return double.parse(
                                              number.toStringAsFixed(2));
                                        }

                                        final value = roundToTwoDecimals(total -
                                            ((lowPercentage / 100) * total));

                                        final highValue = roundToTwoDecimals(
                                            total +
                                                ((highPercentage / 100) *
                                                    total));

                                        final fare = roundToTwoDecimals(
                                            double.tryParse(context
                                                    .read<BookingBloc>()
                                                    .farePriceController
                                                    .text
                                                    .trim()) ??
                                                0.0);

                                        if (fare >= value) {
                                          if ((!context
                                                  .read<BookingBloc>()
                                                  .isBiddingIncreaseLimitReach) ||
                                              (context
                                                      .read<BookingBloc>()
                                                      .isBiddingIncreaseLimitReach &&
                                                  fare >= value &&
                                                  fare <= highValue)) {
                                            context
                                                .read<BookingBloc>()
                                                .add(BiddingFareUpdateEvent());
                                          } else {
                                            showModalBottomSheet(
                                              context: context,
                                              isDismissible: true,
                                              isScrollControlled: true,
                                              enableDrag: false,
                                              elevation: 0,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(20.0),
                                                ),
                                              ),
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              builder: (_) {
                                                return BlocProvider.value(
                                                  value: context
                                                      .read<BookingBloc>(),
                                                  child: SafeArea(
                                                    child: Container(
                                                      width: size.width,
                                                      decoration:
                                                          const BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        topRight:
                                                            Radius.circular(20),
                                                      )),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            SizedBox(
                                                                height:
                                                                    size.width *
                                                                        0.1),
                                                            MyText(
                                                              text:
                                                                  '${AppLocalizations.of(context)!.maximumRideFareError} ($currencySymbol ${highValue.toStringAsFixed(2)})',
                                                              maxLines: 3,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              textStyle: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .copyWith(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .error),
                                                            ),
                                                            SizedBox(
                                                                height:
                                                                    size.width *
                                                                        0.1),
                                                            CustomButton(
                                                              width: size.width,
                                                              buttonName:
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .okText,
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        } else {
                                          showModalBottomSheet(
                                            context: context,
                                            isDismissible: true,
                                            isScrollControlled: true,
                                            enableDrag: false,
                                            elevation: 0,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(20.0),
                                              ),
                                            ),
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            builder: (_) {
                                              return BlocProvider.value(
                                                value:
                                                    context.read<BookingBloc>(),
                                                child: SafeArea(
                                                  child: Container(
                                                    width: size.width,
                                                    decoration:
                                                        const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20),
                                                    )),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          SizedBox(
                                                              height:
                                                                  size.width *
                                                                      0.1),
                                                          MyText(
                                                            text:
                                                                '${AppLocalizations.of(context)!.minimumRideFareError} ($currencySymbol ${value.toStringAsFixed(2)})',
                                                            maxLines: 3,
                                                            textAlign: TextAlign
                                                                .center,
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .copyWith(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .error),
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  size.width *
                                                                      0.1),
                                                          CustomButton(
                                                            width: size.width,
                                                            buttonName:
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .okText,
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: context.read<BookingBloc>().isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: AppColors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.check_circle_outline_rounded,
                                            color: AppColors.white,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .update,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.white,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.width * 0.05),
                    ],
                  ),
                )
              : Container(
                  height: size.height * 0.7,
                  decoration: BoxDecoration(
                    color:
                        isDarkMode ? Colors.grey.shade900 : Colors.grey.shade50,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: size.width * 0.04),
                      // Modern header with icon
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withAlpha((0.1 * 255).toInt()),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.people_rounded,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            MyText(
                              text: AppLocalizations.of(context)!
                                  .availableDrivers,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: Theme.of(context).primaryColorDark,
                                      fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.width * 0.02),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          shrinkWrap: true,
                          itemCount: context
                              .read<BookingBloc>()
                              .biddingDriverList
                              .length,
                          itemBuilder: (context, index) {
                            final driver = context
                                .read<BookingBloc>()
                                .biddingDriverList
                                .elementAt(index);
                            int val = DateTime.now()
                                .difference(DateTime.fromMillisecondsSinceEpoch(
                                    driver['bid_time']))
                                .inSeconds;
                            if (int.parse(val.toString()) >=
                                int.parse(context
                                        .read<BookingBloc>()
                                        .userData!
                                        .maximumTimeForFindDriversForBittingRide) +
                                    1) {
                              FirebaseDatabase.instance
                                  .ref()
                                  .child(
                                      'bid-meta/${context.read<BookingBloc>().requestData!.id}/drivers/driver_${driver["driver_id"]}')
                                  .update({"is_rejected": 'by_user'});
                              context.read<BookingBloc>().add(UpdateEvent());
                            }
                            return Container(
                              width: size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).shadowColor,
                                    blurRadius: 4,
                                    spreadRadius: 0.5,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Driver avatar with border
                                        Container(
                                          width: size.width * 0.15,
                                          height: size.width * 0.15,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 2,
                                            ),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: driver['driver_img'],
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                const Center(
                                              child: Loader(),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Center(
                                              child:
                                                  Icon(Icons.person, size: 20),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: size.width * 0.04),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: size.width * 0.3,
                                                    child: MyText(
                                                      text:
                                                          driver['driver_name'],
                                                      maxLines: 2,
                                                      textStyle: Theme.of(
                                                              context)
                                                          .textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                  height: size.width * 0.01),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .directions_car_rounded,
                                                    size: 14,
                                                    color: Theme.of(context)
                                                        .disabledColor,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: MyText(
                                                      text:
                                                          '${driver['vehicle_make']} ${driver['vehicle_model']}',
                                                      maxLines: 1,
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium!
                                                              .copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .disabledColor,
                                                              ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                  height: size.width * 0.01),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .confirmation_number_rounded,
                                                    size: 14,
                                                    color: Theme.of(context)
                                                        .disabledColor,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  MyText(
                                                    text:
                                                        '${driver['vehicle_number']}',
                                                    maxLines: 1,
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Timer badge
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            CustomPaint(
                                              painter: CustomTimer(
                                                width: size.width * 0.01,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .disabledColor,
                                                values: (DateTime.now()
                                                            .difference(
                                                                DateTime.fromMillisecondsSinceEpoch(driver[
                                                                    'bid_time']))
                                                            .inSeconds <
                                                        int.parse(context
                                                            .read<BookingBloc>()
                                                            .userData!
                                                            .maximumTimeForFindDriversForBittingRide))
                                                    ? 1 -
                                                        (((int.parse(context.read<BookingBloc>().userData!.maximumTimeForFindDriversForBittingRide) + 2) -
                                                                DateTime.now()
                                                                    .difference(DateTime.fromMillisecondsSinceEpoch(driver[
                                                                        'bid_time']))
                                                                    .inSeconds) /
                                                            int.parse(context
                                                                .read<BookingBloc>()
                                                                .userData!
                                                                .maximumTimeForFindDriversForBittingRide))
                                                    : 1,
                                              ),
                                              child: Container(
                                                height: size.width * 0.10,
                                                width: size.width * 0.10,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: MyText(
                                                text:
                                                    '${(int.parse(context.read<BookingBloc>().userData!.maximumTimeForFindDriversForBittingRide) - int.parse(DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(driver['bid_time'])).inSeconds.toString()))}',
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: (Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.light)
                                                          ? AppColors.black
                                                          : AppColors.white,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withAlpha((0.1 * 255).toInt()),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.star_rounded,
                                                size: 14,
                                                color: AppColors.goldenColor,
                                              ),
                                              const SizedBox(width: 2),
                                              MyText(
                                                text: driver['rating'],
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .primaryColorDark,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width * 0.05,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 4),
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              MyText(
                                                text: context
                                                        .read<BookingBloc>()
                                                        .userData!
                                                        .currencySymbol +
                                                    driver['price'],
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      color: AppColors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.width * 0.04),
                                    // Price and Action buttons row
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.325,
                                          height: 44,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              context.read<BookingBloc>().add(
                                                  BiddingAcceptOrDeclineEvent(
                                                      isAccept: false,
                                                      driver: driver));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isDarkMode
                                                  ? Colors.grey.shade700
                                                  : Colors.grey.shade100,
                                              foregroundColor: Theme.of(context)
                                                  .primaryColor,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .reject,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: size.width * 0.02),
                                        SizedBox(
                                          width: size.width * 0.325,
                                          height: 44,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              context.read<BookingBloc>().add(
                                                  BiddingAcceptOrDeclineEvent(
                                                      isAccept: true,
                                                      driver: driver));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              foregroundColor: AppColors.white,
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .accept,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: size.width * 0.03);
                          },
                        ),
                      ),
                      SizedBox(height: size.width * 0.04),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildPriceButton({
    required BuildContext context,
    required Size size,
    required IconData icon,
    required String label,
    required bool isDisabled,
    required bool isDecrease,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final buttonColor = isDisabled
        ? Theme.of(context).disabledColor.withAlpha((0.15 * 255).toInt())
        : isDecrease
            ? AppColors.red
            : AppColors.green;

    return InkWell(
      onTap: isDisabled ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: size.width * 0.14,
        padding: const EdgeInsets.symmetric(vertical: 6),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDisabled
              ? (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200)
              : buttonColor.withAlpha((0.1 * 255).toInt()),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDisabled
                ? Colors.transparent
                : buttonColor.withAlpha((0.3 * 255).toInt()),
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isDisabled
                  ? (isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400)
                  : buttonColor,
              size: 16,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: isDisabled
                        ? (isDarkMode
                            ? Colors.grey.shade600
                            : Colors.grey.shade400)
                        : buttonColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
