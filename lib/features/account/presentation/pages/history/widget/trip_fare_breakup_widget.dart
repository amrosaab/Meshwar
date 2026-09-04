// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';

class TripFarebreakupWidget extends StatelessWidget {
  final BuildContext cont;
  final TripHistoryPageArguments arg;
  const TripFarebreakupWidget({
    super.key,
    required this.cont,
    required this.arg,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<AccBloc>(),
      child: BlocBuilder<AccBloc, AccState>(
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.all(size.width * 0.05),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: AppColors.borderColors),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== Header =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (arg.historyData.isCancelled == 1)
                      MyText(
                        text: AppLocalizations.of(context)!.cancelled,
                        textStyle:
                            Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: AppColors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                      )
                    else if (arg.historyData.isCompleted == 1)
                      MyText(
                        text: AppLocalizations.of(context)!.fareBreakup,
                        textStyle:
                            Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                      ),
                  ],
                ),
                SizedBox(height: size.width * 0.03),

                // ===== Bid Ride Section =====
                if (arg.historyData.isBidRide == 1 &&
                    arg.historyData.isCancelled == 0)
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MyText(
                          text: (arg.historyData.paymentOpt == '1')
                              ? AppLocalizations.of(context)!.cash
                              : (arg.historyData.paymentOpt == '2')
                                  ? AppLocalizations.of(context)!.wallet
                                  : (arg.historyData.paymentOpt == '0')
                                      ? AppLocalizations.of(context)!.card
                                      : '',
                          textStyle: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(fontSize: 16),
                        ),
                        SizedBox(height: size.width * 0.02),
                        MyText(
                          text: (arg.historyData.requestBill == null)
                              ? (arg.historyData.isBidRide == 1)
                                  ? '${arg.historyData.requestedCurrencySymbol} ${arg.historyData.acceptedRideFare}'
                                  : (arg.historyData.isCompleted == 1)
                                      ? '${arg.historyData.requestBill.data.requestedCurrencySymbol} ${arg.historyData.requestBill.data.totalAmount}'
                                      : '${arg.historyData.requestedCurrencySymbol} ${arg.historyData.requestEtaAmount}'
                              : '${arg.historyData.requestBill.data.requestedCurrencySymbol} ${arg.historyData.requestBill.data.totalAmount}',
                          textStyle: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),

