import 'package:flutter/material.dart';
import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../domain/models/walletpage_model.dart';
import '../../../widgets/account_content.dart';

class WalletPaymentMethodSheet extends StatelessWidget {
  const WalletPaymentMethodSheet(
      {super.key,
      required this.gateways,
      required this.selected,
      required this.currency,
      required this.amount,
      required this.cardImage,
      required this.onSelect,
      required this.onPay});
  final List<PaymentGateway> gateways;
  final int? selected;
  final String currency, amount;
  final Widget Function(String) cardImage;
  final ValueChanged<int> onSelect;
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final enabled = [
      for (var i = 0; i < gateways.length; i++)
        if (gateways[i].enabled) i
    ];
    final canPay = selected != null && enabled.contains(selected);
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .85),
      child: Material(
        color: AppColors.surface(context),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: AppColors.surfaceBorder(context),
                      borderRadius: BorderRadius.circular(4))),
              const SizedBox(height: 20),
              Flexible(
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                    Row(children: [
                      const ExcludeSemantics(
                          child: RideColorBadge(
                              icon: Icons.credit_card_rounded,
                              gradient: RideVisuals.blue,
                              size: 44,
                              iconSize: 24,
                              radius: 15)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Text(l10n.choosePaymentMethods,
                              style: AccountStyle.text(context).copyWith(
                                  fontSize: 22,
                                  height: 1.2,
                                  fontWeight: FontWeight.w700))),
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          tooltip: MaterialLocalizations.of(context)
                              .closeButtonTooltip,
                          icon: const Icon(Icons.close_rounded)),
                    ]),
                    const SizedBox(height: 16),
                    Text('$currency $amount',
                        textDirection: TextDirection.ltr,
                        style: AccountStyle.text(context).copyWith(
                            fontSize: 24, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 20),
                    if (enabled.isEmpty)
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(l10n.noDataAvailable,
                              textAlign: TextAlign.center,
                              style: AccountStyle.text(context).copyWith(
                                  color: AccountStyle.muted(context)))),
                    for (final index in enabled) ...[
                      _PaymentMethodCard(
                          gateway: gateways[index],
                          selected: selected == index,
                          cardImage: cardImage,
                          onTap: () => onSelect(index)),
                      const SizedBox(height: 12),
                    ],
                  ]))),
              const SizedBox(height: 12),
              SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                      onPressed: canPay ? onPay : null,
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
                      child: Text(l10n.pay,
                          textAlign: TextAlign.center,
                          style: AccountStyle.text(context).copyWith(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w700)))),
            ]),
          ),
        ),
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard(
      {required this.gateway,
      required this.selected,
      required this.cardImage,
      required this.onTap});
  final PaymentGateway gateway;
  final bool selected;
  final Widget Function(String) cardImage;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        selected: selected,
        child: Material(
          color: AppColors.surface(context),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
              side: BorderSide(
                  color: selected
                      ? AppColors.meshwarRed
                      : AppColors.surfaceBorder(context),
                  width: selected ? 1.5 : 1)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  ExcludeSemantics(
                      child: SizedBox(
                          width: 42,
                          height: 42,
                          child: gateway.isCard
                              ? cardImage(gateway.image)
                              : gateway.image.isEmpty
                                  ? const RideColorBadge(
                                      icon: Icons.payments_outlined,
                                      gradient: RideVisuals.green,
                                      size: 42,
                                      iconSize: 22,
                                      radius: 14)
                                  : Image.network(gateway.image,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, error, stackTrace) =>
                                          const Icon(
                                              Icons.payments_outlined)))),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(gateway.gateway,
                          style: AccountStyle.text(context).copyWith(
                              fontSize: 16, fontWeight: FontWeight.w600))),
                  const SizedBox(width: 10),
                  ExcludeSemantics(
                      child: Icon(
                          selected
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          size: 22,
                          color: selected
                              ? AppColors.meshwarRed
                              : AccountStyle.muted(context))),
                ])),
          ),
        ),
      );
}
