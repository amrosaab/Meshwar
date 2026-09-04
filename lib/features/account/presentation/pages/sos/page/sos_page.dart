import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_appbar.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../core/utils/custom_textfield.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../auth/application/auth_bloc.dart';
import '../../../../../auth/presentation/widgets/select_country_widget.dart';
import '../../../../../home/domain/models/contact_model.dart';
import '../../../../application/acc_bloc.dart';
import '../widget/pick_contact.dart';
import '../widget/sos_card_shimmer.dart';
import '../widget/sos_detail_widget.dart';

class SosPage extends StatelessWidget {
  static const String routeName = '/sosPage';
  final SOSPageArguments arg;

  const SosPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => AccBloc()..add(SosInitEvent(arg: arg)),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is SelectContactDetailsState) {
            final accBloc = context.read<AccBloc>();
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              enableDrag: true,
              useRootNavigator: true,
              isScrollControlled: true,
              builder: (_) {
                return BlocProvider.value(
                  value: accBloc,
                  child: const PickContact(),
                );
              },
            );
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          final accBloc = context.watch<AccBloc>();
          return Scaffold(
              appBar: CustomAppBar(
                title: AppLocalizations.of(context)!.sos,
                automaticallyImplyLeading: true,
                onBackTap: () {
                  Navigator.pop(context, accBloc.sosdata);
                },
              ),
              body: SafeArea(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (accBloc.isSosLoading)
                        ListView.builder(
                          itemCount: 6,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return SosShimmerLoading(size: size);
                          },
                        ),
                      if (!accBloc.isSosLoading)
                        SosDetailWidget(
                            sosdata: accBloc.sosdata, cont: context),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: (accBloc.sosdata.length <= 4 &&
                  accBloc.sosdata.isNotEmpty)
                  ? SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 15),
                      child: CustomButton(
                          buttonName:
                          AppLocalizations.of(context)!.addContact,
                          width: size.width,
                          textSize: 18,
                          isLoader: accBloc.isLoading,
                          onTap: () {
                            context.read<AccBloc>().selectedContact =
                                ContactsModel(name: '', number: '');
                            context
                                .read<AccBloc>()
                                .add(SelectContactDetailsEvent());
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.08),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: CustomButton(
                          height: 52,
                          width: double.infinity,
                          borderRadius: 12,
                          buttonColor: AppColors.surface(context),
                          textColor: AppColors.primary,
                          textSize: 16,
                          border: Border.all(
                              color: AppColors.surfaceBorder(context)),
                          buttonName:
                          AppLocalizations.of(context)!.addManually,
                          onTap: () {
                            showAddManuallyBottomSheet(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : null);
        }),
      ),
    );
  }

  void showAddManuallyBottomSheet(BuildContext context) {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final phoneController = TextEditingController();
    final accBloc = context.read<AccBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder: (BuildContext sheetContext) {
        final size = MediaQuery.sizeOf(context);
        return BlocProvider(
          create: (_) => AuthBloc()
            ..add(GetDirectionEvent())
            ..add(CountryGetEvent())
            ..add(GetCommonModuleEvent()),
          child: Builder(
            builder: (bottomContext) {
              String? nameError;
              String? phoneError;

              return StatefulBuilder(
                builder: (ctx, setState) {
                  return Container(
                    height: MediaQuery.of(sheetContext).size.height,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Column(
                      children: [
                        // Header
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            border: Border(
                              bottom: BorderSide(
                                  color: AppColors.surfaceBorder(context)),
                            ),
                          ),
                          child: SafeArea(
                            bottom: false,
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(sheetContext);
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 66),
                                  child: MyText(
                                    text: AppLocalizations.of(context)!
                                        .addContact,
                                    textStyle: Theme.of(sheetContext)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Form Content
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // First Name TextField
                                CustomTextField(
                                  controller: firstNameController,
                                  filled: true,
                                  borderRadius: 10,
                                  hintText:
                                  AppLocalizations.of(context)!.firstName,
                                  contentPadding:
                                  EdgeInsets.all(size.width * 0.05),
                                ),
                                if (nameError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4.0, left: 4.0),
                                    child: MyText(
                                      text: nameError,
                                      textStyle: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 16),
                                // Last Name TextField
                                CustomTextField(
                                  controller: lastNameController,
                                  filled: true,
                                  borderRadius: 10,
                                  hintText:
                                  AppLocalizations.of(context)!.lastName,
                                  contentPadding:
                                  EdgeInsets.all(size.width * 0.05),
                                ),
                                const SizedBox(height: 16),
                                // Phone Number Row
                                Row(
                                  children: [
                                    // Country Code Dropdown (from country API)
                                    BlocBuilder<AuthBloc, AuthState>(
                                      builder: (ctx, state) {
                                        final auth = ctx.read<AuthBloc>();
                                        return InkWell(
                                          onTap: () {
                                            final countries = auth.countries;
                                            if (countries.isNotEmpty) {
                                              showModalBottomSheet(
                                                context: bottomContext,
                                                isScrollControlled: true,
                                                backgroundColor: Theme.of(
                                                    bottomContext)
                                                    .scaffoldBackgroundColor,
                                                builder: (_) =>
                                                    SelectCountryWidget(
                                                      cont: bottomContext,
                                                      countries: countries,
                                                    ),
                                              );
                                            }
                                          },
                                          borderRadius:
                                          BorderRadius.circular(12),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 16),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                borderRadius:
                                                BorderRadius.circular(12),
                                                border: Border.all(
                                                    width: 1,
                                                    color: Theme.of(context)
                                                        .hintColor)),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                MyText(
                                                  text: auth.dialCode,
                                                  textStyle: TextStyle(
                                                    fontSize: 16,
                                                    color: Theme.of(context)
                                                        .primaryColorDark,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                const Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: AppColors.hintColor,
                                                  size: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 12),
                                    // Phone Number TextField
                                    Expanded(
                                      child: CustomTextField(
                                        controller: phoneController,
                                        keyboardType: TextInputType.phone,
                                        filled: true,
                                        borderRadius: 10,
                                        hintText: AppLocalizations.of(context)!
                                            .phoneNumber,
                                        contentPadding:
                                        EdgeInsets.all(size.width * 0.05),
                                      ),
                                    ),
                                  ],
                                ),
                                if (phoneError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4.0, left: 4.0),
                                    child: MyText(
                                      text: phoneError,
                                      textStyle: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        // Bottom Button
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          child: SafeArea(
                            top: false,
                            child: SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: CustomButton(
                                height: 52,
                                width: double.infinity,
                                borderRadius: 12,
                                buttonColor: AppColors.primary,
                                textColor: Colors.white,
                                textSize: 16,
                                buttonName:
                                AppLocalizations.of(context)!.addContact,
                                onTap: () {
                                  final firstName =
                                  firstNameController.text.trim();
                                  final lastName =
                                  lastNameController.text.trim();
                                  final name = '$firstName $lastName'.trim();
                                  final rawNumber = phoneController.text.trim();

                                  setState(() {
                                    nameError = null;
                                    phoneError = null;
                                  });

                                  if (name.isEmpty) {
                                    setState(() {
                                      nameError = AppLocalizations.of(context)!
                                          .nameRequired;
                                    });
                                    return;
                                  }

                                  final localNumber = rawNumber.replaceAll(
                                      RegExp(r'[^0-9]'), '');
                                  if (localNumber.isEmpty) {
                                    setState(() {
                                      phoneError = AppLocalizations.of(context)!
                                          .phoneNumberRequired;
                                    });
                                    return;
                                  }

                                  // Prefix with selected country dial code from AuthBloc
                                  final auth = bottomContext.read<AuthBloc>();
                                  String dialCode = auth.dialCode;
                                  if (!dialCode.startsWith('+')) {
                                    dialCode = '+$dialCode';
                                  }
                                  final number = '$dialCode$localNumber';

                                  accBloc.add(SosLoadingEvent());
                                  accBloc.add(AddContactEvent(
                                      name: name, number: number));
                                  Navigator.pop(sheetContext);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}