import 'package:flutter/material.dart';

import '../../../../../../common/app_colors.dart';
import '../../../../../../common/app_images.dart';
import '../../../../../../common/liquid_glass_container.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';


class HistoryNodataWidget extends StatelessWidget {
  /// Called when the user taps "Book a ride". Left nullable and wired by
  /// whoever hosts this widget (e.g. HistoryPage) — this widget itself
  /// has no way to know whether it's a pushed route (Navigator.pop makes
  /// sense) or a tab inside home_page.dart's IndexedStack (needs a
  /// callback into HomeBloc/parent state instead). Guessing wrong here
  /// would silently break navigation, so it's left as an explicit hook.
  final VoidCallback? onBookRide;

  const HistoryNodataWidget({
    super.key,
    this.onBookRide,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular glass bubble — matches the reference image's
            // floating soap-bubble treatment around the illustration,
            // with a real painted highlight rather than a flat tint.
            LiquidGlassContainer(
              circular: true,
              width: 148,
              height: 148,
              blurSigma: 14,
              fillOpacity: 0.1,
              child: Center(
                child: Image.asset(
                  AppImages.historyNoData,
                  width: 92,
                  height: 92,
                ),
              ),
            ),
            const SizedBox(height: 24),
            MyText(
              text: AppLocalizations.of(context)!.noHistory,
              textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            MyText(
              text: AppLocalizations.of(context)!.noHistoryText,
              maxLines: 2,
              textAlign: TextAlign.center,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.greyHintColor,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            if (onBookRide != null) ...[
              const SizedBox(height: 24),
              CustomButton(
                buttonName: AppLocalizations.of(context)!.bookNow,
                width: 180,
                onTap: onBookRide,
              ),
            ],
          ],
        ),
      ),
    );
  }
}