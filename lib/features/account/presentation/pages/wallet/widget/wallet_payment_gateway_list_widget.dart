import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';
import '../../../../domain/models/walletpage_model.dart';

class WalletPaymentGatewayListWidget extends StatelessWidget {
  final BuildContext cont;
  final List<PaymentGateway> walletPaymentGatways;
  const WalletPaymentGatewayListWidget(
      {super.key, required this.cont, required this.walletPaymentGatways});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<AccBloc>(),
      child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
        return walletPaymentGatways.isNotEmpty
            ? SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.width * 0.05),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.02),
                    child: MyText(
                      text: AppLocalizations.of(context)!
                          .choosePaymentMethods,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: size.width * 0.05),
                  ListView.builder(
                    itemCount: walletPaymentGatways.length,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      return (walletPaymentGatways[index].enabled == true)
                          ? InkWell(
                        onTap: () {
                          context.read<AccBloc>().add(
                              PaymentOnTapEvent(
                                  selectedPaymentIndex: index));
                        },
                        child: Container(
                          padding:
                          EdgeInsets.all(size.width * 0.04),
                          margin: EdgeInsets.only(
                              bottom: size.width * 0.03),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                width: (context
                                    .read<AccBloc>()
                                    .choosenPaymentIndex ==
                                    index)
                                    ? 1
                                    : 1.5,
                                color: (context
                                    .read<AccBloc>()
                                    .choosenPaymentIndex ==
                                    index)
                                    ? Theme.of(context).primaryColor
                                    : AppColors.surfaceBorder(
                                    context)),
                          ),
                          child: Row(
                            children: [
                              // Icon/Image Container
                              Container(
                                width: size.width * 0.12,
                                height: size.width * 0.12,
                                decoration: BoxDecoration(
                                  color: AppColors.surface(context),
                                  borderRadius:
                                  BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.all(
                                    size.width * 0.02),
                                child: walletPaymentGatways[index]
                                    .isCard
                                    ? _getCardImage(
                                    walletPaymentGatways[index]
                                        .image,
                                    size)
                                    : CachedNetworkImage(
                                  imageUrl:
                                  walletPaymentGatways[
                                  index]
                                      .image,
                                  fit: BoxFit.contain,
                                  placeholder:
                                      (context, url) =>
                                  const Center(
                                    child: Loader(),
                                  ),
                                  errorWidget:
                                      (context, url, error) =>
                                  const Icon(
                                      Icons.payment,
                                      size: 24),
                                ),
                              ),
                              SizedBox(width: size.width * 0.04),
                              // Payment Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                      text: walletPaymentGatways[
                                      index]
                                          .isCard
                                          ? walletPaymentGatways[
                                      index]
                                          .gateway
                                          .toString()
                                          : walletPaymentGatways[
                                      index]
                                          .gateway
                                          .toString(),
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                        color: Theme.of(context)
                                            .primaryColorDark,
                                        fontWeight:
                                        FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    if (walletPaymentGatways[index]
                                        .isCard)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.width * 0.01),
                                        child: MyText(
                                          text:
                                          '**** **** **** ${walletPaymentGatways[index].gateway.toString().substring(walletPaymentGatways[index].gateway.toString().length >= 4 ? walletPaymentGatways[index].gateway.toString().length - 4 : 0)}',
                                          textStyle:
                                          Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                            color: AppColors
                                                .hintColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              // Radio Button
                              Container(
                                width: size.width * 0.06,
                                height: size.width * 0.06,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (context
                                      .read<AccBloc>()
                                      .choosenPaymentIndex ==
                                      index)
                                      ? Theme.of(context)
                                      .primaryColor
                                      : Colors.transparent,
                                  border: Border.all(
                                    width: 2,
                                    color: (context
                                        .read<AccBloc>()
                                        .choosenPaymentIndex ==
                                        index)
                                        ? Theme.of(context)
                                        .primaryColor
                                        : Theme.of(context)
                                        .disabledColor
                                        .withAlpha((0.5 * 255)
                                        .toInt()),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: (context
                                    .read<AccBloc>()
                                    .choosenPaymentIndex ==
                                    index)
                                    ? Container(
                                  width: size.width * 0.03,
                                  height: size.width * 0.03,
                                  decoration:
                                  const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.white,
                                  ),
                                )
                                    : const SizedBox(),
                              ),
                            ],
                          ),
                        ),
                      )
                          : const SizedBox();
                    },
                  ),
                  SizedBox(height: size.width * 0.05),
                  CustomButton(
                      buttonName: AppLocalizations.of(context)!.pay,
                      width: size.width,
                      onTap: () async {
                        Navigator.pop(context);
                        if (!walletPaymentGatways[context
                            .read<AccBloc>()
                            .choosenPaymentIndex!]
                            .isCard) {
                          context
                              .read<AccBloc>()
                              .add(
                              WalletPageReUpdateEvent(
                                  currencySymbol: context
                                      .read<AccBloc>()
                                      .walletResponse!
                                      .currencySymbol,
                                  from: '',
                                  requestId: '',
                                  money: context
                                      .read<AccBloc>()
                                      .addMoney
                                      .toString(),
                                  url: walletPaymentGatways[context
                                      .read<AccBloc>()
                                      .choosenPaymentIndex!]
                                      .url,
                                  userId: context
                                      .read<AccBloc>()
                                      .userData!
                                      .id
                                      .toString()));
                        } else {
                          context.read<AccBloc>().add(
                              AddMoneyFromCardEvent(
                                  amount: context
                                      .read<AccBloc>()
                                      .addMoney
                                      .toString(),
                                  cardToken: walletPaymentGatways[context
                                      .read<AccBloc>()
                                      .choosenPaymentIndex!]
                                      .url));
                        }
                      }),
                  SizedBox(height: size.width * 0.1)
                ],
              ),
            ),
          ),
        )
            : const SizedBox();
      }),
    );
  }

  Widget _getCardImage(String imageString, Size size) {
    final imageLower = imageString.toLowerCase();

    if (imageLower.contains('visa')) {
      return Image.asset(AppImages.visa, fit: BoxFit.contain);
    } else if (imageLower.contains('eftpos')) {
      return Image.asset(AppImages.eftpos, fit: BoxFit.contain);
    } else if (imageLower.contains('american')) {
      return Image.asset(AppImages.americanExpress, fit: BoxFit.contain);
    } else if (imageLower.contains('jcb')) {
      return Image.asset(AppImages.jcb, fit: BoxFit.contain);
    } else if (imageLower.contains('discover') ||
        imageLower.contains('dinners')) {
      return Image.asset(AppImages.discover, fit: BoxFit.contain);
    } else {
      return Image.asset(AppImages.master, fit: BoxFit.contain);
    }
  }
}