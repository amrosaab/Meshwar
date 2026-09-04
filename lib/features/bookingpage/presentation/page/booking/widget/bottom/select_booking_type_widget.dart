// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/utils/custom_button.dart';
import '../../../../../../../core/utils/custom_text.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../application/booking_bloc.dart';


class SelectBookingTypeWidget extends StatelessWidget {
  const SelectBookingTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider.value(
      value: context.read<BookingBloc>(),
      child: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is ConfirmBookingTypeSuccessState) {
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            final bloc = context.read<BookingBloc>();

            final bool isMyself = bloc.isMyselfSelected;
            final int? selectedIndex = bloc.selectedSavedContactIndex;

            return SafeArea(
              child: Container(
                width: size.width,
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  top: 16,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ================= TITLE =================
                      Center(
                        child: MyText(
                          text: 'Someone else taking this ride?',
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// ================= MYSELF =================
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          bloc.add(SelectMyselfRadioEvent());
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: isMyself
                                ? Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.08)
                                : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              Radio<bool>(
                                value: true,
                                groupValue: isMyself,
                                onChanged: (_) {
                                  bloc.add(SelectMyselfRadioEvent());
                                },
                              ),
                              const Icon(Icons.person),
                              const SizedBox(width: 8),
                              Text(
                                AppLocalizations.of(context)!.myself,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// ================= SAVED CONTACTS =================
                      if (bloc.savedContacts.isNotEmpty) ...[
                        const Text(
                          "Saved Contacts",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: bloc.savedContacts.length,
                          itemBuilder: (context, index) {
                            final contact = bloc.savedContacts[index];
                            final bool isSelected = selectedIndex == index;

                            return InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                bloc.add(SelectSavedContactRadioEvent(index));
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: isSelected
                                      ? Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.08)
                                      : Colors.transparent,
                                ),
                                child: Row(
                                  children: [
                                    Radio<int>(
                                      value: index,
                                      groupValue: selectedIndex,
                                      onChanged: (_) {
                                        bloc.add(SelectSavedContactRadioEvent(
                                            index));
                                      },
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(contact.name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600)),
                                          Text(contact.number,
                                              style: const TextStyle(
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      /// ================= CHOOSE CONTACT =================
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          bloc.add(SelectContactDetailsEvent());
                        },
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                          child: Row(
                            children: [
                              Icon(Icons.contacts),
                              SizedBox(width: 8),
                              Expanded(child: Text("Choose contact")),
                              Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// ================= CONFIRM =================
                      CustomButton(
                        width: size.width,
                        buttonColor: Theme.of(context).primaryColor,
                        buttonName: AppLocalizations.of(context)!.confirm,
                        onTap: () {
                          String name = "";
                          String mobile = "";

                          if (!isMyself && selectedIndex != null) {
                            final contact = bloc.savedContacts[selectedIndex];
                            name = contact.name;
                            mobile = contact.number;
                          }

                          bloc.add(
                            ConfirmBookingTypePageEvent(
                              contactName: name,
                              contactMobile: mobile,
                              isMyself: isMyself,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
