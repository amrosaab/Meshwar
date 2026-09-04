import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/app_arguments.dart';
import '../../../../../../common/app_colors.dart';
import '../../../../../../core/network/extensions.dart';
import '../../../../../../core/utils/custom_appbar.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../core/utils/custom_textfield.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';

class UpdateDetails extends StatefulWidget {
  static const String routeName = '/UpdateDetails';
  final UpdateDetailsArguments arg;

  const UpdateDetails({super.key, required this.arg});

  @override
  State<UpdateDetails> createState() => _UpdateDetailsState();
}

class _UpdateDetailsState extends State<UpdateDetails> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final accBloc = context.read<AccBloc>();
      accBloc.add(AccGetDirectionEvent());
      accBloc.add(UpdateControllerWithDetailsEvent(args: widget.arg));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider.value(
      value: context.read<AccBloc>(),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is AccInitialState) {
            CustomLoader.loader(context);
          } else if (state is UserDetailsUpdatedState) {
            if (!context.mounted) return;

            context.showSnackBar(
              color: Theme.of(context).primaryColorDark,
              message: AppLocalizations.of(context)!.updateSuccess,
            );

            Future.delayed(const Duration(milliseconds: 300), () {
              if (context.mounted) {
                Navigator.pop(context, state);
              }
            });
          } else if (state is UpdateUserDetailsFailureState) {
            context.showSnackBar(
              color: Theme.of(context).primaryColor,
              message: AppLocalizations.of(context)!.failedUpdateDetails,
            );
          }
        },
        child: BlocBuilder<AccBloc, AccState>(
          builder: (context, state) {
            final accBloc = context.read<AccBloc>();
            final user = accBloc.userData ?? widget.arg.userData;
            final header = widget.arg.header;
            final isMobileHeader =
                header == AppLocalizations.of(context)!.mobile;
            final isEmailHeader =
                header == AppLocalizations.of(context)!.email ||
                    header == AppLocalizations.of(context)!.emailAddress;

            return Scaffold(
              appBar: CustomAppBar(
                title:
                '${AppLocalizations.of(context)!.update} ${widget.arg.header}',
                automaticallyImplyLeading: true,
              ),
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.025),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: (widget.arg.header ==
                                AppLocalizations.of(context)!.name)
                                ? AppLocalizations.of(context)!
                                .enterNameIdOrPassport
                                : (widget.arg.header ==
                                AppLocalizations.of(context)!.gender)
                                ? AppLocalizations.of(context)!
                                .enterYourGender
                                : AppLocalizations.of(context)!
                                .enterYourEmail,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                fontSize: 14,
                                color: Theme.of(context).hintColor),
                            maxLines: 2,
                          ),
                          SizedBox(height: size.height * 0.02),

                          // Gender Dropdown
                          if (header == AppLocalizations.of(context)!.gender)
                            BlocBuilder<AccBloc, AccState>(
                              builder: (context, state) {
                                List<String> showGenderList = [
                                  AppLocalizations.of(context)!.male,
                                  AppLocalizations.of(context)!.female,
                                  AppLocalizations.of(context)!.preferNotSay,
                                ];
                                return DropdownButtonFormField<String>(
                                  alignment: Alignment.bottomCenter,
                                  dropdownColor:
                                  AppColors.surfaceStrong(context),
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    fillColor: AppColors.surface(context),
                                    filled: true,
                                    hintText: context
                                        .read<AccBloc>()
                                        .selectedGender
                                        .isNotEmpty
                                        ? context.read<AccBloc>().selectedGender
                                        : AppLocalizations.of(context)!
                                        .selectGender,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 20),
                                  ),
                                  items: showGenderList.map((gender) {
                                    return DropdownMenuItem<String>(
                                      value: gender,
                                      child: Text(gender),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    int index = showGenderList
                                        .indexOf(newValue.toString());
                                    if (index != -1) {
                                      String codedValue = context
                                          .read<AccBloc>()
                                          .genderOptions[index];
                                      context.read<AccBloc>().add(
                                          GenderSelectedEvent(
                                              selectedGender: codedValue));
                                    }
                                  },
                                );
                              },
                            ),

                          // TextField for Name/Email/Mobile
                          if (header != AppLocalizations.of(context)!.gender)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                  text: widget.arg.header,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(
                                    color:
                                    Theme.of(context).primaryColorDark,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                CustomTextField(
                                  controller: accBloc.updateController,
                                  contentPadding:
                                  EdgeInsets.all(size.width * 0.025),
                                  filled: true,
                                  hintText: widget.arg.header,
                                  hintTextStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                    fontSize: 14,
                                    color: AppColors.greyHintColor,
                                  ),
                                  keyboardType: isMobileHeader
                                      ? TextInputType.number
                                      : (isEmailHeader
                                      ? TextInputType.emailAddress
                                      : TextInputType.text),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.surfaceBorder(context),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.surfaceBorder(context),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: CustomButton(
                        isLoader: BlocProvider.of<AccBloc>(context).isLoading,
                        buttonName: AppLocalizations.of(context)!.update,
                        width: size.width * 0.9,
                        textSize: 16,
                        onTap: () {
                          final updatedText =
                          accBloc.updateController.text.trim();

                          String updatedName = '';
                          String updatedEmail = '';
                          String updatedMobile = '';
                          String updatedGender = '';
                          String updatedCountry = '';

                          if (header == AppLocalizations.of(context)!.name) {
                            updatedName = updatedText;
                          } else if (header ==
                              AppLocalizations.of(context)!.email ||
                              header ==
                                  AppLocalizations.of(context)!.emailAddress) {
                            updatedEmail = updatedText;
                          } else if (header ==
                              AppLocalizations.of(context)!.mobile) {
                            updatedMobile = updatedText;
                            updatedCountry = user.countryCode;
                          } else if (header ==
                              AppLocalizations.of(context)!.gender) {
                            updatedGender = accBloc.selectedGender;
                          }

                          context.read<AccBloc>().add(
                            UpdateUserDetailsEvent(
                              name: updatedName,
                              email: updatedEmail,
                              gender: updatedGender,
                              profileImage: accBloc.profileImage.isEmpty
                                  ? ''
                                  : accBloc.profileImage,
                              mobile: updatedMobile,
                              country: updatedCountry,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: size.width * 0.1),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}