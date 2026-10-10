import 'package:flutter/material.dart';

import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';

class HistoryNodataWidget extends StatelessWidget {
  const HistoryNodataWidget({super.key, this.onBookRide});
  final VoidCallback? onBookRide;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final base = Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontSize: 14,
        height: 1.5,
        color: dark ? const Color(0xFFBAADB9) : const Color(0xFF79717C));
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const ExcludeSemantics(
            child: SizedBox(
              width: 140,
              height: 110,
              child: Stack(children: [
                Center(
                    child: RideColorBadge(
                        icon: Icons.history_rounded,
                        gradient: RideVisuals.blue,
                        size: 76,
                        iconSize: 40,
                        radius: 28)),
                Positioned(
                    right: 4,
                    top: 0,
                    child: RideColorBadge(
                        icon: Icons.calendar_today_rounded,
                        gradient: RideVisuals.amber,
                        size: 32,
                        iconSize: 16,
                        radius: 11)),
                Positioned(
                    left: 4,
                    bottom: 0,
                    child: RideColorBadge(
                        icon: Icons.route_rounded,
                        gradient: RideVisuals.green,
                        size: 32,
                        iconSize: 17,
                        radius: 11)),
              ]),
            ),
          ),
          const SizedBox(height: 22),
          Text(l10n.noHistory,
              textAlign: TextAlign.center,
              style: base.copyWith(
                  fontSize: 22,
                  height: 1.3,
                  fontWeight: FontWeight.w700,
                  color: dark
                      ? const Color(0xFFF8F5F7)
                      : const Color(0xFF201B25))),
          const SizedBox(height: 8),
          Text(l10n.noHistoryText, textAlign: TextAlign.center, style: base),
          if (onBookRide != null) ...[
            const SizedBox(height: 24),
            FilledButton(
                onPressed: onBookRide,
                style: FilledButton.styleFrom(
                    backgroundColor: AppColors.meshwarRed,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(180, 58),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: Text(l10n.bookNow,
                    style: base.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w700))),
          ],
        ]),
      ),
    );
  }
}
