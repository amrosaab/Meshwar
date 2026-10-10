import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../application/booking_bloc.dart';
import 'cancel_reason_content.dart';

class SelectCancelReasonList extends StatelessWidget {
  const SelectCancelReasonList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(builder: (context, state) {
      final bloc = context.read<BookingBloc>();
      return CancelReasonContent(
        reasons: [
          for (final reason in bloc.cancelReasonsList)
            CancelReasonOption(id: reason.id, title: reason.reason),
        ],
        selectedId: bloc.selectedCancelReasonId,
        isCustom: bloc.selectedCancelReason == 'Others',
        otherController: bloc.otherReasonController,
        onBack: () => Navigator.of(context).pop(),
        onSelect: (reason) {
          bloc.otherReasonController.clear();
          bloc
            ..selectedCancelReason = reason.title
            ..selectedCancelReasonId = reason.id;
          bloc.add(UpdateEvent());
        },
        onOtherChanged: (value) {
          bloc
            ..selectedCancelReason = value.trim().isEmpty ? '' : 'Others'
            ..selectedCancelReasonId = '';
          bloc.add(UpdateEvent());
        },
        onCancel: bloc.requestData == null
            ? null
            : () {
                final custom = bloc.selectedCancelReason == 'Others';
                final customReason = bloc.otherReasonController.text.trim();
                if (custom
                    ? customReason.isEmpty
                    : bloc.selectedCancelReasonId.isEmpty) {
                  return;
                }
                final requestId = bloc.requestData?.id;
                if (requestId == null) return;
                Navigator.of(context).pop();
                bloc.add(BookingCancelRequestEvent(
                  requestId: requestId,
                  reason: custom ? '' : bloc.selectedCancelReasonId,
                  customReason: custom ? customReason : '',
                ));
                bloc.add(TripRideCancelEvent(isCancelByDriver: false));
              },
      );
    });
  }
}
