// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/app_colors.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_snack_bar.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/models/contact_model.dart';
import '../../../home/application/home_bloc.dart';
import 'contact_local_storage.dart';

// Select Contacts
class SelectFromContactList extends StatelessWidget {
  const SelectFromContactList({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: size.width,
                  height: size.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.glassBlueStrong.withOpacity(0.18),
                        AppColors.glassBlue.withOpacity(0.1),
                      ],
                    ),
                    border: Border.all(color: Colors.white.withOpacity(0.35)),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: size.width * 0.15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                  text:
                                  AppLocalizations.of(context)!.selectReceiver,
                                  textStyle: Theme.of(context).textTheme.bodyLarge),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: MyText(
                                    text: AppLocalizations.of(context)!.cancel,
                                    textStyle:
                                    Theme.of(context).textTheme.bodyLarge),
                              ),
                            ],
                          ),
                          SizedBox(height: size.width * 0.03),
                          SizedBox(
                            height: size.height * 0.73,
                            child: RawScrollbar(
                              child: ListView.builder(
                                itemCount:
                                context.read<HomeBloc>().contactsList.length,
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(bottom: 16),
                                itemBuilder: (context, index) {
                                  final contact = context
                                      .read<HomeBloc>()
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
                                      activeColor:
                                      Theme.of(context).primaryColorDark,
                                      controlAffinity:
                                      ListTileControlAffinity.trailing,
                                      groupValue:
                                      context.read<HomeBloc>().selectedContact,
                                      onChanged: (value) {
                                        context.read<HomeBloc>().selectedContact =
                                            contact;
                                        context.read<HomeBloc>().add(UpdateEvent());
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
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
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
                ),
              ),
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                  color: AppColors.surfaceStrong(context),
                  border: Border(top: BorderSide(color: AppColors.surfaceBorder(context))),
                  boxShadow: AppColors.surfaceShadow(context)),
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
                        final bloc = context.read<HomeBloc>();
                        final selected = bloc.selectedContact;

                        if (selected.number.isNotEmpty) {
                          // always set receiver details
                          bloc.receiverNameController.text = selected.name;
                          bloc.receiverMobileController.text = selected.number;

                          // save ONLY if coming from booking type flow
                          // if (bloc.isFromBookingTypeFlow) {
                          if (bloc.shouldSaveSelectedContact) {
                            await ContactLocalStorage.saveContact(selected);
                            await bloc.loadSavedContacts();
                            bloc.isFromBookingTypeFlow = false;
                            bloc.shouldSaveSelectedContact = false;
                          }

                          // reset selected contact
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