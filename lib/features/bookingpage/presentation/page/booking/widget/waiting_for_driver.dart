import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/booking_bloc.dart';
import 'waiting_driver_content.dart';
import 'cancel_ride_confirmation_content.dart';

class WaitingForDriverConfirmation extends StatelessWidget {
  const WaitingForDriverConfirmation({super.key, required this.maximumTime});
  final double maximumTime;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(builder: (context, state) {
      final bloc = context.read<BookingBloc>();
      final l10n = AppLocalizations.of(context)!;
      final paymentType =
          bloc.isSavedCardChoose ? 'card' : bloc.selectedPaymentType;
      final paymentLabel = switch (paymentType) {
        'cash' => l10n.cash,
        'card' => l10n.card,
        'wallet' => l10n.wallet,
        _ => paymentType,
      };
      return WaitingDriverContent(
        remainingSeconds: bloc.timerDuration,
        maximumSeconds: maximumTime,
        stops: [
          for (final address in bloc.pickUpAddressList)
            WaitingRideStop(address: address.address, isPickup: true),
          for (final address in bloc.dropAddressList)
            WaitingRideStop(address: address.address),
        ],
        vehicleName: bloc.requestData?.vehicleTypeName,
        paymentLabel: paymentLabel,
        paymentIcon: switch (paymentType) {
          'cash' => Icons.payments_outlined,
          'card' => Icons.credit_card_rounded,
          _ => Icons.account_balance_wallet_outlined,
        },
        onCancel: () {
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            isScrollControlled: true,
            enableDrag: false,
            useSafeArea: true,
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            builder: (sheetContext) => CancelRideConfirmationContent(
              onKeepRide: () => Navigator.pop(sheetContext),
              onCancelRide: () {
                if (!context.mounted || bloc.requestData == null) {
                  Navigator.pop(sheetContext);
                  return;
                }
                bloc.timerCount(context,
                    duration: 0, isNormalRide: true, isCloseTimer: true);
                bloc.onRideBottomPosition = -250;
                bloc.add(
                    BookingCancelRequestEvent(requestId: bloc.requestData!.id));
              },
            ),
          );
        },
      );
    });
  }
}
