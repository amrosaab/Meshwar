import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../../common/common.dart';
import '../../../../../../common/liquid_glass_container.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';
import '../../../../domain/models/walletpage_model.dart';

class WalletHistoryDataWidget extends StatelessWidget {
  final BuildContext cont;
  final List<WalletHistoryData> walletHistoryList;
  const WalletHistoryDataWidget(
      {super.key, required this.cont, required this.walletHistoryList});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<AccBloc>(),
      child: BlocBuilder<AccBloc, AccState>(
        builder: (context, state) {
          return walletHistoryList.isNotEmpty
              ? LiquidGlassContainer(
            borderRadius: 10,
            child: RawScrollbar(
              radius: const Radius.circular(20),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: walletHistoryList.length,
                itemBuilder: (context, index) {
                  final item = walletHistoryList[index];
                  final isDebit = item.isCredit == 0;
                  final currency = context
                      .read<AccBloc>()
                      .walletResponse
                      ?.currencySymbol ??
                      '';
                  final amountText = NumberFormat.currency(
                    locale: 'en_IN',
                    symbol: '',
                    decimalDigits: 2,
                  ).format(double.tryParse(item.amount.toString()) ?? 0);
                  return Column(
                    children: [
                      Container(
                        width: size.width,
                        margin:
                        EdgeInsets.only(bottom: size.width * 0.030),
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.035,
                          vertical: size.width * 0.03,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: size.width * 0.1,
                              width: size.width * 0.1,
                              decoration: const BoxDecoration(
                                color: AppColors.goldenColor,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: (item.remarks == 'Money Deposited')
                                  ? Image.asset(
                                AppImages.favLocNoData,
                                fit: BoxFit.contain,
                                width: size.width * 0.055,
                                color: AppColors.black,
                              )
                                  : Image.asset(
                                AppImages.favLocNoData,
                                fit: BoxFit.contain,
                                width: size.width * 0.055,
                                color: AppColors.black,
                              ),
                            ),
                            SizedBox(width: size.width * 0.035),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.6,
                                    child: MyText(
                                      text: item.remarks,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontSize: 16),
                                      maxLines: 2,
                                    ),
                                  ),
                                  SizedBox(height: size.width * 0.01),
                                  MyText(
                                    text: item.createdAt,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                        color: AppColors.hintColor,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            MyText(
                              text:
                              '${isDebit ? '- ' : ''}$currency $amountText',
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                  color: isDebit
                                      ? AppColors.red
                                      : AppColors.green,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      if (index != walletHistoryList.length - 1)
                        Container(
                          height: size.width * 0.001,
                          width: size.width,
                          color: AppColors.surfaceBorder(context),
                        )
                    ],
                  );
                },
              ),
            ),
          )
              : Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LiquidGlassContainer(
                    circular: true,
                    width: 148,
                    height: 148,
                    blurSigma: 14,
                    fillOpacity: 0.1,
                    child: Center(
                      child: Image.asset(
                        AppImages.walletNoData,
                        height: 92,
                        width: 92,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  MyText(
                    text:
                    AppLocalizations.of(context)!.paymenyHistoryEmpty,
                    textStyle: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  MyText(
                    text: AppLocalizations.of(context)!
                        .paymenyHistoryEmptyText,
                    textAlign: TextAlign.center,
                    textStyle:
                    Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.greyHintColor,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
