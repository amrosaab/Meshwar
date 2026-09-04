import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../../common/common.dart';
import '../../../../../../common/liquid_glass_container.dart';
import '../../../../../../core/utils/custom_dialoges.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_textfield.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../features/auth/application/auth_bloc.dart';
import '../../../../../../features/auth/presentation/widgets/select_country_widget.dart';
import '../../../../../home/domain/models/contact_model.dart';
import '../../../../../home/domain/models/user_details_model.dart';
import '../../../../application/acc_bloc.dart';

class SosDetailWidget extends StatelessWidget {
  final BuildContext cont;
  final List<SOSDatum> sosdata;
  const SosDetailWidget({super.key, required this.cont, required this.sosdata});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
        value: cont.read<AccBloc>(),
        child: BlocListener<AccBloc, AccState>(listener: (context, state) {
          if (state is GetContactPermissionState) {
            _showPermissionDialog(context);
          }
          if (state is GetContactPermissionPermanentlyDeniedState) {
            _showPermanentPermissionDialog(context);
          }
        }, child: BlocBuilder<AccBloc, AccState>(
          builder: (context, state) {
            final list = context.watch<AccBloc>().sosdata;
            return list.isNotEmpty
                ? RawScrollbar(
              radius: const Radius.circular(20),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return (list[index].userType != 'admin')
                      ? Container(
                    width: size.width,
                    margin: const EdgeInsets.only(
                        right: 10, bottom: 10),
                    child: LiquidGlassContainer(
                      borderRadius: 10,
                      padding: EdgeInsets.all(size.width * 0.025),
                      child: Row(
                        children: [
                          SizedBox(width: size.width * 0.025),
                          Container(
                            height: size.width * 0.13,
                            width: size.width * 0.13,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context)
                                  .disabledColor
                                  .withAlpha((0.5 * 255).toInt()),
                            ),
                            alignment: Alignment.center,
                            child: MyText(
                              text: list[index]
                                  .name
                                  .toString()
                                  .substring(0, 1),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.025,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: MyText(
                                        text: list[index].name,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                            fontWeight:
                                            FontWeight
                                                .w600),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: MyText(
                                        text: list[index].number,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                            fontWeight:
                                            FontWeight
                                                .w600),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: size.width * 0.025),
                          InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext _) {
                                    return BlocProvider.value(
                                      value:
                                      BlocProvider.of<AccBloc>(
                                          context),
                                      child:
                                      CustomDoubleButtonDialoge(
                                        title: AppLocalizations.of(
                                            context)!
                                            .deleteSos,
                                        content:
                                        AppLocalizations.of(
                                            context)!
                                            .deleteContact,
                                        yesBtnName:
                                        AppLocalizations.of(
                                            context)!
                                            .yes,
                                        noBtnName:
                                        AppLocalizations.of(
                                            context)!
                                            .no,
                                        yesBtnFunc: () {
                                          context
                                              .read<AccBloc>()
                                              .add(
                                              SosLoadingEvent());
                                          context
                                              .read<AccBloc>()
                                              .add(
                                              DeleteContactEvent(
                                                  id: list[
                                                  index]
                                                      .id));
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Icon(
                                Icons.delete,
                                color: Theme.of(context)
                                    .primaryColorDark,
                              ))
                        ],
                      ),
                    ),
                  )
                      : (list.length == 1)
                      ? _buildEmptyState(context, size)
                      : const SizedBox();
                },
              ),
            )
                : _buildEmptyState(context, size);
          },
        )));
  }

  Widget _buildEmptyState(BuildContext context, Size size) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: size.height * 0.06),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LiquidGlassContainer(
              circular: true,
              width: 148,
              height: 148,
              blurSigma: 14,
              fillOpacity: 0.1,
              child: Center(
                child: Image.asset(
                  AppImages.sosNoData,
                  width: 92,
                  height: 92,
                ),
              ),
            ),
            const SizedBox(height: 24),
            MyText(
              text: AppLocalizations.of(context)!.nososContacts,
              textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),//
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            SizedBox(height: size.height * 0.05),
            // Primary Button - Add from contacts
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
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
                  buttonName: AppLocalizations.of(context)!.addContact,
                  onTap: () {
                    context.read<AccBloc>().selectedContact =
                        ContactsModel(name: '', number: '');
                    context.read<AccBloc>().add(SelectContactDetailsEvent());
                  },
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            // Secondary Button - Add manually
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
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
                  border: Border.all(color: AppColors.surfaceBorder(context)),
                  buttonName: AppLocalizations.of(context)!.addManually,
                  onTap: () {
                    showAddManuallyBottomSheet(context);
                  },
                ),
              ),
            ),
          ],
        ),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyText(
                                  text:
                                  AppLocalizations.of(context)!.addContact,
                                  textStyle: Theme.of(sheetContext)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Form Content
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.all(size.width * 0.05),
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
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 16),
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
                                          hintText:
                                          AppLocalizations.of(context)!
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

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: MyText(text: AppLocalizations.of(context)!.permissionRequired),
        content: MyText(
          text: AppLocalizations.of(context)!.contactsPermissionContent,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: MyText(text: AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AccBloc>().add(SelectContactDetailsEvent());
            },
            child: MyText(text: AppLocalizations.of(context)!.tryAgain),
          ),
        ],
      ),
    );
  }

  void _showPermanentPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: MyText(
          text: AppLocalizations.of(context)!.permissionRequired,
          textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontSize: 16,
            color: Theme.of(context).primaryColorDark,
          ),
          maxLines: 2,
        ),
        content: MyText(
          text: AppLocalizations.of(context)!.contactsPermissionSettingsContent,
          textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 14,
            color: Theme.of(context).primaryColorDark,
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: MyText(text: AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: MyText(text: AppLocalizations.of(context)!.openSettings),
          ),
        ],
      ),
    );
  }
}