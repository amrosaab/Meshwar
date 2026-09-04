import 'package:flutter/material.dart';

import '../../../../../../common/app_images.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';

class SupportEmptyWidget extends StatelessWidget {
  const SupportEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.supportEmpty),
            const SizedBox(height: 10),
            MyText(
              text: AppLocalizations.of(context)!.supportEmptyText,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).disabledColor,
                    fontSize: 18,
                  ),
            ),
            MyText(
              text: AppLocalizations.of(context)!.supportEmptySubText,
              maxLines: 2,
              textAlign: TextAlign.center,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).disabledColor,
                    fontSize: 16,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
