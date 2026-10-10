import 'package:flutter/material.dart';

import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';

abstract final class WalletStyle {
  static Color ink(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFF8F5F7)
          : const Color(0xFF201B25);
  static Color muted(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFBAADB9)
          : const Color(0xFF79717C);
  static TextStyle text(BuildContext context) => Theme.of(context)
      .textTheme
      .bodyMedium!
      .copyWith(fontSize: 14, height: 1.4, color: ink(context));
  static BoxDecoration card(BuildContext context, Color tint) => BoxDecoration(
      gradient: RideVisuals.wash(context, tint),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppColors.surfaceBorder(context)));
}

class WalletBalanceCard extends StatelessWidget {
  const WalletBalanceCard(
      {super.key, required this.label, required this.balance});
  final String label;
  final String? balance;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            gradient: RideVisuals.rose,
            borderRadius: BorderRadius.circular(28),
            boxShadow: RideVisuals.glow(AppColors.meshwarRed, strength: .22)),
        child: Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(label,
                    style: WalletStyle.text(context).copyWith(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 12),
                // Keep the last known balance visible during background refresh.
                // An unknown balance is never displayed as zero.
                Text(balance ?? '—',
                    style: WalletStyle.text(context).copyWith(
                        color: Colors.white,
                        fontSize: 36,
                        height: 1.2,
                        fontWeight: FontWeight.w800)),
              ])),
          const SizedBox(width: 16),
          ExcludeSemantics(
              child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .14),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: .2))),
                  child: const Icon(Icons.account_balance_wallet_outlined,
                      size: 30, color: Colors.white))),
        ]),
      );
}

class WalletActionCard extends StatelessWidget {
  const WalletActionCard({
    super.key,
    required this.label,
    required this.icon,
    required this.gradient,
    required this.onPressed,
  });
  final String label;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        enabled: onPressed != null,
        child: Opacity(
          opacity: onPressed == null ? .55 : 1,
          child: Material(
            color: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(24),
            child: Ink(
              decoration: WalletStyle.card(context, gradient.colors.last),
              child: InkWell(
                onTap: onPressed,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExcludeSemantics(
                            child: RideColorBadge(
                                icon: icon,
                                gradient: gradient,
                                size: 42,
                                iconSize: 22)),
                        const SizedBox(height: 16),
                        Row(children: [
                          Expanded(
                              child: Text(label,
                                  style: WalletStyle.text(context)
                                      .copyWith(fontWeight: FontWeight.w700))),
                          const SizedBox(width: 6),
                          ExcludeSemantics(
                              child: Icon(Icons.arrow_forward_rounded,
                                  size: 18, color: WalletStyle.muted(context))),
                        ]),
                      ]),
                ),
              ),
            ),
          ),
        ),
      );
}

class WalletTransactionTile extends StatelessWidget {
  const WalletTransactionTile({
    super.key,
    required this.remarks,
    required this.date,
    required this.amount,
    required this.isDebit,
  });
  final String remarks, date, amount;
  final bool isDebit;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: WalletStyle.card(
            context, isDebit ? AppColors.meshwarRed : AppColors.routeGreen),
        child: LayoutBuilder(builder: (context, constraints) {
          final stacked = constraints.maxWidth < 290 ||
              MediaQuery.textScalerOf(context).scale(14) > 20;
          final amountWidget = Text(amount,
              textDirection: TextDirection.ltr,
              textAlign: stacked ? TextAlign.start : TextAlign.end,
              style: WalletStyle.text(context).copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? (isDebit
                          ? const Color(0xFFFF7DA5)
                          : const Color(0xFF6AE4AA))
                      : (isDebit
                          ? AppColors.meshwarRed
                          : AppColors.routeGreen)));
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ExcludeSemantics(
                child: RideColorBadge(
                    icon: isDebit
                        ? Icons.north_east_rounded
                        : Icons.south_west_rounded,
                    gradient: isDebit ? RideVisuals.rose : RideVisuals.green,
                    size: 38,
                    radius: 14)),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(remarks,
                      style: WalletStyle.text(context)
                          .copyWith(fontWeight: FontWeight.w600)),
                  if (date.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(date,
                        style: WalletStyle.text(context).copyWith(
                            fontSize: 12, color: WalletStyle.muted(context))),
                  ],
                  if (stacked) ...[const SizedBox(height: 10), amountWidget],
                ])),
            if (!stacked) ...[
              const SizedBox(width: 12),
              Flexible(
                  child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: amountWidget)),
            ],
          ]);
        }),
      );
}

class WalletEmptyTransactions extends StatelessWidget {
  const WalletEmptyTransactions(
      {super.key, required this.title, required this.message});
  final String title, message;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: WalletStyle.card(context, AppColors.blue),
        child: Column(children: [
          const ExcludeSemantics(
              child: RideColorBadge(
                  icon: Icons.receipt_long_rounded,
                  gradient: RideVisuals.amber,
                  size: 62,
                  iconSize: 30,
                  radius: 22)),
          const SizedBox(height: 20),
          Text(title,
              textAlign: TextAlign.center,
              style: WalletStyle.text(context)
                  .copyWith(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(message,
              textAlign: TextAlign.center,
              style: WalletStyle.text(context)
                  .copyWith(color: WalletStyle.muted(context))),
        ]),
      );
}

class WalletSavedCard extends StatelessWidget {
  const WalletSavedCard(
      {super.key,
      required this.brand,
      required this.lastNumber,
      required this.onPressed});
  final String brand, lastNumber;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: WalletStyle.card(context, AppColors.blue),
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(children: [
                const ExcludeSemantics(
                    child: RideColorBadge(
                        icon: Icons.credit_card_rounded,
                        gradient: RideVisuals.blue,
                        size: 42)),
                const SizedBox(width: 14),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(brand,
                          style: WalletStyle.text(context)
                              .copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('•••• $lastNumber',
                          textDirection: TextDirection.ltr,
                          style: WalletStyle.text(context)
                              .copyWith(color: WalletStyle.muted(context))),
                    ])),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded,
                    color: WalletStyle.muted(context)),
              ]),
            ),
          ),
        ),
      );
}
