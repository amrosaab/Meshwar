import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/app_images.dart';
import '../../../../application/acc_bloc.dart';
import '../../../../domain/models/walletpage_model.dart';
import 'wallet_payment_content.dart';

class WalletPaymentGatewayListWidget extends StatelessWidget {
  final BuildContext cont;
  final List<PaymentGateway> walletPaymentGatways;
  const WalletPaymentGatewayListWidget(
      {super.key, required this.cont, required this.walletPaymentGatways});

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: cont.read<AccBloc>(),
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          final bloc = context.read<AccBloc>();
          final index = bloc.choosenPaymentIndex;
          return Directionality(
              textDirection: bloc.textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: WalletPaymentMethodSheet(
                gateways: walletPaymentGatways,
                selected: index,
                currency: bloc.walletResponse?.currencySymbol ?? '',
                amount: bloc.walletAmountController.text,
                cardImage: (image) =>
                    _getCardImage(image, MediaQuery.sizeOf(context)),
                onSelect: (value) =>
                    bloc.add(PaymentOnTapEvent(selectedPaymentIndex: value)),
                onPay: () {
                  if (index == null ||
                      index < 0 ||
                      index >= walletPaymentGatways.length ||
                      !walletPaymentGatways[index].enabled ||
                      bloc.walletResponse == null ||
                      bloc.userData == null ||
                      bloc.addMoney == null ||
                      (!bloc.addMoney!.isFinite || bloc.addMoney! <= 0)) {
                    return;
                  }
                  final gateway = walletPaymentGatways[index];
                  Navigator.pop(context);
                  if (gateway.isCard) {
                    bloc.add(AddMoneyFromCardEvent(
                        amount: bloc.addMoney.toString(),
                        cardToken: gateway.url));
                  } else {
                    bloc.add(WalletPageReUpdateEvent(
                        currencySymbol: bloc.walletResponse!.currencySymbol,
                        from: '',
                        requestId: '',
                        money: bloc.addMoney.toString(),
                        url: gateway.url,
                        userId: bloc.userData!.id.toString()));
                  }
                },
              ));
        }),
      );

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
