import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../application/acc_bloc.dart';
import 'transfer_money_content.dart';

class WalletTransferMoneyWidget extends StatelessWidget {
  final BuildContext cont;
  const WalletTransferMoneyWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: cont.read<AccBloc>(),
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          final bloc = context.read<AccBloc>();
          return Directionality(
              textDirection: bloc.textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: TransferMoneySheet(
                amountController: bloc.transferAmount,
                phoneController: bloc.transferPhonenumber,
                currency: bloc.walletResponse?.currencySymbol ?? '',
                role: bloc.dropdownValue,
                busy: bloc.isLoading,
                onRole: (value) => bloc.add(TransferMoneySelectedEvent(
                    selectedTransferAmountMenuItem: value)),
                onClose: () => Navigator.pop(context),
                onTransfer: () {
                  if (bloc.isLoading) return;
                  bloc.add(MoneyTransferedEvent(
                      transferAmount: bloc.transferAmount.text,
                      role: bloc.dropdownValue,
                      transferMobile: bloc.transferPhonenumber.text));
                  bloc.add(AccUpdateEvent());
                },
              ));
        }),
      );
}
