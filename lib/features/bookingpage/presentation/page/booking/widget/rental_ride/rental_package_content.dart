import 'package:flutter/material.dart';
import '../../../../../../../common/app_colors.dart';
import '../../../../../../../common/ride_visuals.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../account/presentation/widgets/account_content.dart';
import '../../../../../domain/models/rental_packages_model.dart';

class RentalPackageSheet extends StatelessWidget {
  const RentalPackageSheet(
      {super.key,
      required this.packages,
      required this.selectedIndex,
      required this.onSelect,
      required this.onContinue,
      required this.onClose});
  final List<RentalPackagesData> packages;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback? onContinue;
  final VoidCallback onClose;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
        color: RideVisuals.canvas(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        clipBehavior: Clip.antiAlias,
        child: Column(children: [
          const SizedBox(height: 12),
          Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.surfaceBorder(context),
                  borderRadius: BorderRadius.circular(4))),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 12, 8),
              child: Row(children: [
                const ExcludeSemantics(
                    child: RideColorBadge(
                        icon: Icons.calendar_month_outlined,
                        gradient: RideVisuals.amber,
                        size: 44,
                        iconSize: 24,
                        radius: 15)),
                const SizedBox(width: 14),
                Expanded(
                    child: Text(l10n.selectPackage,
                        style: AccountStyle.text(context).copyWith(
                            fontSize: 22, fontWeight: FontWeight.w700))),
                IconButton(
                    onPressed: onClose,
                    tooltip:
                        MaterialLocalizations.of(context).closeButtonTooltip,
                    icon: const Icon(Icons.close_rounded),
                    style: IconButton.styleFrom(
                        foregroundColor: AccountStyle.ink(context),
                        minimumSize: const Size(44, 44))),
              ])),
          Expanded(
              child: packages.isEmpty
                  ? CustomScrollView(slivers: [
                      SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                              child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const ExcludeSemantics(
                                            child: RideColorBadge(
                                                icon: Icons
                                                    .directions_car_outlined,
                                                gradient: RideVisuals.blue,
                                                size: 76,
                                                iconSize: 38,
                                                radius: 28)),
                                        const SizedBox(height: 24),
                                        Text(l10n.noDataAvailable,
                                            textAlign: TextAlign.center,
                                            style: AccountStyle.text(context)
                                                .copyWith(
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                      ]))))
                    ])
                  : ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: packages.length,
                      separatorBuilder: (_, index) =>
                          const SizedBox(height: 14),
                      itemBuilder: (context, index) => RentalPackageCard(
                          package: packages[index],
                          selected: selectedIndex == index,
                          onTap: () => onSelect(index)))),
          SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                      onPressed: packages.isEmpty ? onClose : onContinue,
                      style: FilledButton.styleFrom(
                          backgroundColor: AppColors.meshwarRed,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(58),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: Text(
                          packages.isEmpty ? l10n.backToHome : l10n.continueN,
                          textAlign: TextAlign.center,
                          style: AccountStyle.text(context).copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700))))),
        ]));
  }
}

class RentalPackageCard extends StatelessWidget {
  const RentalPackageCard(
      {super.key,
      required this.package,
      required this.selected,
      required this.onTap});
  final RentalPackagesData package;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final minimum = package.minPrice;
    final maximum = package.maxPrice;
    final String price;
    if (minimum != null && maximum != null && minimum != maximum) {
      price =
          '${package.currency} ${minimum.toStringAsFixed(1)} – ${maximum.toStringAsFixed(1)}';
    } else if (minimum != null || maximum != null) {
      price = '${package.currency} ${(minimum ?? maximum!).toStringAsFixed(1)}';
    } else {
      price = '';
    }
    return Semantics(
        button: true,
        selected: selected,
        child: Material(
            color: Theme.of(context).brightness == Brightness.dark
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
                onTap: onTap,
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const ExcludeSemantics(
                                    child: RideColorBadge(
                                        icon: Icons.directions_car_outlined,
                                        gradient: RideVisuals.blue,
                                        size: 44,
                                        iconSize: 24,
                                        radius: 15)),
                                const SizedBox(width: 14),
                                Expanded(
                                    child: Text(package.packageName,
                                        style: AccountStyle.text(context)
                                            .copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700))),
                                const SizedBox(width: 8),
                                ExcludeSemantics(
                                    child: Icon(
                                        selected
                                            ? Icons.check_circle_rounded
                                            : Icons
                                                .radio_button_unchecked_rounded,
                                        color: selected
                                            ? AppColors.meshwarRed
                                            : AccountStyle.muted(context),
                                        size: 24)),
                              ]),
                          if (package.shortDescription.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(package.shortDescription,
                                style: AccountStyle.text(context).copyWith(
                                    color: AccountStyle.muted(context)))
                          ],
                          if (price.isNotEmpty) ...[
                            const SizedBox(height: 18),
                            Divider(
                                height: 1,
                                color: AppColors.surfaceBorder(context)),
                            const SizedBox(height: 16),
                            Text(price,
                                style: AccountStyle.text(context).copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AccountStyle.ink(context)))
                          ],
                        ])))));
  }
}
