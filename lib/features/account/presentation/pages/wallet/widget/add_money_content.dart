import 'package:flutter/material.dart';
import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../widgets/account_content.dart';

class AddMoneyContent extends StatelessWidget {
  const AddMoneyContent(
      {super.key,
      required this.controller,
      required this.currency,
      required this.balance,
      required this.onChanged,
      required this.onNext,
      this.busy = false});
  final TextEditingController controller;
  final String currency, balance;
  final VoidCallback onNext;
  final ValueChanged<double?> onChanged;
  final bool busy;

  void _key(String key) {
    final current = controller.text;
    String next;
    if (key == 'delete') {
      if (current.isEmpty) return;
      next = current.substring(0, current.length - 1);
    } else if (key == '.') {
      if (current.contains('.')) return;
      next = current.isEmpty ? '0.' : '$current.';
    } else {
      next = current == '0' ? key : '$current$key';
    }
    controller.text = next;
    onChanged(double.tryParse(next));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: RideVisuals.canvas(context),
      appBar: AppBar(
        backgroundColor: dark ? AppColors.bgAsphaltLight : Colors.white,
        foregroundColor: AccountStyle.ink(context),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        toolbarHeight:
            MediaQuery.textScalerOf(context).scale(22) > 32 ? 120 : 64,
        title: Text(l10n.addMoney,
            maxLines: 2,
            style: AccountStyle.text(context).copyWith(
                fontSize: 22, height: 1.2, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
          top: false,
          bottom: false,
          child: ListView(padding: const EdgeInsets.all(20), children: [
            Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                    gradient:
                        RideVisuals.wash(context, const Color(0xFF3A72D4)),
                    borderRadius: BorderRadius.circular(28),
                    border:
                        Border.all(color: AppColors.surfaceBorder(context))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ExcludeSemantics(
                          child: RideColorBadge(
                              icon: Icons.account_balance_wallet_outlined,
                              gradient: RideVisuals.blue,
                              size: 56,
                              iconSize: 28,
                              radius: 18)),
                      const SizedBox(height: 20),
                      Text(l10n.enterAmountHere,
                          style: AccountStyle.text(context)
                              .copyWith(color: AccountStyle.muted(context))),
                      const SizedBox(height: 12),
                      ValueListenableBuilder<TextEditingValue>(
                          valueListenable: controller,
                          builder: (context, value, _) => Semantics(
                              liveRegion: true,
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                      '$currency ${value.text.isEmpty ? '0' : value.text}',
                                      textDirection: TextDirection.ltr,
                                      style: AccountStyle.text(context)
                                          .copyWith(
                                              fontSize: 40,
                                              height: 1.15,
                                              fontWeight: FontWeight.w700))))),
                    ])),
            const SizedBox(height: 16),
            Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                    color: AppColors.surface(context),
                    borderRadius: BorderRadius.circular(22),
                    border:
                        Border.all(color: AppColors.surfaceBorder(context))),
                child: Row(children: [
                  const ExcludeSemantics(
                      child: RideColorBadge(
                          icon: Icons.savings_outlined,
                          gradient: RideVisuals.green,
                          size: 40,
                          iconSize: 22,
                          radius: 14)),
                  const SizedBox(width: 14),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(l10n.walletBalance,
                            style: AccountStyle.text(context).copyWith(
                                fontSize: 12,
                                color: AccountStyle.muted(context))),
                        const SizedBox(height: 4),
                        Text('$currency $balance',
                            textDirection: TextDirection.ltr,
                            style: AccountStyle.text(context).copyWith(
                                fontSize: 18, fontWeight: FontWeight.w700))
                      ])),
                ])),
            const SizedBox(height: 24),
            Directionality(
                textDirection: TextDirection.ltr,
                child: Column(children: [
                  for (final row in const [
                    ['1', '2', '3'],
                    ['4', '5', '6'],
                    ['7', '8', '9'],
                    ['.', '0', 'delete']
                  ])
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(children: [
                          for (var i = 0; i < row.length; i++) ...[
                            if (i != 0) const SizedBox(width: 10),
                            Expanded(
                                child: _AmountKey(
                                    label: row[i],
                                    onTap: busy ? null : () => _key(row[i]))),
                          ],
                        ])),
                ])),
          ])),
      bottomNavigationBar: SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                final amount = double.tryParse(value.text);
                final valid = amount != null && amount.isFinite && amount > 0;
                return FilledButton(
                    onPressed: valid && !busy ? onNext : null,
                    style: FilledButton.styleFrom(
                        backgroundColor: AppColors.meshwarRed,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            AppColors.meshwarRed.withValues(alpha: .4),
                        disabledForegroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(58),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    child: Text(l10n.next,
                        textAlign: TextAlign.center,
                        style: AccountStyle.text(context).copyWith(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700)));
              })),
    );
  }
}

class _AmountKey extends StatelessWidget {
  const _AmountKey({required this.label, required this.onTap});
  final String label;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Semantics(
        label: label == 'delete'
            ? MaterialLocalizations.of(context).deleteButtonTooltip
            : label,
        child: OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.surface(context),
                foregroundColor: AccountStyle.ink(context),
                side: BorderSide(color: AppColors.surfaceBorder(context)),
                minimumSize: const Size.fromHeight(64),
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            child: label == 'delete'
                ? const Icon(Icons.backspace_outlined, size: 24)
                : Text(label,
                    style: AccountStyle.text(context)
                        .copyWith(fontSize: 26, fontWeight: FontWeight.w600))),
      );
}