                // ===== Fare Details =====
                if (arg.historyData.isCancelled != 1 &&
                    arg.historyData.requestBill != null &&
                    arg.historyData.isBidRide != 1)
                  Column(
                    children: [
                      SizedBox(height: size.width * 0.03),

                      // each row builder retained, only UI spacing/fonts updated
                      if (arg.historyData.requestBill.data.basePrice != 0)
                        _buildFareRow(
                          context,
                          size,
                          "${AppLocalizations.of(context)!.basePrice} (${arg.historyData.requestBill!.data.baseDistance} ${arg.historyData.requestBill!.data.unit})",
                          '${arg.historyData.requestBill.data.requestedCurrencySymbol} ${arg.historyData.requestBill.data.basePrice}',
                        ),

                      if (arg.historyData.requestBill.data.distancePrice != 0)
                        _buildFareRow(
                          context,
                          size,
                          "${AppLocalizations.of(context)!.distancePrice} (${arg.historyData.requestBill!.data.requestedCurrencySymbol} ${arg.historyData.requestBill!.data.pricePerDistance} x ${arg.historyData.requestBill!.data.calculatedDistance} ${arg.historyData.requestBill!.data.unit})",
                          '${arg.historyData.requestBill.data.requestedCurrencySymbol} ${arg.historyData.requestBill.data.distancePrice}',
                        ),

                      if (arg.historyData.requestBill.data.timePrice != 0)
                        _buildFareRow(
                          context,
                          size,
                          "${AppLocalizations.of(context)!.timePrice} (${arg.historyData.requestBill!.data.requestedCurrencySymbol} ${arg.historyData.requestBill!.data.pricePerTime} x ${arg.historyData.requestBill!.data.totalTime})",
                          '${arg.historyData.requestBill.data.requestedCurrencySymbol} ${arg.historyData.requestBill.data.timePrice}',
                        ),

                      if (arg.historyData.requestBill.data.waitingCharge != 0)
                        _buildFareRow(
                          context,
                          size,
                          "${AppLocalizations.of(context)!.waitingPrice} (${arg.historyData.requestBill!.data.requestedCurrencySymbol} ${arg.historyData.requestBill!.data.waitingChargePerMin} x ${arg.historyData.requestBill!.data.calculatedWaitingTime} mins)",
                          '${arg.historyData.requestBill.data.requestedCurrencySymbol} ${arg.historyData.requestBill.data.waitingCharge}',
                        ),

                      if (arg.historyData.requestBill.data.adminCommision != 0)
                        _buildFareRow(
                          context,
                          size,
                          AppLocalizations.of(context)!.convenienceFee,
                          '${arg.historyData.requestBill.data.requestedCurrencySymbol} ${arg.historyData.requestBill.data.adminCommision}',
                        ),

                      if (arg.historyData.requestBill.data.promoDiscount != 0)
                        _buildFareRow(
                          context,
                          size,
                          AppLocalizations.of(context)!.discount,
                          '-${arg.historyData.requestBill.data.requestedCurrencySymbol} ${arg.historyData.requestBill.data.promoDiscount}',
                          color: Theme.of(context).primaryColorDark,
                        ),

                      if (arg.historyData.requestBill.data
                                  .additionalChargesAmount !=
                              0 &&
                          arg.historyData.requestBill.data
                                  .additionalChargesReason !=
                              null)
                        _buildFareRow(
                          context,
                          size,
                          AppLocalizations.of(context)!.additionalCharges,
                          '${arg.historyData.requestBill.data.requestedCurrencySymbol} ${arg.historyData.requestBill.data.additionalChargesAmount}',
                        ),

                      if (arg.historyData.requestBill.data.cancellationFee !=
                              0.0 &&
                          arg.historyData.requestBill.data.cancellationFee != 0)
                        _buildFareRow(
                          context,
                          size,
                          AppLocalizations.of(context)!.cancellationFee,
                          '-${arg.historyData.requestBill.data.requestedCurrencySymbol} ${arg.historyData.requestBill.data.cancellationFee}',
                        ),

                      if (arg.historyData.requestBill.data.airportSurgeFee !=
                              0 &&
                          arg.historyData.requestBill.data.airportSurgeFee !=
                              '' &&
                          arg.historyData.transportType == 'taxi' &&
                          arg.historyData.isBidRide == 0)
                        _buildFareRow(
                          context,
                          size,
                          AppLocalizations.of(context)!.airportSurgefee,
                          '${arg.historyData.requestBill.data.requestedCurrencySymbol} ${arg.historyData.requestBill.data.airportSurgeFee}',
                        ),

                      _buildFareRow(
                        context,
                        size,
                        AppLocalizations.of(context)!.taxes,
                        '${arg.historyData.requestBill.data.requestedCurrencySymbol} ${arg.historyData.requestBill.data.serviceTax}',
                      ),

                      if (arg.historyData.requestBill.data
                              .preferencePriceTotal !=
                          0)
                        _buildFareRow(
                          context,
                          size,
                          AppLocalizations.of(context)!.preferenceTotal,
                          '${arg.historyData.requestBill.data.requestedCurrencySymbol} ${arg.historyData.requestBill.data.preferencePriceTotal}',
                        ),

                      Divider(
                        height: size.width * 0.08,
                        color: AppColors.borderColors,
                        thickness: 1,
                      ),

                      // ===== Total Section =====
                      if (arg.historyData.requestBill != null &&
                          arg.historyData.isBidRide != 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyText(
                              text: AppLocalizations.of(context)!.payment,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                            ),
                            Row(
                              children: [
                                MyText(
                                  text: (arg.historyData.paymentOpt == '1')
                                      ? AppLocalizations.of(context)!.cash
                                      : (arg.historyData.paymentOpt == '2')
                                          ? AppLocalizations.of(context)!.wallet
                                          : (arg.historyData.paymentOpt == '0')
                                              ? AppLocalizations.of(context)!
                                                  .card
                                              : '',
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontSize: 16,
                                      ),
                                ),
                                SizedBox(width: size.width * 0.03),
                                MyText(
                                  text:
                                      '${arg.historyData.requestBill.data.requestedCurrencySymbol} ${arg.historyData.requestBill.data.totalAmount}',
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Theme.of(context).primaryColorDark,
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
            ),
          );
        },
      ),
    );
  }

  // Reused helper method for consistent layout (logic unchanged)
  Widget _buildFareRow(
    BuildContext context,
    Size size,
    String label,
    String value, {
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.width * 0.025),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: MyText(
              text: label,
              textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: 14,
                    color: color ?? Theme.of(context).hintColor,
                  ),
              maxLines: 2,
            ),
          ),
          MyText(
            text: value,
            textAlign: TextAlign.end,
            textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color ?? Theme.of(context).hintColor,
                ),
          ),
        ],
      ),
    );
  }
}
