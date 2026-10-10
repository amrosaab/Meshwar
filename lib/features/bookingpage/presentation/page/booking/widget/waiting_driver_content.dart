import 'package:flutter/material.dart';

import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../core/utils/custom_button.dart';

class WaitingRideStop {
  const WaitingRideStop({required this.address, this.isPickup = false});
  final String address;
  final bool isPickup;
}

/// The booking bloc still owns the search timer and cancellation flow.
class WaitingDriverContent extends StatelessWidget {
  const WaitingDriverContent({
    super.key,
    required this.remainingSeconds,
    required this.maximumSeconds,
    required this.stops,
    required this.paymentLabel,
    required this.paymentIcon,
    required this.onCancel,
    this.vehicleName,
  });

  final int remainingSeconds;
  final double maximumSeconds;
  final List<WaitingRideStop> stops;
  final String paymentLabel;
  final IconData paymentIcon;
  final String? vehicleName;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ink = dark ? const Color(0xFFF8F5F7) : const Color(0xFF201B25);
    final muted = dark ? const Color(0xFFBAADB9) : const Color(0xFF79717C);
    final accent = dark ? AppColors.signalRose : AppColors.meshwarRed;
    final base = Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontSize: 14, height: 1.45, color: ink, fontWeight: FontWeight.w500);
    final duration = Duration(seconds: remainingSeconds.clamp(0, 2147483647));
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    final clock = [
      if (duration.inHours > 0) twoDigits(duration.inHours),
      twoDigits(duration.inMinutes.remainder(60)),
      twoDigits(duration.inSeconds.remainder(60)),
    ].join(':');
    final progress = maximumSeconds.isFinite && maximumSeconds > 0
        ? (duration.inSeconds / maximumSeconds).clamp(0.0, 1.0)
        : 0.0;

    Widget sectionLabel(String label) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(label,
              style: base.copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
        );

    return ColoredBox(
      color: RideVisuals.canvas(context),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                    color: muted.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(height: 20),
            _WaitingCard(
              tone: AppColors.meshwarRed,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const RideColorBadge(
                          icon: Icons.radar_rounded,
                          gradient: RideVisuals.rose,
                          size: 44,
                          iconSize: 23,
                          radius: 15),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(l10n.discoverYourDriver,
                            style: base.copyWith(
                                fontSize: 20,
                                height: 1.3,
                                fontWeight: FontWeight.w700)),
                      ),
                    ]),
                    const SizedBox(height: 18),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: progress, end: progress),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                        builder: (context, value, _) => LinearProgressIndicator(
                          value: value,
                          minHeight: 5,
                          color: accent,
                          backgroundColor: accent.withValues(alpha: .1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(children: [
                      Icon(Icons.schedule_rounded, size: 16, color: accent),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text('$clock ${l10n.mins}',
                            style: base.copyWith(
                                color: accent, fontWeight: FontWeight.w700)),
                      ),
                    ]),
                  ]),
            ),
            const SizedBox(height: 24),
            sectionLabel(l10n.bookingDetails),
            _WaitingCard(
              tone: AppColors.routeGreen,
              child: Column(children: [
                for (var index = 0; index < stops.length; index++) ...[
                  if (index > 0)
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Divider(
                            height: 1, color: muted.withValues(alpha: .12))),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    RideColorBadge(
                        icon: stops[index].isPickup
                            ? Icons.my_location_rounded
                            : Icons.location_on_rounded,
                        gradient: stops[index].isPickup
                            ? RideVisuals.green
                            : RideVisuals.rose,
                        size: 32,
                        iconSize: 17,
                        radius: 11),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                stops[index].isPickup ? l10n.pickup : l10n.drop,
                                style:
                                    base.copyWith(fontSize: 12, color: muted)),
                            const SizedBox(height: 4),
                            Text(stops[index].address, style: base),
                          ]),
                    ),
                  ]),
                ],
              ]),
            ),
            const SizedBox(height: 24),
            if (vehicleName != null) ...[
              sectionLabel(l10n.rideDetails),
              _WaitingCard(
                  tone: AppColors.blue,
                  child: _DetailRow(
                      icon: Icons.directions_car_rounded,
                      gradient: RideVisuals.blue,
                      label: vehicleName!,
                      style: base)),
              const SizedBox(height: 24),
            ],
            sectionLabel(l10n.payment),
            _WaitingCard(
                tone: AppColors.orange,
                child: _DetailRow(
                    icon: paymentIcon,
                    gradient: RideVisuals.amber,
                    label: paymentLabel,
                    style: base)),
            const SizedBox(height: 24),
            CustomButton(
              key: const ValueKey('cancelWaitingRide'),
              width: double.infinity,
              height: (58 * MediaQuery.textScalerOf(context).scale(17) / 17)
                  .clamp(58.0, 104.0),
              borderRadius: 30,
              textSize: 17,
              buttonColor: Theme.of(context).primaryColor,
              buttonName: l10n.cancelRide,
              onTap: onCancel,
            ),
          ]),
        ),
      ),
    );
  }
}

class _WaitingCard extends StatelessWidget {
  const _WaitingCard({required this.tone, required this.child});
  final Color tone;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            gradient: RideVisuals.wash(context, tone),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.surfaceBorder(context)),
            boxShadow: RideVisuals.glow(tone, strength: .08)),
        child: child,
      );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(
      {required this.icon,
      required this.gradient,
      required this.label,
      required this.style});
  final IconData icon;
  final LinearGradient gradient;
  final String label;
  final TextStyle style;

  @override
  Widget build(BuildContext context) => Row(children: [
        RideColorBadge(
            icon: icon, gradient: gradient, size: 38, iconSize: 21, radius: 13),
        const SizedBox(width: 12),
        Expanded(
            child: Text(label,
                style: style.copyWith(fontWeight: FontWeight.w600))),
      ]);
}
