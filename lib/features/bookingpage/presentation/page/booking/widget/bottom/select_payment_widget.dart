// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/utils/custom_snack_bar.dart';
import '../../../../../../../core/utils/custom_text.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../application/booking_bloc.dart';

class SelectPaymentMethodWidget extends StatelessWidget {
  final BuildContext cont;
  const SelectPaymentMethodWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<BookingBloc>(),
      child: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          return SafeArea(
            child: Container(
              width: size.width,
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(size.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 TOP HEADER (Fixed)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.01,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(
                            text: AppLocalizations.of(context)!.paymentMethods,
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.close_rounded,
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // const Divider(height: 1),

                    /// 🔹 CASH SECTION
                    if (context
                        .read<BookingBloc>()
                        .paymentList
                        .contains('cash'))
                      _paymentSectionTitle(
                          AppLocalizations.of(context)!.others),
                    if (context
                        .read<BookingBloc>()
                        .paymentList
                        .contains('cash'))
                      _bigPaymentCard(
                        context: context,
                        size: size,
                        value: 'cash',
                        icon: Icons.payments_outlined,
                        title: AppLocalizations.of(context)!.cash,
                      ),

                    // const SizedBox(height: 10),

                    /// 🔹 ONLINE / CARD
                    if (context
                            .read<BookingBloc>()
                            .paymentList
                            .contains('online') ||
                        context
                            .read<BookingBloc>()
                            .paymentList
                            .contains('card'))
                      _paymentSectionTitle(
                          AppLocalizations.of(context)!.onlinePayment),

                    if (context
                        .read<BookingBloc>()
                        .paymentList
                        .contains('online'))
                      _bigPaymentCard(
                        context: context,
                        size: size,
                        value: 'online',
                        icon: Icons.qr_code_rounded,
                        title: AppLocalizations.of(context)!.online,
                      ),

                    if (context
                        .read<BookingBloc>()
                        .paymentList
                        .contains('card'))
                      _bigPaymentCard(
                        context: context,
                        size: size,
                        value: 'card',
                        icon: Icons.credit_card,
                        title: AppLocalizations.of(context)!.card,
                      ),

                    if (context
                            .read<BookingBloc>()
                            .userData!
                            .showWalletFeatureOnMobileApp ==
                        '1') ...[
                      /// 🔹 WALLET SECTION
                      if (context
                          .read<BookingBloc>()
                          .paymentList
                          .contains('wallet'))
                        _paymentSectionTitle(
                            AppLocalizations.of(context)!.walletOption),

                      if (context
                          .read<BookingBloc>()
                          .paymentList
                          .contains('wallet'))
                        _walletCard(context, size),
                    ],

                    //  const SizedBox(height: 10),

                    /// 🔹 SAVED CARDS
                    if (context
                        .read<BookingBloc>()
                        .savedCardList
                        .isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _paymentSectionTitle(
                          AppLocalizations.of(context)!.saveCards),
                      ...List.generate(
                        context.read<BookingBloc>().savedCardList.length,
                        (index) {
                          final card =
                              context.read<BookingBloc>().savedCardList[index];

                          return _savedCardModern(
                            context: context,
                            size: size,
                            card: card,
                          );
                        },
                      )
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

//
Widget _paymentSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
        letterSpacing: 0.5,
      ),
    ),
  );
}

//
Widget _bigPaymentCard({
  required BuildContext context,
  required Size size,
  required String value,
  required IconData icon,
  required String title,
}) {
  final bloc = context.read<BookingBloc>();
  final isSelected = bloc.selectedPaymentType == value;

  return GestureDetector(
    onTap: () {
      bloc.selectedCardToken = '';
      bloc.isSavedCardChoose = false;

      if (value == 'wallet') {
        if (bloc.userData!.wallet.data.amountBalance > bloc.selectedEtaAmount) {
          bloc.selectedPaymentType = value;
          bloc.add(UpdateEvent());
          Navigator.pop(context);
        } else {
          showToast(message: AppLocalizations.of(context)!.lowWalletBalance);
        }
      } else {
        bloc.selectedPaymentType = value;
        bloc.add(UpdateEvent());
        Navigator.pop(context);
      }
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isSelected
            ? Theme.of(context).scaffoldBackgroundColor
            : Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(
          color: isSelected
              ? Theme.of(context).scaffoldBackgroundColor
              : Theme.of(context).scaffoldBackgroundColor,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 28,
            color: value == 'cash'
                ? const Color(0xFF16A34A)
                : Theme.of(context).primaryColorDark,
          ),
          SizedBox(width: size.width * 0.05),
          Expanded(
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.radio_button_checked,
            color: isSelected
                ? Theme.of(context).primaryColor
                : const Color.fromARGB(255, 196, 195, 195),
          ),
        ],
      ),
    ),
  );
}

//
Widget _walletCard(BuildContext context, Size size) {
  final bloc = context.read<BookingBloc>();
  final isSelected = bloc.selectedPaymentType == 'wallet';

  return GestureDetector(
    onTap: () {
      if (bloc.userData!.wallet.data.amountBalance > bloc.selectedEtaAmount) {
        bloc.selectedPaymentType = 'wallet';
        bloc.selectedCardToken = '';
        bloc.isSavedCardChoose = false;
        bloc.add(UpdateEvent());
        Navigator.pop(context);
      } else {
        showToast(message: AppLocalizations.of(context)!.lowWalletBalance);
      }
    },
    child: Container(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isSelected
            ? Theme.of(context).scaffoldBackgroundColor
            : Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(
          color: isSelected
              ? Theme.of(context).scaffoldBackgroundColor
              : Theme.of(context).scaffoldBackgroundColor,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.account_balance_wallet_outlined,
              size: 28, color: Theme.of(context).primaryColorDark),
          SizedBox(width: size.width * 0.05),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.wallet,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  "${bloc.userData!.wallet.data.currencySymbol} ${bloc.userData!.wallet.data.amountBalance}",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Icon(
            Icons.radio_button_checked,
            color: isSelected
                ? Theme.of(context).primaryColor
                : const Color.fromARGB(255, 196, 195, 195),
          ),
        ],
      ),
    ),
  );
}

//
Widget _savedCardModern({
  required BuildContext context,
  required Size size,
  required dynamic card,
}) {
  final bloc = context.read<BookingBloc>();
  final isSelected = bloc.selectedPaymentType == card.url;

  return GestureDetector(
    onTap: () {
      bloc.selectedPaymentType = card.url;
      bloc.selectedCardToken = card.url;
      bloc.isSavedCardChoose = true;
      bloc.add(UpdateEvent());
      Navigator.pop(context);
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isSelected
            ? Theme.of(context).scaffoldBackgroundColor
            : Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Row(
        children: [
          Icon(
            Icons.payment_rounded,
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade700,
          ),
          SizedBox(width: size.width * 0.05),
          Expanded(
            child: Text(
              "**** **** **** ${card.gateway}",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Icon(
            Icons.radio_button_checked,
            color: isSelected
                ? Theme.of(context).primaryColor
                : const Color.fromARGB(255, 196, 195, 195),
          ),
        ],
      ),
    ),
  );
}
