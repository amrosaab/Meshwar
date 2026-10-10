import 'package:flutter/material.dart';

import '../../../../../../common/app_colors.dart';
import '../../../../../../l10n/app_localizations.dart';

class HistoryFilterTabs extends StatelessWidget {
  const HistoryFilterTabs({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    this.isLoading = false,
  });
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final labels = [l10n.completed, l10n.upcoming, l10n.cancelled];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: dark ? const Color(0xFF241A2A) : const Color(0xFFF0EDF3),
          borderRadius: BorderRadius.circular(26)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        for (var index = 0; index < labels.length; index++)
          Expanded(
            child: Semantics(
              selected: index == selectedIndex,
              child: AnimatedContainer(
                duration: MediaQuery.disableAnimationsOf(context)
                    ? Duration.zero
                    : const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                    color: index == selectedIndex
                        ? AppColors.meshwarRed
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(22)),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    key: ValueKey('historyFilter$index'),
                    onTap: isLoading || index == selectedIndex
                        ? null
                        : () => onSelected(index),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 48),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 14),
                        child: Text(labels[index],
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 12,
                                    height: 1.3,
                                    fontWeight: FontWeight.w600,
                                    color: index == selectedIndex
                                        ? Colors.white
                                        : dark
                                            ? const Color(0xFFBAADB9)
                                            : const Color(0xFF79717C))),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ]),
    );
  }
}
