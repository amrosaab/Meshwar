import 'package:flutter/material.dart';

import '../../../../../../common/app_colors.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../domain/models/history_model.dart';
import '../../../widgets/account_content.dart';
import '../../history/widget/history_ride_card.dart';

class OutstationHistoryCard extends StatelessWidget {
  const OutstationHistoryCard({super.key, required this.history});
  final HistoryData history;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final completed = history.isCompleted == 1;
    final cancelled = history.isCancelled == 1;
    final assigned = history.driverDetail != null;
    final payment = history.paymentOpt == '1'
        ? l10n.cash
        : history.paymentOpt == '2'
            ? l10n.wallet
            : l10n.card;
    return HistoryRideCard(
      date: (history.laterRide
              ? history.tripStartTimeWithDate
              : completed
                  ? history.convertedCompletedAt
                  : cancelled
                      ? history.convertedCancelledAt
                      : history.convertedCreatedAt)
          .toString(),
      fare: history.isOutStation == 1
          ? '${history.requestedCurrencySymbol} ${history.offerredRideFare}'
          : history.isBidRide == 1
              ? '${history.requestedCurrencySymbol} ${history.acceptedRideFare}'
              : completed
                  ? '${history.requestBill.data.requestedCurrencySymbol} ${history.requestBill.data.totalAmount}'
                  : '${history.requestedCurrencySymbol} ${history.requestEtaAmount}',
      pickup: history.pickAddress,
      drop: history.dropAddress,
      pickupTime: history.cvTripStartTime.toString(),
      dropTime: history.cvCompletedAt.toString(),
      returnTime: history.returnTime.toString(),
      vehicle: history.vehicleTypeName,
      carColor: history.carColor,
      vehicleIcon: history.transportType == 'delivery'
          ? Icons.local_shipping_rounded
          : Icons.directions_car_rounded,
      tripType: history.isOutStation == 1
          ? (history.isRoundTrip.toString() == '1'
              ? l10n.roundTrip
              : l10n.oneWayTrip)
          : '',
      status: completed
          ? HistoryRideStatus.completed
          : cancelled
              ? HistoryRideStatus.cancelled
              : history.isLater
                  ? HistoryRideStatus.upcoming
                  : null,
      statusLabel: completed
          ? l10n.completed
          : cancelled
              ? l10n.cancelled
              : l10n.upcoming,
      footer: Wrap(spacing: 8, runSpacing: 8, children: [
        _Badge(
            label: payment,
            icon: history.paymentOpt == '1'
                ? Icons.payments_outlined
                : history.paymentOpt == '2'
                    ? Icons.account_balance_wallet_outlined
                    : Icons.credit_card_rounded),
        if (history.isOutStation == 1 && !completed && !cancelled)
          _Badge(
              label: assigned ? l10n.assigned : l10n.unAssigned,
              icon: assigned
                  ? Icons.check_circle_outline_rounded
                  : Icons.person_search_outlined,
              color: assigned ? AppColors.routeGreen : AppColors.meshwarRed),
      ]),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.icon, this.color});
  final String label;
  final IconData icon;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ink = color == null
        ? AccountStyle.muted(context)
        : dark
            ? (color == AppColors.routeGreen
                ? const Color(0xFF73D9AC)
                : const Color(0xFFFF82A6))
            : color!;
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
            color: ink.withValues(alpha: .08),
            borderRadius: BorderRadius.circular(12)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          ExcludeSemantics(child: Icon(icon, size: 16, color: ink)),
          const SizedBox(width: 6),
          Flexible(
              child: Text(label,
                  style: AccountStyle.text(context).copyWith(
                      color: ink, fontSize: 12, fontWeight: FontWeight.w600))),
        ]));
  }
}
