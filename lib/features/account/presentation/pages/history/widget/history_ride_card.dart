import 'package:flutter/material.dart';

import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';

enum HistoryRideStatus { completed, upcoming, cancelled }

class HistoryRideCard extends StatelessWidget {
  const HistoryRideCard({
    super.key,
    required this.date,
    required this.fare,
    required this.pickup,
    required this.drop,
    required this.vehicle,
    this.pickupTime = '',
    this.dropTime = '',
    this.carColor = '',
    this.vehicleIcon = Icons.directions_car_rounded,
    this.returnTime = '',
    this.tripType = '',
    this.status,
    this.statusLabel = '',
    this.footer,
  });

  final String date, fare, pickup, drop, pickupTime, dropTime;
  final String vehicle, carColor, returnTime, tripType, statusLabel;
  final IconData vehicleIcon;
  final HistoryRideStatus? status;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ink = dark ? const Color(0xFFF8F5F7) : const Color(0xFF201B25);
    final muted = dark ? const Color(0xFFBAADB9) : const Color(0xFF79717C);
    final border = dark ? const Color(0xFF382B3B) : const Color(0xFFECE9EE);
    final base = Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontSize: 14, height: 1.4, color: ink, fontWeight: FontWeight.w500);
    final l10n = AppLocalizations.of(context)!;
    final expandedText = MediaQuery.textScalerOf(context).scale(14) > 20;

    return Ink(
      decoration: BoxDecoration(
          gradient: RideVisuals.wash(context, AppColors.blue),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: border)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          LayoutBuilder(builder: (context, constraints) {
            final dateLabel =
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const ExcludeSemantics(
                  child: Icon(Icons.calendar_today_rounded,
                      size: 15, color: Color(0xFFE6862A))),
              const SizedBox(width: 7),
              Expanded(
                  child: Text(date,
                      style: base.copyWith(fontSize: 12, color: muted))),
            ]);
            final amount = Text(fare,
                style: base.copyWith(
                    fontSize: 23, fontWeight: FontWeight.w700, height: 1.2));
            if (constraints.maxWidth < 270 || expandedText) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [dateLabel, const SizedBox(height: 8), amount]);
            }
            return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: dateLabel),
                  const SizedBox(width: 12),
                  Flexible(
                      child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: amount)),
                ]);
          }),
          if (returnTime.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(returnTime, style: base.copyWith(fontSize: 12, color: muted)),
          ],
          const SizedBox(height: 20),
          _HistoryStop(
              label: l10n.pickup,
              address: pickup,
              time: pickupTime,
              pickup: true,
              base: base,
              muted: muted,
              expandedText: expandedText),
          Padding(
              padding: const EdgeInsetsDirectional.only(start: 15),
              child: Container(
                  height: 16,
                  width: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color: border)),
          _HistoryStop(
              label: l10n.drop,
              address: drop,
              time: dropTime,
              pickup: false,
              base: base,
              muted: muted,
              expandedText: expandedText),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1, color: border)),
          LayoutBuilder(builder: (context, constraints) {
            final vehicleInfo = Row(children: [
              ExcludeSemantics(
                  child: RideColorBadge(
                      icon: vehicleIcon,
                      gradient: RideVisuals.blue,
                      size: 42,
                      iconSize: 24,
                      radius: 14)),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(vehicle,
                        style: base.copyWith(fontWeight: FontWeight.w600)),
                    if (carColor.isNotEmpty)
                      Text(carColor,
                          style: base.copyWith(fontSize: 12, color: muted)),
                  ])),
            ]);
            final badge = status == null
                ? null
                : _HistoryStatusBadge(
                    status: status!, label: statusLabel, base: base);
            if (constraints.maxWidth < 270 || expandedText) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    vehicleInfo,
                    if (badge != null) ...[
                      const SizedBox(height: 12),
                      badge,
                    ],
                  ]);
            }
            return Row(children: [
              Expanded(child: vehicleInfo),
              if (badge != null) ...[
                const SizedBox(width: 12),
                Flexible(
                    child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: badge)),
              ],
              const SizedBox(width: 6),
              ExcludeSemantics(
                  child: Icon(Icons.chevron_right_rounded,
                      size: 20, color: muted)),
            ]);
          }),
          if (tripType.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(tripType, style: base.copyWith(fontSize: 12, color: muted)),
          ],
          if (footer != null) ...[
            const SizedBox(height: 14),
            footer!,
          ],
        ]),
      ),
    );
  }
}

class _HistoryStop extends StatelessWidget {
  const _HistoryStop({
    required this.label,
    required this.address,
    required this.time,
    required this.pickup,
    required this.base,
    required this.muted,
    required this.expandedText,
  });
  final String label, address, time;
  final bool pickup, expandedText;
  final TextStyle base;
  final Color muted;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(
              child: RideColorBadge(
                  icon: pickup
                      ? Icons.my_location_rounded
                      : Icons.location_on_rounded,
                  gradient: pickup ? RideVisuals.green : RideVisuals.rose,
                  size: 32,
                  iconSize: 17,
                  radius: 11)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Wrap(spacing: 12, runSpacing: 3, children: [
                  Text(label, style: base.copyWith(fontSize: 11, color: muted)),
                  if (time.isNotEmpty)
                    Text(time,
                        style: base.copyWith(fontSize: 11, color: muted)),
                ]),
                const SizedBox(height: 5),
                Text(address,
                    maxLines: expandedText ? null : 2,
                    overflow: expandedText ? null : TextOverflow.ellipsis,
                    style: base),
              ])),
        ],
      );
}

class _HistoryStatusBadge extends StatelessWidget {
  const _HistoryStatusBadge(
      {required this.status, required this.label, required this.base});
  final HistoryRideStatus status;
  final String label;
  final TextStyle base;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final color = switch (status) {
      HistoryRideStatus.completed =>
        dark ? const Color(0xFF73D9AC) : AppColors.routeGreen,
      HistoryRideStatus.upcoming =>
        dark ? const Color(0xFFFFC46F) : const Color(0xFF925400),
      HistoryRideStatus.cancelled =>
        dark ? AppColors.signalRose : AppColors.meshwarRed,
    };
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
            color: color.withValues(alpha: dark ? .14 : .08),
            borderRadius: BorderRadius.circular(12)),
        child: Text(label,
            style: base.copyWith(
                color: color, fontSize: 11, fontWeight: FontWeight.w600)));
  }
}
