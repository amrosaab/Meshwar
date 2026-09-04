import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/app_colors.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';

class PickContact extends StatelessWidget {
  const PickContact({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<AccBloc, AccState>(
      builder: (context, state) {
        return Scaffold(
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
              child: SingleChildScrollView(
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
                    SizedBox(
                      height: size.height * 0.73,
                      child: RawScrollbar(
                        child: ListView.builder(
                          itemCount:
                          context.read<AccBloc>().contactsList.length,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 16),
                          itemBuilder: (context, index) {
                            final contact = context
                                .read<AccBloc>()
                                .contactsList
                                .elementAt(index);
                            return RadioListTile(
                              value: contact,
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              controlAffinity: ListTileControlAffinity.trailing,
                              activeColor: Theme.of(context).primaryColorDark,
                              groupValue:
                              context.read<AccBloc>().selectedContact,
                              onChanged: (value) {
                                context.read<AccBloc>().selectedContact =
                                    contact;
                                context.read<AccBloc>().add(AccUpdateEvent());
                              },
                              title: MyText(text: contact.name, maxLines: 2),
                              subtitle:
                              MyText(text: contact.number, maxLines: 1),
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
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: AppColors.surfaceShadow(context)),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.viewInsetsOf(context).bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: size.width * 0.03),
                  CustomButton(
                    width: size.width,
                    buttonColor: Theme.of(context).primaryColor,
                    buttonName: AppLocalizations.of(context)!.confirm,
                    onTap: () {
                      context.read<AccBloc>().add(
                        AddContactEvent(
                          name:
                          context.read<AccBloc>().selectedContact.name,
                          number: context
                              .read<AccBloc>()
                              .selectedContact
                              .number,
                        ),
                      );
                      context.read<AccBloc>().add(SosLoadingEvent());
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: size.width * 0.15),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}