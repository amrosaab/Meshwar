import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_snack_bar.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../core/utils/custom_textfield.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../home/domain/models/stop_address_model.dart';
import '../../../../application/booking_bloc.dart';

// Instruction
class DeliveryInstructions extends StatelessWidget {
  final BuildContext cont;
  final AddressModel address;
  final String name;
  final String number;
  final bool isReceiveParcel;
  final String transportType;
  const DeliveryInstructions(
      {super.key,
      required this.address,
      required this.name,
      required this.number,
      required this.isReceiveParcel,
      required this.transportType,
      required this.cont});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider.value(
      value: cont.read<BookingBloc>(),
      child: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          final bookingBloc = context.read<BookingBloc>();
          return SafeArea(
            child: Container(
              width: size.width,
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: size.width * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          text: isReceiveParcel
                              ? AppLocalizations.of(context)!.senderDetails
                              : AppLocalizations.of(context)!.receiverDetails,
                          textStyle:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                        ),
                        InkWell(
                          onTap: () {
                            bookingBloc.add(SelectContactDetailsEvent());
                          },
                          child: Icon(Icons.contacts,
                              color: Theme.of(context).primaryColorDark),
                        )
                      ],
                    ),
                    Theme(
                      data: ThemeData(
                        unselectedWidgetColor:
                            Theme.of(context).primaryColorDark,
                      ),
                      child: ListTileTheme(
                        horizontalTitleGap: 0.0,
                        contentPadding: EdgeInsets.zero,
                        child: CheckboxListTile(
                          value: bookingBloc.isMyself,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (value) {
                            if (value != null) {
                              bookingBloc.add(ReceiverContactEvent(
                                  name: value ? name : '',
                                  number: value ? number : '',
                                  isReceiveMyself: value));
                              bookingBloc.isMyself = value;
                            }
                            bookingBloc.add(UpdateEvent());
                          },
                          title: MyText(
                              text: isReceiveParcel
                                  ? AppLocalizations.of(context)!.sendMyself
                                  : AppLocalizations.of(context)!.receiveMyself,
                              textStyle:
                                  Theme.of(context).textTheme.bodyMedium),
                        ),
                      ),
                    ),
                    if (isReceiveParcel) SizedBox(height: size.width * 0.05),
                    CustomTextField(
                      controller: bookingBloc.receiverNameController,
                      filled: true,
                      hintText: AppLocalizations.of(context)!.name,
                      maxLine: 1,
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: size.width * 0.03),
                    CustomTextField(
                      controller: bookingBloc.receiverMobileController,
                      filled: true,
                      hintText: AppLocalizations.of(context)!.mobileNumber,
                      maxLine: 1,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: size.width * 0.03),
                    CustomTextField(
                      controller: bookingBloc.instructionsController,
                      filled: true,
                      hintText:
                          '${AppLocalizations.of(context)!.instructions}(${AppLocalizations.of(context)!.optional})',
                      maxLine: 3,
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: size.width * 0.03),
                    CustomButton(
                      width: size.width,
                      buttonColor: Theme.of(context).primaryColor,
                      buttonName: AppLocalizations.of(context)!.confirm,
                      onTap: () {
                        if (bookingBloc
                            .receiverMobileController.text.isNotEmpty) {
                          address.name =
                              bookingBloc.receiverNameController.text;
                          address.number =
                              bookingBloc.receiverMobileController.text;
                          address.instructions =
                              bookingBloc.instructionsController.text;
                          bookingBloc.add(BookingAddOrEditStopAddressEvent(
                            choosenAddressIndex:
                                bookingBloc.choosenAddressIndex,
                            newAddress: address,
                          ));
                          bookingBloc.receiverMobileController.clear();
                          bookingBloc.receiverNameController.clear();
                          bookingBloc.instructionsController.clear();
                          bookingBloc.isMyself = false;
                          Navigator.pop(context, '');
                        } else {
                          showToast(
                              message: AppLocalizations.of(context)!
                                  .enterTheCredentials);
                        }
                      },
                    ),
                    SizedBox(height: size.width * 0.1),
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
