import 'package:flutter/material.dart';
import '../../../../common/app_colors.dart';
import '../../../../common/ride_visuals.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/presentation/widgets/account_content.dart';
import '../../domain/models/language_listing_model.dart';

class LanguageContent extends StatelessWidget {
  const LanguageContent(
      {super.key,
      required this.languages,
      required this.selectedIndex,
      required this.onSelect,
      required this.onConfirm,
      this.busy = false});
  final List<LocaleLanguageList> languages;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onConfirm;
  final bool busy;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(children: [
      Expanded(
          child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: languages.length,
        separatorBuilder: (_, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final selected = index == selectedIndex;
          return Semantics(
              selected: selected,
              button: true,
              child: Material(
                color: selected
                    ? AppColors.meshwarRed.withValues(alpha: .07)
                    : Theme.of(context).brightness == Brightness.dark
                        ? AppColors.bgAsphaltLight
                        : Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(
                        color: selected
                            ? AppColors.meshwarRed
                            : AppColors.surfaceBorder(context),
                        width: selected ? 1.5 : 1)),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: busy ? null : () => onSelect(index),
                  child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(children: [
                        ExcludeSemantics(
                            child: RideColorBadge(
                                icon: Icons.translate_rounded,
                                gradient: [
                                  RideVisuals.blue,
                                  RideVisuals.green,
                                  RideVisuals.amber,
                                  RideVisuals.rose
                                ][index % 4],
                                size: 44,
                                iconSize: 23,
                                radius: 15)),
                        const SizedBox(width: 14),
                        Expanded(
                            child: Text(languages[index].name,
                                style: AccountStyle.text(context).copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700))),
                        const SizedBox(width: 12),
                        ExcludeSemantics(
                            child: Icon(
                                selected
                                    ? Icons.check_circle_rounded
                                    : Icons.radio_button_unchecked_rounded,
                                color: selected
                                    ? AppColors.meshwarRed
                                    : AccountStyle.muted(context),
                                size: 24)),
                      ])),
                ),
              ));
        },
      )),
      SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: busy ||
                        selectedIndex < 0 ||
                        selectedIndex >= languages.length
                    ? null
                    : onConfirm,
                style: FilledButton.styleFrom(
                    backgroundColor: AppColors.meshwarRed,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(58),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: busy
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text(l10n.confirm,
                        textAlign: TextAlign.center,
                        style: AccountStyle.text(context).copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
              ))),
    ]);
  }
}
