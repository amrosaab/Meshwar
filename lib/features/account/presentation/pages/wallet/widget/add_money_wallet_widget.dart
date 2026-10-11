import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/app_colors.dart';
import '../../../../application/acc_bloc.dart';
import 'add_money_content.dart';
import 'wallet_payment_gateway_list_widget.dart';

class AddMoneyWalletWidget extends StatelessWidget {
  final BuildContext cont;
  final String minWalletAmount;
  const AddMoneyWalletWidget(
      {super.key, required this.cont, required this.minWalletAmount});

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: cont.read<AccBloc>(),
        child: BlocListener<AccBloc, AccState>(listener: (context, state) {
          if (state is PaymentUpdateState && state.status) {
            context.read<AccBloc>().showRefresh = true;
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
          }
        }, child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          final bloc = context.read<AccBloc>();
          return Directionality(
              textDirection: Directionality.of(context),
              child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(28)),
                  child: AddMoneyContent(
                    controller: bloc.walletAmountController,
                    currency: bloc.walletResponse?.currencySymbol ?? '',
                    balance: bloc.walletResponse?.walletBalance ?? '0',
                    onChanged: (amount) => bloc.addMoney = amount,
                    onNext: () {
                      final amount =
                          double.tryParse(bloc.walletAmountController.text);
                      if (amount == null || !amount.isFinite || amount <= 0) {
                        return;
                      }
                      bloc.addMoney = amount;
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          backgroundColor: AppColors.surface(context),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(28))),
                          clipBehavior: Clip.antiAlias,
                          builder: (_) => BlocProvider.value(
                              value: bloc,
                              child: WalletPaymentGatewayListWidget(
                                  cont: context,
                                  walletPaymentGatways:
                                      bloc.walletPaymentGatways)));
                    },
                  )));
        })),
      );
}
