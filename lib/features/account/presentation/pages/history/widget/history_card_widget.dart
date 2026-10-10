import 'package:flutter/material.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../domain/models/history_model.dart';
import 'history_ride_card.dart';

class HistoryCardWidget extends StatelessWidget {
  const HistoryCardWidget({
    super.key,
    required this.cont,
    required this.history,
  });

  final BuildContext cont;
  final HistoryData history;

  String _label(dynamic value) => value?.toString() ?? '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final status = history.isCompleted == 1
        ? HistoryRideStatus.completed
        : history.isCancelled == 1
            ? HistoryRideStatus.cancelled
            : history.isLater
                ? HistoryRideStatus.upcoming
                : null;
    final statusLabel = switch (status) {
      HistoryRideStatus.completed => l10n.completed,
      HistoryRideStatus.cancelled => l10n.cancelled,
      HistoryRideStatus.upcoming => history.isRental
          ? l10n.rental.replaceAll('111', history.rentalPackageName)
          : l10n.upcoming,
      null => '',
    };
    return HistoryRideCard(
      date: _label(history.laterRide
          ? history.tripStartTimeWithDate
          : history.isCompleted == 1
              ? history.convertedCompletedAt
              : history.isCancelled == 1
                  ? history.convertedCancelledAt
                  : history.convertedCreatedAt),
      fare: history.isBidRide == 1
          ? '${history.requestedCurrencySymbol} ${history.acceptedRideFare}'
          : history.isCompleted == 1
              ? '${history.requestBill.data.requestedCurrencySymbol} ${history.requestBill.data.totalAmount}'
              : '${history.requestedCurrencySymbol} ${history.requestEtaAmount}',
      pickup: history.pickAddress,
      drop: history.dropAddress,
      pickupTime: _label(history.cvTripStartTime),
      dropTime: _label(history.cvCompletedAt),
      returnTime: _label(history.returnTime),
      vehicle: history.vehicleTypeName,
      carColor: history.carColor,
      vehicleIcon: history.transportType == 'delivery'
          ? Icons.local_shipping_rounded
          : Icons.directions_car_rounded,
      status: status,
      statusLabel: statusLabel,
      tripType: history.isOutStation != 1
          ? ''
          : history.isRoundTrip == 1
              ? l10n.roundTrip
              : l10n.oneWayTrip,
    );
  }
}
