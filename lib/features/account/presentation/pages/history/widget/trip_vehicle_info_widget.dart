import 'package:flutter/material.dart';

import '../../../../../../common/common.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';
import 'history_detail_widgets.dart';

class TripVehicleInfoWidget extends StatelessWidget {
  const TripVehicleInfoWidget(
      {super.key, required this.cont, required this.arg});
  final BuildContext cont;
  final TripHistoryPageArguments arg;

  @override
  Widget build(BuildContext context) {
    final history = arg.historyData;
    final l10n = AppLocalizations.of(context)!;
    final rideType = (arg.historyData.isOutStation == 0 &&
            arg.historyData.isRental == false &&
            arg.historyData.goodsType == '-')
        ? AppLocalizations.of(context)!.regular
        : (arg.historyData.isOutStation == 0 &&
                arg.historyData.isRental == false &&
                arg.historyData.goodsType != '-')
            ? AppLocalizations.of(context)!.delivery
            : (arg.historyData.isOutStation == 0 &&
                    arg.historyData.isRental == true &&
                    arg.historyData.goodsType == '-')
                ? AppLocalizations.of(context)!
                    .rental
                    .replaceAll('111', arg.historyData.rentalPackageName)
                : (arg.historyData.isOutStation == 0 &&
                        arg.historyData.isRental == true &&
                        arg.historyData.goodsType != '-')
                    ? '${AppLocalizations.of(context)!.deliveryRental} - ${arg.historyData.rentalPackageName}'
                    : (arg.historyData.isOutStation == 1 &&
                            arg.historyData.isRental == false &&
                            arg.historyData.goodsType == '-')
                        ? AppLocalizations.of(context)!.outStation
                        : (arg.historyData.isOutStation == 1 &&
                                arg.historyData.isRental == false &&
                                arg.historyData.goodsType != '-')
                            ? AppLocalizations.of(context)!.deliveryOutStation
                            : '';
    final date = history.laterRide && history.isOutStation == 1
        ? history.tripStartTime
        : history.laterRide
            ? history.tripStartTimeWithDate
            : history.isCompleted == 1
                ? history.convertedCompletedAt
                : history.isCancelled == 1
                    ? history.convertedCancelledAt
                    : history.convertedCreatedAt;
    return HistoryDetailCard(
      title: history.vehicleTypeName,
      icon: history.transportType == 'delivery'
          ? Icons.local_shipping_rounded
          : Icons.directions_car_rounded,
      gradient: RideVisuals.blue,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        HistoryDetailRow(label: l10n.typeofRide, value: rideType),
        if (history.isOutStation == 1)
          Text(history.isRoundTrip == 1 ? l10n.roundTrip : l10n.oneWayTrip,
              style: HistoryDetailStyle.text(context).copyWith(
                  color: HistoryDetailStyle.muted(context), fontSize: 12)),
        const SizedBox(height: 6),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const ExcludeSemantics(
              child: Icon(Icons.calendar_today_rounded,
                  color: Color(0xFFE6862A), size: 16)),
          const SizedBox(width: 8),
          Expanded(
              child: Text(date?.toString() ?? '',
                  style: HistoryDetailStyle.text(context).copyWith(
                      fontSize: 12, color: HistoryDetailStyle.muted(context)))),
        ]),
        if (history.isCompleted == 1) ...[
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Divider(
                  height: 1, color: HistoryDetailStyle.border(context))),
          HistoryDetailRow(
              label: l10n.duration, value: '${history.totalTime} ${l10n.mins}'),
          HistoryDetailRow(
              label: l10n.distance,
              value: '${history.totalDistance} ${history.unit}'),
          HistoryDetailRow(label: l10n.colorText, value: history.carColor),
        ],
      ]),
    );
  }
}
