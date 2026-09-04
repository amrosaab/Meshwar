import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_snack_bar.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/home_bloc.dart';
import '../../domain/models/stop_address_model.dart';

// Instruction
class LeaveInstructions extends StatelessWidget {
  final BuildContext cont;
  final AddressModel address;
  final String name;
  final String number;
  final bool isReceiveParcel;
  final String transportType;
  const LeaveInstructions(
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
      value: cont.read<HomeBloc>(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
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
                          context
                              .read<HomeBloc>()
                              .add(SelectContactDetailsEvent());
                        },
                        child: Icon(Icons.contacts,
                            color: Theme.of(context).primaryColorDark),
                      )
                    ],
                  ),
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: Theme.of(context).primaryColorDark,
                    ),
                    child: ListTileTheme(
                      horizontalTitleGap: 0.0,
                      contentPadding: EdgeInsets.zero,
                      child: CheckboxListTile(
                        value: context.read<HomeBloc>().isMyself,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (value) {
                          if (value != null) {
                            context.read<HomeBloc>().add(ReceiverContactEvent(
                                name: value ? name : '',
                                number: value ? number : '',
                                isReceiveMyself: value));
                            context.read<HomeBloc>().isMyself = value;
                          }
                          context.read<HomeBloc>().add(UpdateEvent());
                        },
                        title: MyText(
                            text: isReceiveParcel
                                ? AppLocalizations.of(context)!.sendMyself
                                : AppLocalizations.of(context)!.receiveMyself,
                            textStyle: Theme.of(context).textTheme.bodyMedium),
                      ),
                    ),
                  ),
                  if (isReceiveParcel) SizedBox(height: size.width * 0.05),
                  CustomTextField(
                    controller: context.read<HomeBloc>().receiverNameController,
                    filled: true,
                    hintText: AppLocalizations.of(context)!.name,
                    maxLine: 1,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: size.width * 0.03),
                  CustomTextField(
                    controller:
                        context.read<HomeBloc>().receiverMobileController,
                    filled: true,
                    hintText: AppLocalizations.of(context)!.mobileNumber,
                    maxLine: 1,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: size.width * 0.03),
                  CustomTextField(
                    controller: context.read<HomeBloc>().instructionsController,
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
                      if (context
                          .read<HomeBloc>()
                          .receiverMobileController
                          .text
                          .isNotEmpty) {
                        address.name = context
                            .read<HomeBloc>()
                            .receiverNameController
                            .text;
                        address.number = context
                            .read<HomeBloc>()
                            .receiverMobileController
                            .text;
                        address.instructions = context
                            .read<HomeBloc>()
                            .instructionsController
                            .text;
                        context.read<HomeBloc>().add(AddOrEditStopAddressEvent(
                              isPickUpEdit: false,
                              choosenAddressIndex:
                                  context.read<HomeBloc>().choosenAddressIndex,
                              newAddress: address,
                            ));
                        if (!context
                            .read<HomeBloc>()
                            .addressList
                            .any((element) => element.address.isEmpty)) {
                          context.read<HomeBloc>().add(ConfirmRideAddressEvent(
                              rideType: transportType,
                              addressList:
                                  context.read<HomeBloc>().addressList));
                        }
                        context
                            .read<HomeBloc>()
                            .receiverMobileController
                            .clear();
                        context.read<HomeBloc>().receiverNameController.clear();
                        context.read<HomeBloc>().instructionsController.clear();
                        context.read<HomeBloc>().isMyself = false;
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
          );
        },
      ),
    );
  }
}
