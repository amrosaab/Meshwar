import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../../../../common/local_data.dart';
import '../../../../../../../core/utils/custom_appbar.dart';
import '../../../../../../../core/utils/custom_button.dart';
import '../../../../../../../core/utils/custom_text.dart';
import '../../../../../../../core/utils/custom_textfield.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../application/booking_bloc.dart';

class SelectCancelReasonList extends StatelessWidget {
  const SelectCancelReasonList({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.viewInsetsOf(context).bottom),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomAppBar(
                      title: 'Cancel Reason',
                      automaticallyImplyLeading: true,
                      titleFontSize: 18,
                    ),
                    SizedBox(height: size.width * 0.05),
                    SizedBox(
                        width: size.width,
                        child: MyText(
                          text:
                              AppLocalizations.of(context)!.selectCancelReason,
                          textStyle:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: 16,
                                  ),
                          maxLines: 2,
                        )),
                    SizedBox(height: size.width * 0.05),
                    ListView.builder(
                        itemCount: context
                            .read<BookingBloc>()
                            .cancelReasonsList
                            .length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final reason = context
                              .read<BookingBloc>()
                              .cancelReasonsList
                              .elementAt(index);
                          final bookingBloc = context.read<BookingBloc>();
                          final isSelected =
                              bookingBloc.selectedCancelReason == reason.reason;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: CheckboxListTile(
                              value: isSelected,
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: Theme.of(context).primaryColorDark,
                              onChanged: (checked) {
                                final bloc = context.read<BookingBloc>();
                                if (checked ?? false) {
                                  bloc
                                    ..selectedCancelReason = reason.reason
                                    ..selectedCancelReasonId = reason.id;
                                } else {
                                  bloc
                                    ..selectedCancelReason = ''
                                    ..selectedCancelReasonId = '';
                                }

                                printWrapped(bloc.selectedCancelReasonId);
                                bloc.add(UpdateEvent());
                              },
                              title: MyText(
                                text: reason.reason,
                                maxLines: 2,
                                textStyle:
                                    Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          );
                        }),
                    CustomTextField(
                      controller:
                          context.read<BookingBloc>().otherReasonController,
                      maxLine: 5,
                      filled: true,
                      hintText: AppLocalizations.of(context)!.otherReason,
                      onChange: (value) {
                        final bloc = context.read<BookingBloc>();
                        if (value.isNotEmpty) {
                          bloc
                            ..selectedCancelReason = 'Others'
                            ..selectedCancelReasonId = '';
                        } else {
                          bloc
                            ..selectedCancelReason = ''
                            ..selectedCancelReasonId = '';
                        }
                        bloc.add(UpdateEvent());
                      },
                    ),
                    SizedBox(height: size.width * 0.05),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: size.width,
                    height: size.width * 0.2,
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor),
                    child: Center(
                      child: CustomButton(
                          buttonName: AppLocalizations.of(context)!.cancelRide,
                          width: size.width,
                          textSize: 18,
                          buttonColor: (context
                                  .read<BookingBloc>()
                                  .selectedCancelReason
                                  .isNotEmpty)
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).primaryColorLight,
                          onTap: () {
                            if ((context
                                        .read<BookingBloc>()
                                        .selectedCancelReason
                                        .isNotEmpty &&
                                    context
                                            .read<BookingBloc>()
                                            .selectedCancelReason !=
                                        'Others') ||
                                ((context
                                            .read<BookingBloc>()
                                            .selectedCancelReason ==
                                        'Others') &&
                                    (context
                                        .read<BookingBloc>()
                                        .otherReasonController
                                        .text
                                        .isNotEmpty))) {
                              Navigator.pop(context);
                              context.read<BookingBloc>().add(
                                    BookingCancelRequestEvent(
                                        requestId: context
                                            .read<BookingBloc>()
                                            .requestData!
                                            .id,
                                        reason: context
                                            .read<BookingBloc>()
                                            .selectedCancelReasonId,
                                        customReason: context
                                            .read<BookingBloc>()
                                            .otherReasonController
                                            .text),
                                  );
                              context.read<BookingBloc>().add(
                                  TripRideCancelEvent(isCancelByDriver: false));
                            }
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
