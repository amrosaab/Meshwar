// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/utils/custom_button.dart';
import '../../../../../../../core/utils/custom_snack_bar.dart';
import '../../../../../../../core/utils/custom_text.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../home/domain/models/contact_model.dart';
import '../../../../../application/booking_bloc.dart';

// Select Contacts
class SelectBookingContactList extends StatelessWidget {
  const SelectBookingContactList({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.width * 0.15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                            text: AppLocalizations.of(context)!.selectContact,
                            textStyle: Theme.of(context).textTheme.bodyLarge),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: MyText(
                              text: AppLocalizations.of(context)!.cancel,
                              textStyle: Theme.of(context).textTheme.bodyLarge),
                        ),
                      ],
                    ),
                    SizedBox(height: size.width * 0.03),
                    Expanded(
                      child: RawScrollbar(
                        child: ListView.builder(
                          itemCount:
                              context.read<BookingBloc>().contactsList.length,
                          shrinkWrap: false,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 24),
                          itemBuilder: (context, index) {
                            final contact = context
                                .read<BookingBloc>()
                                .contactsList
                                .elementAt(index);
                            return Theme(
                              data: ThemeData(
                                unselectedWidgetColor:
                                    Theme.of(context).primaryColorDark,
                              ),
                              child: RadioListTile(
                                value: contact,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                activeColor: Theme.of(context).primaryColorDark,
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                groupValue:
                                    context.read<BookingBloc>().selectedContact,
                                onChanged: (value) {
                                  context.read<BookingBloc>().selectedContact =
                                      contact;
                                  context
                                      .read<BookingBloc>()
                                      .add(UpdateEvent());
                                },
                                title: MyText(
                                  text: contact.name,
                                  maxLines: 2,
                                  textStyle:
                                      Theme.of(context).textTheme.bodyMedium,
                                ),
                                subtitle: MyText(
                                    text: contact.number,
                                    maxLines: 1,
                                    textStyle:
                                        Theme.of(context).textTheme.bodyMedium),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: size.width * 0.03),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 0),
                      spreadRadius: 2,
                      blurRadius: 2,
                      color: Theme.of(context).shadowColor,
                    )
                  ]),
              child: Padding(
                padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: size.width * 0.03),
                    CustomButton(
                      width: size.width,
                      buttonColor: Theme.of(context).primaryColor,
                      buttonName: AppLocalizations.of(context)!.confirm,
                      onTap: () async {
                        final bloc = context.read<BookingBloc>();
                        final selected = bloc.selectedContact;

                        if (selected.number.isNotEmpty) {
                          bloc.add(ConfirmBookingTypePageEvent(
                            contactName: selected.name,
                            contactMobile: selected.number,
                            isMyself: false,
                          ));

                          // reset selected contact for next time
                          bloc.selectedContact =
                              ContactsModel(name: '', number: '');

                          Navigator.pop(context);
                        } else {
                          showToast(
                            message: AppLocalizations.of(context)!
                                .pleaseSelectReceiver,
                          );
                        }
                      },
                    ),
                    SizedBox(height: size.width * 0.1),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
