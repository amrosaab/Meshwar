import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../account/application/acc_bloc.dart';
import '../../../../../home/domain/models/user_details_model.dart';
import '../../../../application/booking_bloc.dart';

class PaymentGatewayListWidget extends StatelessWidget {
  final BuildContext cont;
  final InvoicePageArguments arg;
  final List<PaymentGatewayData> walletPaymentGatways;
  const PaymentGatewayListWidget(
      {super.key,
      required this.cont,
      required this.walletPaymentGatways,
      required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<AccBloc, AccState>(builder: (context, state) {
      return Column(
        children: [
          SizedBox(height: size.width * 0.05),
          Expanded(
            child: ListView.builder(
              itemCount: walletPaymentGatways.length,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (_, index) {
                return Column(
                  children: [
                    (walletPaymentGatways[index].enabled == true)
                        ? InkWell(
                            onTap: () {
                              context.read<AccBloc>().add(PaymentOnTapEvent(
                                  selectedPaymentIndex: index));
                            },
                            child: Container(
                              width: size.width * 0.9,
                              padding: EdgeInsets.all(size.width * 0.02),
                              margin:
                                  EdgeInsets.only(bottom: size.width * 0.025),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      width: 0.5,
                                      color: Theme.of(context)
                                          .primaryColorDark
                                          .withAlpha((0.5 * 255).toInt()))),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          padding:
                                              EdgeInsets.all(size.width * 0.05),
                                        ),
                                        MyText(
                                            text: walletPaymentGatways[index]
                                                .gateway
                                                .toString(),
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .primaryColorDark,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: size.width * 0.05,
                                    height: size.width * 0.05,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 1.5,
                                            color: Theme.of(context)
                                                .primaryColorDark)),
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: size.width * 0.03,
                                      height: size.width * 0.03,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: (context
                                                      .read<AccBloc>()
                                                      .choosenPaymentIndex ==
                                                  index)
                                              ? Theme.of(context)
                                                  .primaryColorDark
                                              : Colors.transparent),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Container(),
                  ],
                );
              },
            ),
          ),
          CustomButton(
              buttonName: AppLocalizations.of(context)!.pay,
              onTap: () async {
                Navigator.pop(context); // Use 'cont' instead of 'context'
                context.read<BookingBloc>().add(WalletPageReUpdateEvents(
                      currencySymbol: arg.requestData.requestedCurrencySymbol,
                      from: '1',
                      requestId: arg.requestData.id,
                      money: (arg.requestData.isBidRide == 1)
                          ? arg.requestBillData.driverTips != '0'
                              ? (double.parse(
                                          arg.requestData.acceptedRideFare) +
                                      double.parse(
                                          arg.requestBillData.driverTips))
                                  .toString()
                              : arg.requestData.acceptedRideFare
                          : arg.requestBillData.driverTips != '0'
                              ? (double.parse(
                                          arg.requestData.requestEtaAmount) +
                                      double.parse(
                                          arg.requestBillData.driverTips))
                                  .toString()
                              : arg.requestData.requestEtaAmount,
                      url: walletPaymentGatways[
                              context.read<AccBloc>().choosenPaymentIndex!]
                          .url,
                      userId: arg.requestData.userId.toString(),
                    ));
              }),
          SizedBox(height: size.width * 0.15)
        ],
      );
    });
  }
}
