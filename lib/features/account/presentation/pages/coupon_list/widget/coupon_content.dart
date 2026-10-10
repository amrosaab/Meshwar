import 'package:flutter/material.dart';

import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../widgets/account_content.dart';

class CouponOfferCard extends StatelessWidget {
  const CouponOfferCard(
      {super.key,
      required this.code,
      required this.saving,
      required this.terms,
      required this.expiry,
      required this.applied,
      required this.onAction,
      required this.onSelect,
      this.enabled = true,
      this.busy = false});
  final String code, saving, terms, expiry;
  final bool applied, enabled, busy;
  final VoidCallback onAction, onSelect;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final green = dark ? const Color(0xFF73D9AC) : AppColors.routeGreen;
    return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
              gradient: RideVisuals.wash(
                  context, applied ? AppColors.routeGreen : AppColors.blue),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                  color: applied
                      ? green.withValues(alpha: .35)
                      : AppColors.surfaceBorder(context))),
          child: InkWell(
              onTap: enabled ? onSelect : null,
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ExcludeSemantics(
                                  child: RideColorBadge(
                                      icon: Icons.local_offer_rounded,
                                      gradient: applied
                                          ? RideVisuals.green
                                          : RideVisuals.blue,
                                      size: 44,
                                      iconSize: 23,
                                      radius: 15)),
                              const SizedBox(width: 14),
                              Expanded(
                                  child: Text(code,
                                      textDirection: TextDirection.ltr,
                                      style: AccountStyle.text(context)
                                          .copyWith(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700))),
                            ]),
                        const SizedBox(height: 18),
                        Text(saving,
                            style: AccountStyle.text(context).copyWith(
                                color: green,
                                fontSize: 20,
                                fontWeight: FontWeight.w700)),
                        if (applied) ...[
                          const SizedBox(height: 8),
                          Text(l10n.promoApplied.replaceAll('111', code),
                              style: AccountStyle.text(context)
                                  .copyWith(color: green, fontSize: 12)),
                        ],
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Divider(
                                height: 1,
                                color: AppColors.surfaceBorder(context))),
                        Text(terms,
                            style: AccountStyle.text(context)
                                .copyWith(color: AccountStyle.muted(context))),
                        const SizedBox(height: 14),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const ExcludeSemantics(
                                  child: Icon(Icons.calendar_today_outlined,
                                      size: 16, color: Color(0xFFE6862A))),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: Text('${l10n.expiryDate}: $expiry',
                                      style: AccountStyle.text(context)
                                          .copyWith(
                                              fontSize: 12,
                                              color: AccountStyle.muted(
                                                  context)))),
                            ]),
                        const SizedBox(height: 18),
                        SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                                onPressed: enabled && !busy ? onAction : null,
                                style: FilledButton.styleFrom(
                                    backgroundColor: applied
                                        ? AppColors.surface(context)
                                        : AppColors.meshwarRed,
                                    foregroundColor: applied
                                        ? AccountStyle.ink(context)
                                        : Colors.white,
                                    minimumSize: const Size.fromHeight(48),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24))),
                                child: busy
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.meshwarRed))
                                    : Text(applied ? l10n.remove : l10n.apply,
                                        style: AccountStyle.text(context)
                                            .copyWith(
                                                fontWeight: FontWeight.w700,
                                                color: applied
                                                    ? AccountStyle.ink(context)
                                                    : Colors.white)))),
                      ]))),
        ));
  }
}

class CouponEmptyContent extends StatelessWidget {
  const CouponEmptyContent({super.key, required this.onRefresh});
  final VoidCallback onRefresh;
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
                              icon: Icons.local_offer_rounded,
                              gradient: RideVisuals.blue,
                              size: 76,
                              iconSize: 36,
                              radius: 28)),
                      Positioned(
                          right: 4,
                          top: 0,
                          child: RideColorBadge(
                              icon: Icons.percent_rounded,
                              gradient: RideVisuals.amber,
                              size: 32,
                              iconSize: 18,
                              radius: 11)),
                      Positioned(
                          left: 4,
                          bottom: 0,
                          child: RideColorBadge(
                              icon: Icons.redeem_rounded,
                              gradient: RideVisuals.green,
                              size: 32,
                              iconSize: 17,
                              radius: 11)),
                    ]))),
            const SizedBox(height: 24),
            Text(AppLocalizations.of(context)!.noDataAvailable,
                textAlign: TextAlign.center,
                style: AccountStyle.text(context)
                    .copyWith(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            OutlinedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(AppLocalizations.of(context)!.refresh)),
          ])));
}
