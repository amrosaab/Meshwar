import 'package:flutter/material.dart';

import '../../../../../../common/common.dart';
import '../../../../../../l10n/app_localizations.dart';
import 'history_trip_summary_content.dart';

class TripDriverDetailsWidget extends StatelessWidget {
  const TripDriverDetailsWidget(
      {super.key, required this.cont, required this.arg});
  final BuildContext cont;
  final TripHistoryPageArguments arg;

  @override
  Widget build(BuildContext context) {
    final history = arg.historyData;
    final l10n = AppLocalizations.of(context)!;
    final driver = history.isCancelled != 1 ? history.driverDetail?.data : null;
    final stops = history.requestStops?.data;
    return HistoryTripSummaryContent(
      driverName: driver?.name ?? '',
      driverImage: driver?.profilePicture ?? '',
      stops: [
        HistoryTripStop(
            address: history.pickAddress,
            label: l10n.pickup,
            time: history.cvTripStartTime?.toString() ?? '',
            isPickup: true),
        if (stops != null && stops.isNotEmpty)
          for (var index = 0; index < stops.length; index++)
            HistoryTripStop(
                address: stops[index].address,
                label: l10n.stop.replaceAll('111', '${index + 1}'),
                time: history.cvCompletedAt?.toString() ?? '',
                isIntermediate: true),
        if (history.dropAddress.isNotEmpty && (stops == null || stops.isEmpty))
          HistoryTripStop(
              address: history.dropAddress,
              label: l10n.drop,
              time: history.cvCompletedAt?.toString() ?? ''),
      ],
    );
  }
}
