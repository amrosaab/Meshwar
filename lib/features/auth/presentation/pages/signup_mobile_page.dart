import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/app_arguments.dart';
import '../../../../common/app_colors.dart';
import '../../../../common/app_validators.dart';
import '../../../../core/utils/custom_appbar.dart';
import '../../../../core/utils/custom_background.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_snack_bar.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../core/utils/staggered_reveal.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/presentation/pages/settings/page/terms_privacy_policy_view_page.dart';
import '../../application/auth_bloc.dart';
import '../widgets/select_country_widget.dart';
import 'login_page.dart';
import 'otp_page.dart';

class SignupMobilePage extends StatelessWidget {
  static const String routeName = '/SignupMobilePage';
  final SignupMobilePageArguments arg;

  const SignupMobilePage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => AuthBloc()
        ..add(GetDirectionEvent())
        ..add(CountryGetEvent())
        ..add(GetCommonModuleEvent()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitialState) {
            CustomLoader.loader(context);
          } else if (state is AuthDataLoadingState) {
            CustomLoader.loader(context);
          } else if (state is AuthDataLoadedState) {
            CustomLoader.dismiss(context);
          } else if (state is AuthDataSuccessState) {
            CustomLoader.dismiss(context);
          } else if (state is LoginLoadingState) {
            CustomLoader.loader(context);
          } else if (state is LoginFailureState) {
            CustomLoader.dismiss(context);
            // } else if (state is VerifySuccessState ||
            //     state is UserNotExistState) {
          } else if (state is ValidateMobileFailureState) {
            //CustomLoader.dismiss(context);
          } else if (state is ValidateMobileSuccessState) {
            CustomLoader.dismiss(context);
            final authBloc = context.read<AuthBloc>();
            final mobileOrEmail = arg.mobileOrEmailSignUp
                ? authBloc.rEmailController.text.trim()
                : authBloc.rMobileController.text.trim();
            if (mobileOrEmail.isNotEmpty) {
              Navigator.pushNamed(context, OtpPage.routeName,
                  arguments: OtpPageArguments(
                      mobileOrEmail: mobileOrEmail,
                      dialCode: authBloc.dialCode,
                      countryCode: context.read<AuthBloc>().countryCode,
                      countryFlag: context.read<AuthBloc>().flagImage,
                      isLoginByEmail: arg.mobileOrEmailSignUp,
                      isOtpVerify: true,
                      userExist: context.read<AuthBloc>().userExist,
                      isDemoLogin: true,
                      countryList: context.read<AuthBloc>().countries,
                      isRefferalEarnings:
                      context.read<AuthBloc>().isRefferalEarnings));
            } else {
              showToast(
                  message:
                  AppLocalizations.of(context)!.pleaseEnterMobileNumber);
            }
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Scaffold(
              appBar: CustomAppBar(
                title: (arg.mobileOrEmailSignUp == false)
                    ? AppLocalizations.of(context)!.verifyPhone
                    : AppLocalizations.of(context)!.verifyEmailText,
                automaticallyImplyLeading: true,
                titleFontSize: 16,
                textColor: Theme.of(context).primaryColorDark,
              ),
              body: CustomBackground(
                child: SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.all(size.width * 0.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: size.width * 0.12),
                          StaggeredReveal(
                            index: 0,
                            child: Center(
                              child: Container(
                                height: 64,
                                width: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: AppColors.beaconGradient,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.meshwarRed.withOpacity(0.25),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  (arg.mobileOrEmailSignUp == false)
                                      ? Icons.phone_iphone_rounded
                                      : Icons.mail_outline_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: size.width * 0.06),
                          StaggeredReveal(
                            index: 1,
                            child: Column(
                              children: [
                                MyText(
                                  text: (arg.mobileOrEmailSignUp == false)
                                      ? AppLocalizations.of(context)!
                                      .verifyMobileNumber
                                      : AppLocalizations.of(context)!
                                      .verifyEmailId,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color:
                                      Theme.of(context).primaryColorDark),
                                ),
                                SizedBox(height: size.width * 0.03),
                                MyText(
                                  text: AppLocalizations.of(context)!
                                      .confirmOtpNumber,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                    color: AppColors.darkGrey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.width * 0.07),
                          StaggeredReveal(
                            index: 2,
                            child: (arg.mobileOrEmailSignUp == false)
                                ? buildMobileField(context, size)
                                : buildEmailField(context),
                          ),
                          SizedBox(height: size.width * 0.05),
                          StaggeredReveal(
                            index: 3,
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                MyText(
                                  text: AppLocalizations.of(context)!.signupAgree,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                    color: AppColors.darkGrey,
                                    fontSize: 12,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context,
                                        TermsPrivacyPolicyViewPage.routeName,
                                        arguments: TermsAndPrivacyPolicyArguments(
                                            isPrivacyPolicy: false));
                                  },
                                  child: MyText(
                                    text:
                                    ' ${AppLocalizations.of(context)!.termsOfService} ',
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                      color: AppColors.meshwarRed,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                MyText(
                                  text: '${AppLocalizations.of(context)!.and} ',
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                    color: AppColors.darkGrey,
                                    fontSize: 12,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context,
                                        TermsPrivacyPolicyViewPage.routeName,
                                        arguments: TermsAndPrivacyPolicyArguments(
                                            isPrivacyPolicy: true));
                                  },
                                  child: MyText(
                                    text: AppLocalizations.of(context)!
                                        .privacyPolicyText,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                      color: AppColors.meshwarRed,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.width * 0.1),
                          StaggeredReveal(index: 4, child: buildSendOtpButton(context)),
                          SizedBox(height: size.width * 0.25),
                          StaggeredReveal(
                            index: 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyText(
                                  text:
                                  '${AppLocalizations.of(context)!.alreadyHaveAccount} ',
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                      color: AppColors.darkGrey,
                                      fontSize: 14),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      LoginPage.routeName,
                                          (route) => false,
                                    );
                                  },
                                  child: MyText(
                                    text: AppLocalizations.of(context)!.signIn,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                        color: AppColors.meshwarRed,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildMobileField(BuildContext context, Size size) {
    return CustomTextField(
      controller: context.read<AuthBloc>().rMobileController,
      filled: true,
      borderRadius: 14,
      fillColor: !context.read<AuthBloc>().isLoginByEmail
          ? AppColors.surfaceStrong(context)
          : null,
      enabled: context.read<AuthBloc>().isLoginByEmail,
      hintText: AppLocalizations.of(context)!.mobile,
      focusNode: context.read<AuthBloc>().mobileFocusNode,
      keyboardType: TextInputType.number,
      prefixConstraints: BoxConstraints(maxWidth: size.width * 0.2),
      prefixIcon: Center(
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
              isScrollControlled: true,
              enableDrag: true,
              context: context,
              builder: (cont) {
                return SelectCountryWidget(
                    countries: context.read<AuthBloc>().countries,
                    cont: context);
              },
            );
          },
          child: Row(
            children: [
              Container(
                height: 20,
                width: 25,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: AppColors.surfaceStrong(context),
                  borderRadius: BorderRadius.circular(5),
                  image: (context.read<AuthBloc>().flagImage.isNotEmpty)
                      ? DecorationImage(
                      image:
                      NetworkImage(context.read<AuthBloc>().flagImage),
                      fit: BoxFit.fill)
                      : null,
                ),
              ),
              MyText(
                text: context.read<AuthBloc>().dialCode,
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
      suffixIcon: InkWell(
        onTap: () {
          context.read<AuthBloc>().rMobileController.clear();
        },
        child: const Icon(
          Icons.cancel_outlined,
          color: AppColors.darkGrey,
        ),
      ),
      validator: (value) {
        if (value!.isNotEmpty && !AppValidation.mobileNumberValidate(value)) {
          return AppLocalizations.of(context)!.enterValidMobile;
        } else if (value.isEmpty) {
          return AppLocalizations.of(context)!.pleaseEnterMobileNumber;
        } else {
          return null;
        }
      },
    );
  }

  Widget buildEmailField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: AppLocalizations.of(context)!.email,
          textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).primaryColorDark, fontSize: 14),
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: context.read<AuthBloc>().rEmailController,
          filled: true,
          borderRadius: 14,
          fillColor: !context.read<AuthBloc>().isLoginByEmail
              ? AppColors.surfaceStrong(context)
              : null,
          hintText: AppLocalizations.of(context)!.enterEmail,
          focusNode: context.read<AuthBloc>().emailFocusNode,
          keyboardType: TextInputType.emailAddress,
          suffixIcon: InkWell(
            onTap: () {
              context.read<AuthBloc>().rEmailController.clear();
            },
            child: const Icon(
              Icons.cancel_outlined,
              color: AppColors.darkGrey,
            ),
          ),
          validator: (value) {
            if (value!.isNotEmpty && !AppValidation.emailValidate(value)) {
              return AppLocalizations.of(context)!.enterValidEmail;
            } else if (value.isEmpty) {
              return AppLocalizations.of(context)!.enterEmail;
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }

  Widget buildSendOtpButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: CustomButton(
            borderRadius: 16,
            width: MediaQuery.sizeOf(context).width,
            buttonName: AppLocalizations.of(context)!.sendOtp,
            textSize: 16,
            isLoader: context.read<AuthBloc>().isLoading,
            onTap: () {
              final mobileNumber =
              context.read<AuthBloc>().rMobileController.text.trim();
              final email = context.read<AuthBloc>().rEmailController.text;
              final bool isEmail = AppValidation.emailValidate(email);
              context.read<AuthBloc>();
              if (arg.mobileOrEmailSignUp == true) {
                if (email.isEmpty) {
                  showToast(message: AppLocalizations.of(context)!.enterEmail);
                  return;
                }

                if (!isEmail) {
                  showToast(
                      message: AppLocalizations.of(context)!.enterValidEmail);
                  return;
                }
                context.read<AuthBloc>().add(
                  ValidateMobileEvent(
                    mobileOrEmail: email,
                    isLoginByEmail: true, // Email flow
                  ),
                );
              } else {
                if (mobileNumber.isEmpty) {
                  showToast(
                      message: AppLocalizations.of(context)!
                          .pleaseEnterMobileNumber);
                  return;
                }

                if (!AppValidation.mobileNumberValidate(mobileNumber)) {
                  showToast(
                      message: AppLocalizations.of(context)!.enterValidMobile);
                  return;
                }

                context.read<AuthBloc>().add(
                  ValidateMobileEvent(
                    mobileOrEmail: mobileNumber,
                    isLoginByEmail: false,
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}