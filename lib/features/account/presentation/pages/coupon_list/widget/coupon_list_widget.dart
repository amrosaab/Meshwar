import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../bookingpage/domain/models/promo_code_list_model.dart';
import '../../../../application/acc_bloc.dart';
import 'coupon_content.dart';

class CouponsListWidget extends StatelessWidget {
  const CouponsListWidget(
      {super.key,
      required this.cont,
      required this.promoCodeDataList,
      required this.currencySymbol});
  final BuildContext cont;
  final List<PromoCodeListData> promoCodeDataList;
  final String currencySymbol;
  @override
  Widget build(BuildContext context) {
    final bloc = cont.read<AccBloc>();
    final l10n = AppLocalizations.of(context)!;
    return ListView.separated(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.paddingOf(context).bottom + 20),
        itemCount: promoCodeDataList.length,
        separatorBuilder: (_, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final coupon = promoCodeDataList[index];
          return CouponOfferCard(
              code: coupon.code,
              saving: l10n.saveUptoText.replaceAll(
                  '111', '$currencySymbol${coupon.maximumDiscountAmount}'),
              terms: l10n.promoInfoText
                  .replaceAll('111', coupon.code)
                  .replaceAll(
                      '222', '$currencySymbol${coupon.maximumDiscountAmount}')
                  .replaceAll(
                      '333', '$currencySymbol${coupon.minimumTripAmount}'),
              expiry:
                  MaterialLocalizations.of(context).formatMediumDate(coupon.to),
              applied: coupon.isApplied,
              enabled: !bloc.isLoading && !bloc.isPromoChanging,
              busy: bloc.isPromoChanging &&
                  (bloc.selectedPromoCodeValue == coupon.code ||
                      coupon.isApplied),
              onSelect: () => bloc.add(SelectPromoCodeListIndexEvent(
                  selectedPromoCodeIndex: index,
                  selectedPromoCodeVale: coupon.code)),
              onAction: () {
                if (coupon.isApplied) {
                  bloc.add(PromoCodeClearEvent(from: '2'));
                } else {
                  bloc.add(SelectPromoCodeListApplyEvent(
                      selectedPromoCode: coupon.code,
                      price: coupon.maximumDiscountAmount.toString()));
                }
              });
        });
  }
}
