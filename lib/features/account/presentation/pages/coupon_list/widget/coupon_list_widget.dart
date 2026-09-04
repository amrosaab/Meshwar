import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../../../../../../common/liquid_glass_container.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../bookingpage/domain/models/promo_code_list_model.dart';
import '../../../../application/acc_bloc.dart';

class CouponsListWidget extends StatelessWidget {
  final BuildContext cont;
  final List<PromoCodeListData> promoCodeDataList;
  final String currencySymbol;
  const CouponsListWidget(
      {super.key,
        required this.cont,
        required this.promoCodeDataList,
        required this.currencySymbol});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<AccBloc>(),
      child: BlocBuilder<AccBloc, AccState>(
        builder: (context, state) {
          return promoCodeDataList.isNotEmpty
              ? SizedBox(
            height: size.height * 0.725,
            child: RawScrollbar(
              radius: const Radius.circular(20),
              child: ListView.builder(
                itemCount: promoCodeDataList.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onTap: () {
                      context.read<AccBloc>().add(
                          SelectPromoCodeListIndexEvent(
                              selectedPromoCodeIndex: index,
                              selectedPromoCodeVale:
                              promoCodeDataList[index].code));
                    },
                    child: Container(
                      width: size.width,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: LiquidGlassContainer(
                        borderRadius: 10,
                        padding: EdgeInsets.all(size.width * 0.025),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.5,
                                      child: MyText(
                                        text:
                                        promoCodeDataList[index].code,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(),
                                        maxLines: 2,
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          if (promoCodeDataList[index]
                                              .isApplied ==
                                              true) {
                                            context.read<AccBloc>().add(
                                                PromoCodeClearEvent(
                                                    from: '2'));
                                          } else {
                                            context.read<AccBloc>().add(
                                                SelectPromoCodeListApplyEvent(
                                                    selectedPromoCode:
                                                    promoCodeDataList[
                                                    index]
                                                        .code,
                                                    price: promoCodeDataList[
                                                    index]
                                                        .maximumDiscountAmount
                                                        .toString()));
                                          }
                                        },
                                        child: Container(
                                            width: size.width * 0.325,
                                            padding: EdgeInsets.all(
                                                size.width * 0.02),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    6),
                                                border: Border.all(
                                                    width: 1,
                                                    color: (promoCodeDataList[
                                                    index]
                                                        .isApplied ==
                                                        true)
                                                        ? AppColors.red
                                                        : Theme.of(
                                                        context)
                                                        .primaryColor)),
                                            child: MyText(
                                              text: (promoCodeDataList[
                                              index]
                                                  .isApplied ==
                                                  true)
                                                  ? AppLocalizations.of(
                                                  context)!
                                                  .remove
                                                  : AppLocalizations.of(
                                                  context)!
                                                  .apply,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                  color: (promoCodeDataList[
                                                  index]
                                                      .isApplied ==
                                                      true)
                                                      ? AppColors.red
                                                      : Theme.of(
                                                      context)
                                                      .primaryColor),
                                              textAlign: TextAlign.center,
                                            )))
                                  ],
                                ),
                                MyText(
                                  text: AppLocalizations.of(context)!
                                      .saveUptoText
                                      .replaceAll('111',
                                      '$currencySymbol${promoCodeDataList[index].maximumDiscountAmount.toString()}'),
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: AppColors.green),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: size.width * 0.025,
                                  bottom: size.width * 0.025),
                              child: Container(
                                width: size.width,
                                height: size.width * 0.005,
                                color: AppColors.surfaceBorder(context),
                              ),
                            ),
                            MyText(
                              text: AppLocalizations.of(context)!
                                  .promoInfoText
                                  .replaceAll('111',
                                  promoCodeDataList[index].code)
                                  .replaceAll('222',
                                  '$currencySymbol${promoCodeDataList[index].maximumDiscountAmount}')
                                  .replaceAll('333',
                                  '$currencySymbol${promoCodeDataList[index].minimumTripAmount}'),
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                  color: Theme.of(context).hintColor),
                              maxLines: 3,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
              : SizedBox(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * 0.08,
                  ),
                  Image.asset(
                    AppImages.noDataFound,
                    height: 200,
                    width: 200,
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Text(AppLocalizations.of(context)!.noDataAvailable),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}