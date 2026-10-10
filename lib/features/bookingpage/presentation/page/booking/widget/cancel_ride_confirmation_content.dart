import 'package:flutter/material.dart';

import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';

/// Presents the choice; the caller owns the timer and cancellation request.
class CancelRideConfirmationContent extends StatelessWidget {
  const CancelRideConfirmationContent({
    super.key,
    required this.onKeepRide,
    required this.onCancelRide,
  });

  final VoidCallback onKeepRide;
  final VoidCallback onCancelRide;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ink = dark ? const Color(0xFFF8F5F7) : const Color(0xFF201B25);
    final muted = dark ? const Color(0xFFBAADB9) : const Color(0xFF79717C);
    final accent = dark ? AppColors.signalRose : AppColors.meshwarRed;
    final base = Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontSize: 14, height: 1.5, color: ink, fontWeight: FontWeight.w500);
    final radius = BorderRadius.circular(30);

    return LayoutBuilder(builder: (context, constraints) {
      return ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: constraints.maxHeight
                .clamp(0, MediaQuery.sizeOf(context).height * .85)),
        child: DecoratedBox(
          decoration: BoxDecoration(
              gradient: RideVisuals.wash(context, AppColors.meshwarRed),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(32))),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            child: SingleChildScrollView(
              child: SafeArea(
                top: false,
                minimum: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    ExcludeSemantics(
                      child: SizedBox(
                        width: 220,
                        height: 124,
                        child: Stack(children: [
                          Positioned.fill(
                            left: 16,
                            right: 16,
                            top: 8,
                            bottom: 8,
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient:
                                      RideVisuals.wash(context, AppColors.blue),
                                  color: AppColors.blue.withValues(alpha: .05),
                                  borderRadius: BorderRadius.circular(36),
                                  border: Border.all(
                                      color: AppColors.blue
                                          .withValues(alpha: .12))),
                            ),
                          ),
                          Positioned.fill(
                            child: Center(
                              child: Image.asset(
                                  'assets/sedan_sprites/tilt_45_heading_225.png',
                                  width: 116,
                                  height: 116,
                                  filterQuality: FilterQuality.medium),
                            ),
                          ),
                          const Positioned(
                              left: 0,
                              bottom: 8,
                              child: RideColorBadge(
                                  icon: Icons.close_rounded,
                                  gradient: RideVisuals.rose,
                                  size: 38,
                                  iconSize: 23,
                                  radius: 14)),
                          const Positioned(
                              right: 0,
                              top: 0,
                              child: RideColorBadge(
                                  icon: Icons.schedule_rounded,
                                  gradient: RideVisuals.amber,
                                  size: 38,
                                  iconSize: 21,
                                  radius: 14)),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Semantics(
                        header: true,
                        child: Text(l10n.cancelRideConfirmationTitle,
                            textAlign: TextAlign.center,
                            style: base.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                height: 1.25))),
                    const SizedBox(height: 10),
                    Text(l10n.cancelRideSearchBody,
                        textAlign: TextAlign.center,
                        style: base.copyWith(
                            color: muted, fontWeight: FontWeight.w400)),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: radius,
                          boxShadow: RideVisuals.glow(AppColors.meshwarRed,
                              strength: .2)),
                      child: FilledButton(
                        key: const ValueKey('keepSearching'),
                        onPressed: onKeepRide,
                        style: FilledButton.styleFrom(
                            backgroundColor: AppColors.meshwarRed,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(58),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            shape:
                                RoundedRectangleBorder(borderRadius: radius)),
                        child: Text(l10n.keepSearching.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: base.copyWith(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: .4)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        key: const ValueKey('confirmCancelRide'),
                        onPressed: onCancelRide,
                        style: OutlinedButton.styleFrom(
                            foregroundColor: accent,
                            side: BorderSide(
                                color: accent.withValues(alpha: .25)),
                            minimumSize: const Size.fromHeight(52),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            shape:
                                RoundedRectangleBorder(borderRadius: radius)),
                        child: Text(l10n.cancelRide,
                            textAlign: TextAlign.center,
                            style: base.copyWith(
                                color: accent,
                                fontSize: 15,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
