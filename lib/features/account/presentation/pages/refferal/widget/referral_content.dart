import 'package:flutter/material.dart';

import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../widgets/account_content.dart';

class ReferralRewardCard extends StatelessWidget {
  const ReferralRewardCard({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            gradient: RideVisuals.rose,
            borderRadius: BorderRadius.circular(28)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const ExcludeSemantics(
              child: RideColorBadge(
                  icon: Icons.card_giftcard_rounded,
                  gradient: RideVisuals.amber,
                  size: 48,
                  iconSize: 25,
                  radius: 16)),
          const SizedBox(height: 20),
          Text(message,
              style: AccountStyle.text(context).copyWith(
                  fontSize: 24,
                  height: 1.3,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          const SizedBox(height: 10),
          Text(AppLocalizations.of(context)!.shareYourInviteCode,
              style: AccountStyle.text(context).copyWith(color: Colors.white)),
        ]),
      );
}

class ReferralCodeCard extends StatelessWidget {
  const ReferralCodeCard({super.key, required this.code, required this.onCopy});
  final String code;
  final VoidCallback? onCopy;
  @override
  Widget build(BuildContext context) => ReferralSurface(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(AppLocalizations.of(context)!.yourReferralCode,
            style: AccountStyle.text(context)
                .copyWith(color: AccountStyle.muted(context))),
        const SizedBox(height: 12),
        LayoutBuilder(builder: (context, constraints) {
          final value = SelectableText(code.isEmpty ? '—' : code,
              textDirection: TextDirection.ltr,
              style: AccountStyle.text(context).copyWith(
                  fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: 2));
          final copy = OutlinedButton.icon(
              onPressed: code.isEmpty ? null : onCopy,
              style: OutlinedButton.styleFrom(
                  foregroundColor: AccountStyle.ink(context),
                  minimumSize: const Size(100, 48),
                  side: BorderSide(color: AppColors.surfaceBorder(context)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16))),
              icon: const Icon(Icons.copy_rounded, size: 18),
              label: Text(AppLocalizations.of(context)!.copy));
          if (constraints.maxWidth < 260 ||
              MediaQuery.textScalerOf(context).scale(14) > 20) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [value, const SizedBox(height: 16), copy]);
          }
          return Row(children: [
            Expanded(child: value),
            const SizedBox(width: 16),
            copy
          ]);
        }),
      ]));
}

class ReferralTabs extends StatelessWidget {
  const ReferralTabs(
      {super.key, required this.showHistory, required this.onSelected});
  final bool showHistory;
  final ValueChanged<bool> onSelected;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Widget tab(bool history, String label) => Semantics(
        selected: showHistory == history,
        child: TextButton(
            onPressed: () {
              if (showHistory != history) onSelected(history);
            },
            style: TextButton.styleFrom(
                foregroundColor: showHistory == history
                    ? Colors.white
                    : AccountStyle.muted(context),
                backgroundColor: showHistory == history
                    ? AppColors.meshwarRed
                    : Colors.transparent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                minimumSize: const Size(0, 48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18))),
            child: Text(label,
                textAlign: TextAlign.center,
                style: AccountStyle.text(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: showHistory == history
                        ? Colors.white
                        : AccountStyle.muted(context)))));
    return Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: AppColors.surfaceStrong(context),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.surfaceBorder(context))),
        child: LayoutBuilder(
            builder: (context, constraints) => constraints.maxWidth < 260 ||
                    MediaQuery.textScalerOf(context).scale(14) > 22
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                        tab(false, l10n.referAndEarn),
                        const SizedBox(height: 4),
                        tab(true, l10n.referralHistory)
                      ])
                : Row(children: [
                    Expanded(child: tab(false, l10n.referAndEarn)),
                    const SizedBox(width: 4),
                    Expanded(child: tab(true, l10n.referralHistory))
                  ])));
  }
}

class ReferralHistoryTile extends StatelessWidget {
  const ReferralHistoryTile(
      {super.key,
      required this.name,
      required this.date,
      required this.earning,
      required this.status});
  final String name, date, earning, status;
  @override
  Widget build(BuildContext context) => ReferralSurface(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const ExcludeSemantics(
              child: RideColorBadge(
                  icon: Icons.redeem_rounded,
                  gradient: RideVisuals.green,
                  size: 44,
                  iconSize: 23,
                  radius: 15)),
          const SizedBox(width: 14),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(name,
                    style: AccountStyle.text(context)
                        .copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
                if (date.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(date,
                      style: AccountStyle.text(context).copyWith(
                          fontSize: 12, color: AccountStyle.muted(context)))
                ],
              ])),
        ]),
        const SizedBox(height: 16),
        Wrap(
            spacing: 14,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(earning,
                  style: AccountStyle.text(context)
                      .copyWith(fontSize: 22, fontWeight: FontWeight.w700)),
              if (status.isNotEmpty)
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                        color: AppColors.surface(context),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(status,
                        style: AccountStyle.text(context).copyWith(
                            fontSize: 12, color: AccountStyle.muted(context)))),
            ]),
      ]));
}

class ReferralNotice extends StatelessWidget {
  const ReferralNotice({super.key, required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) => ReferralSurface(
          child: Column(children: [
        const ExcludeSemantics(
            child: RideColorBadge(
                icon: Icons.card_giftcard_outlined,
                gradient: RideVisuals.blue,
                size: 72,
                iconSize: 34,
                radius: 24)),
        const SizedBox(height: 20),
        Text(message,
            textAlign: TextAlign.center,
            style: AccountStyle.text(context)
                .copyWith(color: AccountStyle.muted(context))),
        if (onRetry != null) ...[
          const SizedBox(height: 16),
          OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(AppLocalizations.of(context)!.tryAgain))
        ],
      ]));
}

class ReferralSurface extends StatelessWidget {
  const ReferralSurface({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.bgAsphaltLight
              : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.surfaceBorder(context))),
      child: child);
}
