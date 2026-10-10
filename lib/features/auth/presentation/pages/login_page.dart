// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_background.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_snack_bar.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../core/utils/staggered_reveal.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/presentation/pages/settings/page/terms_privacy_policy_view_page.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../language/presentation/page/choose_language_page.dart';
import '../../../loading/application/loader_bloc.dart';
import '../../application/auth_bloc.dart';
import '../widgets/select_country_widget.dart';
import 'forgot_password_page.dart';
import 'signup_mobile_page.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/loginPage';
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  Timer? timer;

  Future<void> timerCount(BuildContext cont,
      {required int duration, bool? isCloseTimer}) async {
    int count = duration;

    if (isCloseTimer == null) {
      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        count--;
        if (count <= 0) {
          timer?.cancel();
        }
        cont.read<AuthBloc>().add(VerifyTimerEvent(duration: count));
      });
    }

    if (isCloseTimer != null && isCloseTimer) {
      timer?.cancel();
      cont.read<AuthBloc>().add(VerifyTimerEvent(duration: 0));
    }
  }

  @override
  void dispose() {
    if (timer != null) {
      timer?.cancel();
    }
    super.dispose();
  }

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
          } else if (state is GetCommonModuleSuccess) {
            CustomLoader.dismiss(context);
          } else if (state is GetCommonModuleFailure) {
            CustomLoader.dismiss(context);
          } else if (state is SignInWithOTPFailureState) {
            // Same fix as otp_page.dart: don't leave the user locked out of
            // Resend OTP for the full 60s when the send itself failed.
            timerCount(context, duration: 0, isCloseTimer: true);
          } else if (state is AuthDataLoadedState) {
            CustomLoader.dismiss(context);
          } else if (state is AuthDataSuccessState) {
            CustomLoader.dismiss(context);
          } else if (state is VerifySuccessState) {
            CustomLoader.dismiss(context);
            final authBloc = context.read<AuthBloc>();
            final mobileOrEmail = authBloc.selectLoginMethods
                ? authBloc.rEmailController.text.trim()
                : authBloc.rMobileController.text.trim();

            // Validation: make sure user entered email or mobile
            if (mobileOrEmail.isEmpty) {
              showToast(
                  message:
                      AppLocalizations.of(context)!.pleaseEnterMobileOrEmail);
            } else {
              // If not empty, switch to OTP mode and call the event
              authBloc.isOtpVerify = true;
              authBloc.add(
                SignInWithOTPEvent(
                  isOtpVerify: true,
                  isForgotPassword: false,
                  mobileOrEmail: mobileOrEmail,
                  dialCode: authBloc.dialCode,
                  isLoginByEmail: authBloc.selectLoginMethods,
                  context: context,
                ),
              );
              timerCount(context, duration: 60);
            }
          } else if (state is ForgotPasswordOnTapState) {
            final authBloc = context.read<AuthBloc>();
            final mobileOrEmail = authBloc.selectLoginMethods
                ? authBloc.rEmailController.text.trim()
                : authBloc.rMobileController.text.trim();
            Navigator.pushNamed(
              context,
              ForgotPasswordPage.routeName,
              arguments: ForgotPasswordPageArguments(
                isLoginByEmail: authBloc.selectLoginMethods,
                contryCode: authBloc.dialCode,
                countryFlag: authBloc.countryCode,
                emailOrMobile: mobileOrEmail,
              ),
            ).then((_) {
              context.read<AuthBloc>().isOtpVerify = false;
              context.read<AuthBloc>().add(OtpVerifyEvent(isOtpVerify: false));
            });
          } else if (state is ForgotPasswordOTPSendState) {
            final authBloc = context.read<AuthBloc>();
            final mobileOrEmail = authBloc.selectLoginMethods
                ? authBloc.rEmailController.text.trim()
                : authBloc.rMobileController.text.trim();
            Navigator.pushNamed(
              context,
              ForgotPasswordPage.routeName,
              arguments: ForgotPasswordPageArguments(
                isLoginByEmail: authBloc.selectLoginMethods,
                contryCode: authBloc.dialCode,
                countryFlag: authBloc.countryCode,
                emailOrMobile: mobileOrEmail,
              ),
            ).then((_) {
              context.read<AuthBloc>().isOtpVerify = false;
              context.read<AuthBloc>().add(OtpVerifyEvent(isOtpVerify: false));
            });
          } else if (state is UserNotExistState) {
            final authBloc = context.read<AuthBloc>();
            final mobileOrEmail = authBloc.selectLoginMethods
                ? authBloc.rEmailController.text.trim()
                : authBloc.rMobileController.text.trim();
            CustomLoader.dismiss(context);
            if (mobileOrEmail.isEmpty) {
              showToast(
                  message:
                      AppLocalizations.of(context)!.pleaseEnterMobileOrEmail);
            } else {
              showToast(message: state.message);
            }
          } else if (state is LoginSuccessState ||
              state is ConfirmMobileOrEmailState) {
            context.read<LoaderBloc>().add(UpdateUserLocationEvent());
            Navigator.pushNamedAndRemoveUntil(
                context, HomePage.routeName, (route) => false);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: CustomBackground(
                child: SafeArea(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: const BouncingScrollPhysics(),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildHeader(context),
                              const SizedBox(height: 16),
                              StaggeredReveal(
                                index: 0,
                                child: Center(
                                  child: Container(
                                    height: 56,
                                    width: 56,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: AppColors.meshwarRed
                                          .withValues(alpha: 0.08),
                                    ),
                                    child: const Icon(Icons.person_rounded,
                                        color: AppColors.meshwarRed, size: 26),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              StaggeredReveal(
                                index: 1,
                                child: MyText(
                                  text: AppLocalizations.of(context)!
                                      .loginContent,
                                  textStyle: AppTextStyle.display(
                                          size: 26,
                                          weight: FontWeight.w800,
                                          color: Theme.of(context)
                                              .primaryColorDark)
                                      .copyWith(height: 1.35),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 28),
                              StaggeredReveal(
                                index: 2,
                                child: _buildFieldsSection(context, size),
                              ),
                              const SizedBox(height: 20),
                              StaggeredReveal(
                                index: 3,
                                child: BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, state) {
                                    bool isChecked = false;

                                    if (state
                                        is SelectTermsAndConditionCheckBoxState) {
                                      isChecked =
                                          state.isTermsAndConditionsChecked;
                                    } else {
                                      isChecked = context
                                          .read<AuthBloc>()
                                          .isTermsAndConditionsChecked;
                                    }

                                    return Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            context.read<AuthBloc>().add(
                                                  SelectTermsAndConditionCheckBoxEvent(
                                                    isTermsAndConditionsChecked:
                                                        !isChecked,
                                                  ),
                                                );
                                          },
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 180),
                                            curve: Curves.easeOut,
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              gradient: isChecked
                                                  ? AppColors.beaconGradient
                                                  : null,
                                              color: isChecked
                                                  ? null
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                width: 1.4,
                                                color: isChecked
                                                    ? Colors.transparent
                                                    : AppColors.surfaceBorder(
                                                        context),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: AnimatedScale(
                                              scale: isChecked ? 1 : 0,
                                              duration: const Duration(
                                                  milliseconds: 180),
                                              curve: Curves.easeOutBack,
                                              child: const Icon(Icons.done,
                                                  size: 14,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              MyText(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .agreeTermsText,
                                                textStyle: AppTextStyle.body(
                                                    size: 13,
                                                    weight: FontWeight.w500,
                                                    color: AppColors.darkGrey),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    TermsPrivacyPolicyViewPage
                                                        .routeName,
                                                    arguments:
                                                        TermsAndPrivacyPolicyArguments(
                                                      isPrivacyPolicy: false,
                                                    ),
                                                  );
                                                },
                                                child: MyText(
                                                  text:
                                                      ' ${AppLocalizations.of(context)!.termsAndConditions}',
                                                  textStyle: AppTextStyle.body(
                                                      size: 13,
                                                      weight: FontWeight.w700,
                                                      color:
                                                          AppColors.meshwarRed),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 24),
                              StaggeredReveal(
                                  index: 4, child: buildLoginButton(context)),
                              const SizedBox(height: 32),
                              StaggeredReveal(
                                index: 5,
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    MyText(
                                      text:
                                          '${AppLocalizations.of(context)!.dontHaveAnAccount} ',
                                      textStyle: AppTextStyle.body(
                                          size: 13,
                                          weight: FontWeight.w500,
                                          color: AppColors.darkGrey),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (context
                                                    .read<AuthBloc>()
                                                    .isUserEmailLogin ==
                                                '1' &&
                                            context
                                                    .read<AuthBloc>()
                                                    .isUserMobileLogin ==
                                                '1') {
                                          Navigator.pushNamed(context,
                                              SignupMobilePage.routeName,
                                              arguments:
                                                  SignupMobilePageArguments(
                                                      mobileOrEmailSignUp: context
                                                          .read<AuthBloc>()
                                                          .selectLoginMethods));
                                        } else if (context
                                                    .read<AuthBloc>()
                                                    .isUserEmailLogin ==
                                                '1' &&
                                            context
                                                    .read<AuthBloc>()
                                                    .isUserMobileLogin ==
                                                '0') {
                                          Navigator.pushNamed(context,
                                              SignupMobilePage.routeName,
                                              arguments:
                                                  SignupMobilePageArguments(
                                                      mobileOrEmailSignUp:
                                                          true));
                                        } else if (context
                                                    .read<AuthBloc>()
                                                    .isUserEmailLogin ==
                                                '0' &&
                                            context
                                                    .read<AuthBloc>()
                                                    .isUserMobileLogin ==
                                                '1') {
                                          Navigator.pushNamed(context,
                                              SignupMobilePage.routeName,
                                              arguments:
                                                  SignupMobilePageArguments(
                                                      mobileOrEmailSignUp:
                                                          false));
                                        }
                                      },
                                      child: MyText(
                                        text:
                                            '${AppLocalizations.of(context)!.signup} ',
                                        textStyle: AppTextStyle.body(
                                            size: 13,
                                            weight: FontWeight.w700,
                                            color: AppColors.meshwarRed),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 36,
          width: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: AppColors.surfaceBorder(context)),
          ),
          child: const Icon(Icons.person_outline_rounded,
              size: 20, color: AppColors.meshwarRed),
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              ChooseLanguagePage.routeName,
              arguments:
                  ChooseLanguageArguments(isInitialLanguageChange: false),
            ).then(
              (value) {
                if (!context.mounted) return;
                context.read<AuthBloc>().add(GetDirectionEvent());
              },
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface(context),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.surfaceBorder(context)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyText(
                    text: context.read<AuthBloc>().languageCode.toUpperCase(),
                    textStyle: AppTextStyle.mono(
                        size: 12,
                        weight: FontWeight.w700,
                        color: AppColors.meshwarRed)),
                const SizedBox(width: 4),
                const Icon(Icons.language_outlined,
                    size: 16, color: AppColors.meshwarRed),
                const Icon(Icons.expand_more_rounded,
                    size: 16, color: AppColors.darkGrey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Assembles the contact field (phone or email) and, when applicable, the
  // password field into one _FieldGroup card, with the forgot-password/OTP
  // row and the OTP pin field sitting below it — mirrors the grouped
  // squircle-card pattern used for the map controls on the booking screen.
  Widget _buildFieldsSection(BuildContext context, Size size) {
    final authBloc = context.read<AuthBloc>();
    final bothMethods =
        authBloc.isUserEmailLogin == '1' && authBloc.isUserMobileLogin == '1';
    final emailOnly =
        authBloc.isUserEmailLogin == '1' && authBloc.isUserMobileLogin == '0';
    final mobileOnly =
        authBloc.isUserEmailLogin == '0' && authBloc.isUserMobileLogin == '1';
    final selectEmail = context.watch<AuthBloc>().selectLoginMethods;
    final isOtpVerify = context.watch<AuthBloc>().isOtpVerify;

    final Widget contactField = bothMethods
        ? (selectEmail
            ? buildEmailField(context)
            : buildMobileField(context, size))
        : emailOnly
            ? buildEmailField(context)
            : mobileOnly
                ? buildMobileField(context, size)
                : const SizedBox.shrink();

    final bool showOtp = bothMethods
        ? (isOtpVerify &&
            ((selectEmail == false && authBloc.isUserSignInMobileOtp == '1') ||
                (selectEmail == true && authBloc.isUserSignInEmailOtp == '1')))
        : (isOtpVerify &&
            (authBloc.isUserSignInMobileOtp == '1' ||
                authBloc.isUserSignInEmailOtp == '1'));

    final bool showPassword = bothMethods
        ? (!isOtpVerify &&
            ((selectEmail == false &&
                    authBloc.isUserSignInMobilePassword == '1') ||
                (selectEmail == true &&
                    authBloc.isUserSignInEmailPassword == '1')))
        : (!isOtpVerify &&
            (authBloc.isUserSignInMobilePassword == '1' ||
                authBloc.isUserSignInEmailPassword == '1'));

    return Column(
      children: [
        if (bothMethods) _MethodToggle(context: context),
        if (bothMethods) const SizedBox(height: 20),
        _FieldGroup(children: [
          contactField,
          if (showPassword) passwordField(context),
        ]),
        if (showPassword) ...[
          const SizedBox(height: 12),
          passwordActionsRow(context),
        ],
        if (showOtp) ...[
          const SizedBox(height: 20),
          buildPinField(context),
        ],
      ],
    );
  }

  Widget buildMobileField(BuildContext context, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: AppLocalizations.of(context)!.phoneNumber,
          textStyle: AppTextStyle.body(
              size: 13, weight: FontWeight.w700, color: AppColors.darkGrey),
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: context.read<AuthBloc>().rMobileController,
          borderRadius: 14,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          style: AppTextStyle.body(
              size: 15,
              weight: FontWeight.w500,
              color: Theme.of(context).primaryColorDark),
          hintTextStyle: AppTextStyle.body(
              size: 14, weight: FontWeight.w400, color: AppColors.darkGrey),
          enabled: context.read<AuthBloc>().isLoginByEmail,
          hintText: AppLocalizations.of(context)!.mobile,
          focusNode: context.read<AuthBloc>().mobileFocusNode,
          keyboardType: TextInputType.number,
          prefixConstraints: const BoxConstraints(maxWidth: 96),
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
                textDirection: TextDirection.ltr,
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
                              image: NetworkImage(
                                  context.read<AuthBloc>().flagImage),
                              fit: BoxFit.fill)
                          : null,
                    ),
                  ),
                  MyText(
                    text: context.read<AuthBloc>().dialCode,
                    textStyle: AppTextStyle.mono(
                        size: 13,
                        weight: FontWeight.w600,
                        color: Theme.of(context).primaryColorDark),
                  ),
                ],
              ),
            ),
          ),
          suffixIcon: InkWell(
            onTap: () {
              context.read<AuthBloc>().rMobileController.clear();
            },
            child: const Icon(Icons.cancel_outlined,
                color: AppColors.darkGrey, size: 20),
          ),
          validator: (value) {
            if (value!.isNotEmpty &&
                !AppValidation.mobileNumberValidate(value)) {
              return AppLocalizations.of(context)!.enterValidMobile;
            } else if (value.isEmpty) {
              return AppLocalizations.of(context)!.pleaseEnterMobileNumber;
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }

  Widget buildEmailField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: AppLocalizations.of(context)!.email,
          textStyle: AppTextStyle.body(
              size: 13, weight: FontWeight.w700, color: AppColors.darkGrey),
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: context.read<AuthBloc>().rEmailController,
          borderRadius: 14,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          style: AppTextStyle.body(
              size: 15,
              weight: FontWeight.w500,
              color: Theme.of(context).primaryColorDark),
          hintTextStyle: AppTextStyle.body(
              size: 14, weight: FontWeight.w400, color: AppColors.darkGrey),
          hintText: AppLocalizations.of(context)!.enterEmail,
          focusNode: context.read<AuthBloc>().emailFocusNode,
          keyboardType: TextInputType.emailAddress,
          suffixIcon: InkWell(
            onTap: () {
              context.read<AuthBloc>().rEmailController.clear();
            },
            child: const Icon(Icons.cancel_outlined,
                color: AppColors.darkGrey, size: 20),
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

  Widget passwordField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: AppLocalizations.of(context)!.password,
          textStyle: AppTextStyle.body(
              size: 13, weight: FontWeight.w700, color: AppColors.darkGrey),
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: context.read<AuthBloc>().passwordController,
          obscureText: !context.read<AuthBloc>().showPassword,
          borderRadius: 14,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          style: AppTextStyle.body(
              size: 15,
              weight: FontWeight.w500,
              color: Theme.of(context).primaryColorDark),
          hintTextStyle: AppTextStyle.body(
              size: 14, weight: FontWeight.w400, color: AppColors.darkGrey),
          hintText: AppLocalizations.of(context)!.enterYourPassword,
          suffixIcon: InkWell(
            onTap: () {
              context.read<AuthBloc>().add(ShowPasswordIconEvent(
                  showPassword: context.read<AuthBloc>().showPassword));
            },
            child: Icon(
              !context.read<AuthBloc>().showPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility,
              color: AppColors.darkGrey,
              size: 21,
            ),
          ),
        ),
      ],
    );
  }

  // Forgot Password / Sign in using OTP row — sits below the grouped field
  // card, not inside it, so it stays outside _FieldGroup's shared border.
  Widget passwordActionsRow(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 8,
        spacing: 12,
        children: [
          InkWell(
            onTap: () {
              final mobileNumber =
                  context.read<AuthBloc>().rMobileController.text.trim();
              final email =
                  context.read<AuthBloc>().rEmailController.text.trim();
              if ((mobileNumber.isNotEmpty && email.isEmpty) ||
                  (mobileNumber.isEmpty && email.isNotEmpty)) {
                context.read<AuthBloc>().add(VerifyUserEvent(
                    mobileOrEmail: (context.read<AuthBloc>().selectLoginMethods)
                        ? email
                        : mobileNumber,
                    loginByMobile: (context.read<AuthBloc>().selectLoginMethods)
                        ? true
                        : false,
                    forgotPassword: true));
              } else {
                showToast(
                    message:
                        AppLocalizations.of(context)!.pleaseEnterMobileOrEmail);
              }
            },
            child: MyText(
              text: AppLocalizations.of(context)!.forgotPassword,
              textStyle: AppTextStyle.body(
                  size: 12.5,
                  weight: FontWeight.w700,
                  color: AppColors.meshwarRed),
            ),
          ),
          if (context.read<AuthBloc>().isUserEmailLogin == '1' &&
              context.read<AuthBloc>().isUserMobileLogin == '1') ...[
            if (((context.watch<AuthBloc>().selectLoginMethods == false &&
                    context.read<AuthBloc>().isUserSignInMobileOtp == '1' ||
                context.watch<AuthBloc>().selectLoginMethods == true &&
                    context.read<AuthBloc>().isUserSignInEmailOtp == '1')))
              InkWell(
                onTap: () {
                  final authBloc = context.read<AuthBloc>();
                  final mobileOrEmail = authBloc.selectLoginMethods
                      ? authBloc.rEmailController.text.trim()
                      : authBloc.rMobileController.text.trim();
                  FocusScope.of(context).unfocus();
                  if (mobileOrEmail.isEmpty) {
                    showToast(
                        message: AppLocalizations.of(context)!
                            .pleaseEnterMobileOrEmail);
                  } else {
                    final mobileNumber =
                        context.read<AuthBloc>().rMobileController.text.trim();
                    final email =
                        context.read<AuthBloc>().rEmailController.text;

                    context.read<AuthBloc>().add(VerifyUserEvent(
                        mobileOrEmail:
                            (context.read<AuthBloc>().selectLoginMethods)
                                ? email
                                : mobileNumber,
                        loginByMobile:
                            (context.read<AuthBloc>().selectLoginMethods)
                                ? true
                                : false,
                        forgotPassword: false));
                  }
                },
                child: MyText(
                  text: AppLocalizations.of(context)!.signInUsingOtp,
                  textStyle: AppTextStyle.body(
                      size: 12.5,
                      weight: FontWeight.w700,
                      color: AppColors.meshwarRed),
                ),
              ),
          ] else if (context.read<AuthBloc>().isUserEmailLogin == '0' &&
              context.read<AuthBloc>().isUserMobileLogin == '1') ...[
            if (((context.read<AuthBloc>().isUserSignInMobileOtp == '1')))
              InkWell(
                onTap: () {
                  context.read<AuthBloc>().selectLoginMethods = false;
                  final authBloc = context.read<AuthBloc>();
                  final mobileOrEmail = authBloc.rMobileController.text.trim();
                  FocusScope.of(context).unfocus();
                  if (mobileOrEmail.isEmpty) {
                    showToast(
                        message: AppLocalizations.of(context)!
                            .pleaseEnterMobileOrEmail);
                  } else {
                    final mobileNumber =
                        context.read<AuthBloc>().rMobileController.text.trim();

                    context.read<AuthBloc>().add(VerifyUserEvent(
                        mobileOrEmail: mobileNumber,
                        loginByMobile: false,
                        forgotPassword: false));
                  }
                },
                child: MyText(
                  text: AppLocalizations.of(context)!.signInUsingOtp,
                  textStyle: AppTextStyle.body(
                      size: 12.5,
                      weight: FontWeight.w700,
                      color: AppColors.meshwarRed),
                ),
              )
          ] else if (context.read<AuthBloc>().isUserEmailLogin == '1' &&
              context.read<AuthBloc>().isUserMobileLogin == '0') ...[
            if (((context.read<AuthBloc>().isUserSignInEmailOtp == '1')))
              InkWell(
                onTap: () {
                  context.read<AuthBloc>().selectLoginMethods = true;
                  final authBloc = context.read<AuthBloc>();
                  final mobileOrEmail = authBloc.rEmailController.text.trim();
                  FocusScope.of(context).unfocus();
                  if (mobileOrEmail.isEmpty) {
                    showToast(
                        message: AppLocalizations.of(context)!
                            .pleaseEnterMobileOrEmail);
                  } else {
                    final email =
                        context.read<AuthBloc>().rEmailController.text;

                    context.read<AuthBloc>().add(VerifyUserEvent(
                        mobileOrEmail: email,
                        loginByMobile: true,
                        forgotPassword: false));
                  }
                },
                child: MyText(
                  text: AppLocalizations.of(context)!.signInUsingOtp,
                  textStyle: AppTextStyle.body(
                      size: 12.5,
                      weight: FontWeight.w700,
                      color: AppColors.meshwarRed),
                ),
              ),
          ]
        ],
      ),
    );
  }

  Widget buildPinField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: AppLocalizations.of(context)!.enterOtp,
          textStyle: AppTextStyle.body(
              size: 13,
              weight: FontWeight.w700,
              color: Theme.of(context).primaryColorDark),
        ),
        const SizedBox(height: 10),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: MaterialPinField(
            pinController: context.read<AuthBloc>().otpController,
            autoFocus: true,
            length: 6,
            obscureText: false,
            blinkWhenObscuring: false,
            enableAutofill: false,
            keyboardType: TextInputType.number,
            theme: MaterialPinTheme(
              textStyle: AppTextStyle.mono(
                  size: 18,
                  weight: FontWeight.w700,
                  color: Theme.of(context).primaryColorDark),
              entryAnimation: MaterialPinAnimation.fade,
              animationDuration: const Duration(milliseconds: 300),
              shape: MaterialPinShape.outlined,
              borderRadius: BorderRadius.circular(12),
              cellSize: const Size(46, 46),
              filledFillColor: AppColors.surface(context),
              fillColor: AppColors.surface(context),
              borderColor: AppColors.surfaceBorder(context),
              focusedFillColor: AppColors.surfaceStrong(context),
              focusedBorderColor: AppColors.meshwarRed,
              filledBorderColor: AppColors.meshwarRed,
              borderWidth: 1,
              focusedBorderWidth: 1.4,
              cursorColor: AppColors.meshwarRed,
              boxShadows: const [],
            ),
            onChanged: (_) => context.read<AuthBloc>().add(OTPOnChangeEvent()),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: context.read<AuthBloc>().timerDuration != 0
                  ? null
                  // Was an empty closure — tapping Resend OTP while
                  // unlocked did nothing at all. Mirrors the same
                  // SignInWithOTPEvent dispatch used for the initial send
                  // above.
                  : () {
                      final authBloc = context.read<AuthBloc>();
                      final mobileOrEmail = authBloc.selectLoginMethods
                          ? authBloc.rEmailController.text.trim()
                          : authBloc.rMobileController.text.trim();
                      authBloc.isOtpVerify = true;
                      authBloc.add(
                        SignInWithOTPEvent(
                          isOtpVerify: true,
                          isForgotPassword: false,
                          mobileOrEmail: mobileOrEmail,
                          dialCode: authBloc.dialCode,
                          isLoginByEmail: authBloc.selectLoginMethods,
                          context: context,
                        ),
                      );
                      timerCount(context, duration: 60);
                    },
              child: MyText(
                text: context.read<AuthBloc>().timerDuration != 0
                    ? '${AppLocalizations.of(context)!.resendOtp} 00:${context.read<AuthBloc>().timerDuration}'
                    : AppLocalizations.of(context)!.resendOtp,
                textStyle: AppTextStyle.mono(
                  size: 12.5,
                  weight: FontWeight.w600,
                  color: context.read<AuthBloc>().timerDuration != 0
                      ? AppColors.darkGrey
                      : AppColors.meshwarRed,
                ),
              ),
            ),
            if (((context.read<AuthBloc>().selectLoginMethods == false &&
                    context.read<AuthBloc>().isUserSignInMobilePassword ==
                        '1' ||
                context.watch<AuthBloc>().selectLoginMethods == true &&
                    context.read<AuthBloc>().isUserSignInEmailPassword == '1')))
              InkWell(
                onTap: () {
                  context.read<AuthBloc>().isOtpVerify = false;
                  FocusScope.of(context).unfocus();
                  context
                      .read<AuthBloc>()
                      .add(OtpVerifyEvent(isOtpVerify: false));
                  timerCount(context, duration: 0, isCloseTimer: true);
                },
                child: MyText(
                  text: AppLocalizations.of(context)!.signUsingPassword,
                  textStyle: AppTextStyle.body(
                      size: 12.5,
                      weight: FontWeight.w700,
                      color: AppColors.meshwarRed),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return ((context.read<AuthBloc>().isUserEmailLogin == '1' &&
                context.read<AuthBloc>().isUserMobileLogin == '1'))
            ? CustomButton(
                borderRadius: 30,
                height: 60,
                gradient: const LinearGradient(
                  colors: [AppColors.meshwarRed, AppColors.signalRose],
                ),
                width: MediaQuery.sizeOf(context).width,
                buttonName: ((context.read<AuthBloc>().selectLoginMethods ==
                                true &&
                            context
                                    .read<AuthBloc>()
                                    .isUserSignInEmailPassword ==
                                '0' &&
                            context.read<AuthBloc>().isUserSignInEmailOtp ==
                                '1' &&
                            context.read<AuthBloc>().isOtpVerify == false) ||
                        (context.read<AuthBloc>().selectLoginMethods == false &&
                            context
                                    .read<AuthBloc>()
                                    .isUserSignInMobilePassword ==
                                '0' &&
                            context.read<AuthBloc>().isUserSignInMobileOtp ==
                                '1' &&
                            context.read<AuthBloc>().isOtpVerify == false))
                    ? AppLocalizations.of(context)!.sendOtp
                    : AppLocalizations.of(context)!.signIn,
                textSize: 18,
                isLoader: context.read<AuthBloc>().isLoading,
                onTap: () {
                  if (context.read<AuthBloc>().selectLoginMethods == false &&
                          context.read<AuthBloc>().isUserSignInMobilePassword ==
                              '0' &&
                          context.read<AuthBloc>().isUserSignInMobileOtp ==
                              '1' &&
                          context.read<AuthBloc>().isOtpVerify == false ||
                      context.read<AuthBloc>().selectLoginMethods == true &&
                          context.read<AuthBloc>().isUserSignInEmailPassword ==
                              '0' &&
                          context.read<AuthBloc>().isUserSignInEmailOtp ==
                              '1' &&
                          context.read<AuthBloc>().isOtpVerify == false) {
                    context.read<AuthBloc>();
                    final mobileNumber =
                        context.read<AuthBloc>().rMobileController.text.trim();
                    final email =
                        context.read<AuthBloc>().rEmailController.text;

                    context.read<AuthBloc>().add(VerifyUserEvent(
                        mobileOrEmail:
                            (context.read<AuthBloc>().selectLoginMethods)
                                ? email
                                : mobileNumber,
                        loginByMobile:
                            (context.read<AuthBloc>().selectLoginMethods)
                                ? true
                                : false,
                        forgotPassword: false));
                  } else {
                    final mobileNumber =
                        context.read<AuthBloc>().rMobileController.text.trim();
                    final password =
                        context.read<AuthBloc>().passwordController.text.trim();
                    final email =
                        context.read<AuthBloc>().rEmailController.text;
                    if (context.read<AuthBloc>().isOtpVerify) {
                      // OTPverify
                      context.read<AuthBloc>().add(
                            ConfirmOrVerifyOTPEvent(
                              isUserExist: context.read<AuthBloc>().userExist,
                              isLoginByEmail:
                                  (context.read<AuthBloc>().selectLoginMethods)
                                      ? true
                                      : false,
                              isOtpVerify: context.read<AuthBloc>().isOtpVerify,
                              isForgotPasswordVerify: false,
                              mobileOrEmail:
                                  (context.read<AuthBloc>().selectLoginMethods)
                                      ? email
                                      : mobileNumber,
                              otp: context.read<AuthBloc>().otpController.text,
                              password: password,
                              firebaseVerificationId: context
                                  .read<AuthBloc>()
                                  .firebaseVerificationId,
                              context: context,
                            ),
                          );
                    } else {
                      // PasswordLogin
                      context.read<AuthBloc>().add(LoginUserEvent(
                            emailOrMobile:
                                (context.read<AuthBloc>().selectLoginMethods)
                                    ? email
                                    : mobileNumber,
                            otp: context.read<AuthBloc>().otpController.text,
                            password: context
                                .read<AuthBloc>()
                                .passwordController
                                .text,
                            isOtpLogin: context.read<AuthBloc>().isOtpVerify,
                            isLoginByEmail:
                                (context.read<AuthBloc>().selectLoginMethods)
                                    ? true
                                    : false,
                            context: context,
                          ));
                    }
                  }
                },
              )
            : ((context.read<AuthBloc>().isUserEmailLogin == '1' &&
                    context.read<AuthBloc>().isUserMobileLogin == '0'))
                ? CustomButton(
                    borderRadius: 30,
                    height: 60,
                    gradient: const LinearGradient(
                      colors: [AppColors.meshwarRed, AppColors.signalRose],
                    ),
                    width: MediaQuery.sizeOf(context).width,
                    buttonName: ((context
                                        .read<AuthBloc>()
                                        .isUserSignInEmailPassword ==
                                    '0' &&
                                context.read<AuthBloc>().isUserSignInEmailOtp ==
                                    '1' &&
                                context.read<AuthBloc>().isOtpVerify ==
                                    false) ||
                            (context
                                        .read<AuthBloc>()
                                        .isUserSignInMobilePassword ==
                                    '0' &&
                                context
                                        .read<AuthBloc>()
                                        .isUserSignInMobileOtp ==
                                    '1' &&
                                context.read<AuthBloc>().isOtpVerify == false))
                        ? AppLocalizations.of(context)!.sendOtp
                        : AppLocalizations.of(context)!.signIn,
                    textSize: 18,
                    isLoader: context.read<AuthBloc>().isLoading,
                    onTap: () {
                      context.read<AuthBloc>().selectLoginMethods = true;
                      if (context.read<AuthBloc>().isUserSignInMobilePassword ==
                                  '0' &&
                              context.read<AuthBloc>().isUserSignInMobileOtp ==
                                  '1' &&
                              context.read<AuthBloc>().isOtpVerify == false ||
                          context.read<AuthBloc>().isUserSignInEmailPassword ==
                                  '0' &&
                              context.read<AuthBloc>().isUserSignInEmailOtp ==
                                  '1' &&
                              context.read<AuthBloc>().isOtpVerify == false) {
                        context.read<AuthBloc>();
                        final email =
                            context.read<AuthBloc>().rEmailController.text;

                        context.read<AuthBloc>().add(VerifyUserEvent(
                            mobileOrEmail: email,
                            loginByMobile: true,
                            forgotPassword: false));
                      } else {
                        final password = context
                            .read<AuthBloc>()
                            .passwordController
                            .text
                            .trim();
                        final email =
                            context.read<AuthBloc>().rEmailController.text;
                        if (context.read<AuthBloc>().isOtpVerify) {
                          // OTPverify
                          context.read<AuthBloc>().add(
                                ConfirmOrVerifyOTPEvent(
                                  isUserExist:
                                      context.read<AuthBloc>().userExist,
                                  isLoginByEmail: true,
                                  isOtpVerify:
                                      context.read<AuthBloc>().isOtpVerify,
                                  isForgotPasswordVerify: false,
                                  mobileOrEmail: email,
                                  otp: context
                                      .read<AuthBloc>()
                                      .otpController
                                      .text,
                                  password: password,
                                  firebaseVerificationId: context
                                      .read<AuthBloc>()
                                      .firebaseVerificationId,
                                  context: context,
                                ),
                              );
                        } else {
                          // PasswordLogin
                          context.read<AuthBloc>().add(LoginUserEvent(
                                emailOrMobile: email,
                                otp:
                                    context.read<AuthBloc>().otpController.text,
                                password: context
                                    .read<AuthBloc>()
                                    .passwordController
                                    .text,
                                isOtpLogin:
                                    context.read<AuthBloc>().isOtpVerify,
                                isLoginByEmail: true,
                                context: context,
                              ));
                        }
                      }
                    },
                  )
                : ((context.read<AuthBloc>().isUserEmailLogin == '0' &&
                        context.read<AuthBloc>().isUserMobileLogin == '1'))
                    ? CustomButton(
                        borderRadius: 30,
                        height: 60,
                        gradient: const LinearGradient(
                          colors: [AppColors.meshwarRed, AppColors.signalRose],
                        ),
                        width: MediaQuery.sizeOf(context).width,
                        buttonName:
                            ((context.read<AuthBloc>().selectLoginMethods ==
                                            true &&
                                        context
                                                .read<AuthBloc>()
                                                .isUserSignInEmailPassword ==
                                            '0' &&
                                        context
                                                .read<AuthBloc>()
                                                .isUserSignInEmailOtp ==
                                            '1' &&
                                        context.read<AuthBloc>().isOtpVerify ==
                                            false) ||
                                    (context
                                                .read<AuthBloc>()
                                                .selectLoginMethods ==
                                            false &&
                                        context
                                                .read<AuthBloc>()
                                                .isUserSignInMobilePassword ==
                                            '0' &&
                                        context
                                                .read<AuthBloc>()
                                                .isUserSignInMobileOtp ==
                                            '1' &&
                                        context.read<AuthBloc>().isOtpVerify ==
                                            false))
                                ? AppLocalizations.of(context)!.sendOtp
                                : AppLocalizations.of(context)!.signIn,
                        textSize: 18,
                        isLoader: context.read<AuthBloc>().isLoading,
                        onTap: () {
                          context.read<AuthBloc>().selectLoginMethods = false;
                          if (context.read<AuthBloc>().selectLoginMethods ==
                                      false &&
                                  context
                                          .read<AuthBloc>()
                                          .isUserSignInMobilePassword ==
                                      '0' &&
                                  context
                                          .read<AuthBloc>()
                                          .isUserSignInMobileOtp ==
                                      '1' &&
                                  context.read<AuthBloc>().isOtpVerify ==
                                      false ||
                              context
                                          .read<AuthBloc>()
                                          .selectLoginMethods ==
                                      true &&
                                  context
                                          .read<AuthBloc>()
                                          .isUserSignInEmailPassword ==
                                      '0' &&
                                  context
                                          .read<AuthBloc>()
                                          .isUserSignInEmailOtp ==
                                      '1' &&
                                  context.read<AuthBloc>().isOtpVerify ==
                                      false) {
                            context.read<AuthBloc>();
                            final mobileNumber = context
                                .read<AuthBloc>()
                                .rMobileController
                                .text
                                .trim();

                            context.read<AuthBloc>().add(VerifyUserEvent(
                                mobileOrEmail: mobileNumber,
                                loginByMobile: false,
                                forgotPassword: false));
                          } else {
                            final mobileNumber = context
                                .read<AuthBloc>()
                                .rMobileController
                                .text
                                .trim();
                            final password = context
                                .read<AuthBloc>()
                                .passwordController
                                .text
                                .trim();
                            if (context.read<AuthBloc>().isOtpVerify) {
                              // OTPverify
                              context.read<AuthBloc>().add(
                                    ConfirmOrVerifyOTPEvent(
                                      isUserExist:
                                          context.read<AuthBloc>().userExist,
                                      isLoginByEmail: false,
                                      isOtpVerify:
                                          context.read<AuthBloc>().isOtpVerify,
                                      isForgotPasswordVerify: false,
                                      mobileOrEmail: mobileNumber,
                                      otp: context
                                          .read<AuthBloc>()
                                          .otpController
                                          .text,
                                      password: password,
                                      firebaseVerificationId: context
                                          .read<AuthBloc>()
                                          .firebaseVerificationId,
                                      context: context,
                                    ),
                                  );
                            } else {
                              // PasswordLogin
                              context.read<AuthBloc>().add(LoginUserEvent(
                                    emailOrMobile: mobileNumber,
                                    otp: context
                                        .read<AuthBloc>()
                                        .otpController
                                        .text,
                                    password: context
                                        .read<AuthBloc>()
                                        .passwordController
                                        .text,
                                    isOtpLogin:
                                        context.read<AuthBloc>().isOtpVerify,
                                    isLoginByEmail: false,
                                    context: context,
                                  ));
                            }
                          }
                        },
                      )
                    : _LoginButtonSkeleton(
                        width: MediaQuery.sizeOf(context).width);
      },
    );
  }
}

