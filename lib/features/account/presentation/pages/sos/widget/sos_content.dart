import 'package:flutter/material.dart';
import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../widgets/account_content.dart';

class SosContactCard extends StatelessWidget {
  const SosContactCard(
      {super.key,
      required this.name,
      required this.number,
      this.onDelete,
      this.onSelect,
      this.selected = false});
  final String name, number;
  final VoidCallback? onDelete, onSelect;
  final bool selected;
  @override
  Widget build(BuildContext context) => Semantics(
      selected: onSelect == null ? null : selected,
      child: Material(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.bgAsphaltLight
            : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
                color: selected
                    ? AppColors.meshwarRed
                    : AppColors.surfaceBorder(context))),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
            onTap: onSelect,
            child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ExcludeSemantics(
                          child: RideColorBadge(
                              icon: Icons.person_rounded,
                              gradient: RideVisuals.blue,
                              size: 44,
                              iconSize: 24,
                              radius: 15)),
                      const SizedBox(width: 14),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(
                                name.isEmpty
                                    ? AppLocalizations.of(context)!.name
                                    : name,
                                style: AccountStyle.text(context).copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 5),
                            Text(number,
                                textDirection: TextDirection.ltr,
                                style: AccountStyle.text(context).copyWith(
                                    color: AccountStyle.muted(context))),
                          ])),
                      const SizedBox(width: 8),
                      if (onDelete != null)
                        IconButton(
                            tooltip: AppLocalizations.of(context)!.delete,
                            onPressed: onDelete,
                            style: IconButton.styleFrom(
                                minimumSize: const Size(44, 44),
                                backgroundColor:
                                    AppColors.meshwarRed.withValues(alpha: .08),
                                foregroundColor: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? const Color(0xFFFF82A6)
                                    : AppColors.meshwarRed),
                            icon: const Icon(Icons.delete_outline_rounded,
                                size: 22)),
                      if (onSelect != null)
                        ExcludeSemantics(
                            child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Icon(
                                    selected
                                        ? Icons.radio_button_checked_rounded
                                        : Icons.radio_button_unchecked_rounded,
                                    color: selected
                                        ? AppColors.meshwarRed
                                        : AccountStyle.muted(context)))),
                    ]))),
      ));
}

class SosEmptyContent extends StatelessWidget {
  const SosEmptyContent({super.key});
  @override
  Widget build(BuildContext context) => Center(
      child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const ExcludeSemantics(
                child: SizedBox(
                    width: 140,
                    height: 110,
                    child: Stack(children: [
                      Center(
                          child: RideColorBadge(
                              icon: Icons.shield_outlined,
                              gradient: RideVisuals.rose,
                              size: 76,
                              iconSize: 38,
                              radius: 28)),
                      Positioned(
                          right: 4,
                          top: 0,
                          child: RideColorBadge(
                              icon: Icons.favorite_rounded,
                              gradient: RideVisuals.amber,
                              size: 32,
                              iconSize: 17,
                              radius: 11)),
                      Positioned(
                          left: 4,
                          bottom: 0,
                          child: RideColorBadge(
                              icon: Icons.person_rounded,
                              gradient: RideVisuals.blue,
                              size: 32,
                              iconSize: 18,
                              radius: 11)),
                    ]))),
            const SizedBox(height: 24),
            Text(AppLocalizations.of(context)!.nososContacts,
                textAlign: TextAlign.center,
                style: AccountStyle.text(context)
                    .copyWith(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Text(AppLocalizations.of(context)!.addContactsText,
                textAlign: TextAlign.center,
                style: AccountStyle.text(context)
                    .copyWith(color: AccountStyle.muted(context))),
          ])));
}

class SosAddActions extends StatelessWidget {
  const SosAddActions(
      {super.key,
      required this.onContacts,
      required this.onManual,
      this.busy = false});
  final VoidCallback onContacts, onManual;
  final bool busy;
  @override
  Widget build(BuildContext context) => SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
                onPressed: busy ? null : onContacts,
                icon: const Icon(Icons.person_add_alt_1_rounded, size: 21),
                label: Text(AppLocalizations.of(context)!.addFromContact,
                    textAlign: TextAlign.center,
                    style: AccountStyle.text(context).copyWith(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
                style: FilledButton.styleFrom(
                    backgroundColor: AppColors.meshwarRed,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(58),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)))),
            const SizedBox(height: 10),
            OutlinedButton.icon(
                onPressed: busy ? null : onManual,
                icon: const Icon(Icons.edit_outlined, size: 20),
                label: Text(AppLocalizations.of(context)!.addManually,
                    textAlign: TextAlign.center),
                style: OutlinedButton.styleFrom(
                    foregroundColor: AccountStyle.ink(context),
                    minimumSize: const Size.fromHeight(48),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    side: BorderSide(color: AppColors.surfaceBorder(context)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26)))),
          ]));
}
