import 'package:flutter/material.dart';

import '../../../../../../common/common.dart';
import '../../../../../../l10n/app_localizations.dart';
import 'history_fare_content.dart';

class TripFarebreakupWidget extends StatelessWidget {
  const TripFarebreakupWidget(
      {super.key, required this.cont, required this.arg});
  final BuildContext cont;
  final TripHistoryPageArguments arg;

  @override
  Widget build(BuildContext context) {
    final history = arg.historyData;
    final l10n = AppLocalizations.of(context)!;
    final showTotal = history.isCancelled != 1 &&
        (history.requestBill != null || history.isBidRide == 1);
    return HistoryFareContent(
      cancelled: history.isCancelled == 1,
      payment: switch (history.paymentOpt) {
        '1' => l10n.cash,
        '2' => l10n.wallet,
        '0' => l10n.card,
        _ => '',
      },
      total: !showTotal
          ? ''
          : history.requestBill != null
              ? '${history.requestBill.data.requestedCurrencySymbol} ${history.requestBill.data.totalAmount}'
              : '${history.requestedCurrencySymbol} ${history.acceptedRideFare}',
      lines: [
        if (history.isCancelled != 1 &&
            history.requestBill != null &&
            history.isBidRide != 1) ...[
          if (arg.historyData.requestBill.data.basePrice != 0)
            HistoryFareLine(
              "${AppLocalizations.of(context)!.basePrice} (${arg.historyData.requestBill!.data.baseDistance} ${arg.historyData.requestBill!.data.unit})",
              '${arg.historyData.requestBill.data.requestedCurrencySymbol} ${arg.historyData.requestBill.data.basePrice}',
            ),
          if (arg.historyData.requestBill.data.distancePrice != 0)
            HistoryFareLine(
              "${AppLocalizations.of(context)!.distancePrice} (${arg.historyData.requestBill!.data.requestedCurrencySymbol} ${arg.historyData.requestBill!.data.pricePerDistance} x ${arg.historyData.requestBill!.data.calculatedDistance} ${arg.historyData.requestBill!.data.unit})",
              '${arg.historyData.requestBill.data.requestedCurrencySymbol} ${arg.historyData.requestBill.data.distancePrice}',
            ),
          if (arg.historyData.requestBill.data.timePrice != 0)
            HistoryFareLine(
              "${AppLocalizations.of(context)!.timePrice} (${arg.historyData.requestBill!.data.requestedCurrencySymbol} ${arg.historyData.requestBill!.data.pricePerTime} x ${arg.historyData.requestBill!.data.totalTime})",
              '${arg.historyData.requestBill.data.requestedCurrencySymbol} ${arg.historyData.requestBill.data.timePrice}',
            ),
          if (arg.historyData.requestBill.data.waitingCharge != 0)
            HistoryFareLine(
              "${AppLocalizations.of(context)!.waitingPrice} (${arg.historyData.requestBill!.data.requestedCurrencySymbol} ${arg.historyData.requestBill!.data.waitingChargePerMin} x ${arg.historyData.requestBill!.data.calculatedWaitingTime} mins)",
              '${arg.historyData.requestBill.data.requestedCurrencySymbol} ${arg.historyData.requestBill.data.waitingCharge}',
            ),
          if (arg.historyData.requestBill.data.adminCommision != 0)
            HistoryFareLine(
              AppLocalizations.of(context)!.convenienceFee,
              '${arg.historyData.requestBill.data.requestedCurrencySymbol} ${arg.historyData.requestBill.data.adminCommision}',
            ),
          if (arg.historyData.requestBill.data.promoDiscount != 0)
            HistoryFareLine(
              AppLocalizations.of(context)!.discount,
              '-${arg.historyData.requestBill.data.requestedCurrencySymbol} ${arg.historyData.requestBill.data.promoDiscount}',
              color: AppColors.routeGreen,
            ),
          if (arg.historyData.requestBill.data.additionalChargesAmount != 0 &&
              arg.historyData.requestBill.data.additionalChargesReason != null)
            HistoryFareLine(
              AppLocalizations.of(context)!.additionalCharges,
              '${arg.historyData.requestBill.data.requestedCurrencySymbol} ${arg.historyData.requestBill.data.additionalChargesAmount}',
            ),
          if (arg.historyData.requestBill.data.cancellationFee != 0.0 &&
              arg.historyData.requestBill.data.cancellationFee != 0)
            HistoryFareLine(
              AppLocalizations.of(context)!.cancellationFee,
              '-${arg.historyData.requestBill.data.requestedCurrencySymbol} ${arg.historyData.requestBill.data.cancellationFee}',
            ),
          if (arg.historyData.requestBill.data.airportSurgeFee != 0 &&
              arg.historyData.requestBill.data.airportSurgeFee != '' &&
              arg.historyData.transportType == 'taxi' &&
              arg.historyData.isBidRide == 0)
            HistoryFareLine(
              AppLocalizations.of(context)!.airportSurgefee,
              '${arg.historyData.requestBill.data.requestedCurrencySymbol} ${arg.historyData.requestBill.data.airportSurgeFee}',
            ),
          HistoryFareLine(
            AppLocalizations.of(context)!.taxes,
            '${arg.historyData.requestBill.data.requestedCurrencySymbol} ${arg.historyData.requestBill.data.serviceTax}',
          ),
          if (arg.historyData.requestBill.data.preferencePriceTotal != 0)
            HistoryFareLine(
              AppLocalizations.of(context)!.preferenceTotal,
              '${arg.historyData.requestBill.data.requestedCurrencySymbol} ${arg.historyData.requestBill.data.preferencePriceTotal}',
            ),
        ],
      ],
    );
  }
}