/// Groups sibling fields (e.g. phone + password) into one shared card with
/// a hairline divider between them, instead of each field carrying its own
/// border/shadow. Styled to match the destination page's address card
/// (buildLocationSelect in destination_page.dart): 24px radius, a plain
/// soft drop shadow instead of the red rim-glow, no border.
class _FieldGroup extends StatelessWidget {
  final List<Widget> children;
  const _FieldGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceStrong(context),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 26,
            spreadRadius: -6,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            if (i > 0)
              Container(height: 1, color: AppColors.surfaceBorder(context)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: children[i],
            ),
          ],
        ],
      ),
    );
  }
}

/// Mobile / Email segmented toggle rendered as a sliding glass pill.
class _MethodToggle extends StatelessWidget {
  final BuildContext context;
  const _MethodToggle({required this.context});

  @override
  Widget build(BuildContext ctx) {
    final selectEmail = context.watch<AuthBloc>().selectLoginMethods;
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceBorder(context)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleTab(
              label: AppLocalizations.of(context)!.mobile,
              active: !selectEmail,
              onTap: () {
                FocusScope.of(context).unfocus();
                context.read<AuthBloc>().isOtpVerify = false;
                context
                    .read<AuthBloc>()
                    .add(SelectLoginMethodEvent(selectLoginByEmail: false));
                context.read<AuthBloc>().rEmailController.clear();
                context.read<AuthBloc>().passwordController.clear();
                context.read<AuthBloc>().otpController.clear();
              },
            ),
          ),
          Expanded(
            child: _ToggleTab(
              label: AppLocalizations.of(context)!.email,
              active: selectEmail,
              onTap: () {
                FocusScope.of(context).unfocus();
                context.read<AuthBloc>().isOtpVerify = false;
                context
                    .read<AuthBloc>()
                    .add(SelectLoginMethodEvent(selectLoginByEmail: true));
                context.read<AuthBloc>().rMobileController.clear();
                context.read<AuthBloc>().passwordController.clear();
                context.read<AuthBloc>().otpController.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _ToggleTab(
      {required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: active ? AppColors.beaconGradient : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: MyText(
          text: label,
          textStyle: AppTextStyle.body(
            size: 14,
            weight: FontWeight.w700,
            color: active ? Colors.white : AppColors.darkGrey,
          ),
        ),
      ),
    );
  }
}

/// Shown in place of the Sign In button while `isUserEmailLogin`/
/// `isUserMobileLogin` haven't resolved to a recognized '1'/'0' combo yet
/// (e.g. before GetCommonModuleEvent finishes) — a visible loading bar
/// instead of a silently empty gap where the button should be.
class _LoginButtonSkeleton extends StatelessWidget {
  final double width;
  const _LoginButtonSkeleton({required this.width});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase(context),
      highlightColor: AppColors.shimmerHighlight(context),
      child: Container(
        height: 60,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.greyHeader,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
