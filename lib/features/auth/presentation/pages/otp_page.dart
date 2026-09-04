// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meshwar_user/features/auth/presentation/pages/register_page.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../common/app_arguments.dart';
import '../../../../common/app_colors.dart';
import '../../../../common/app_text_styles.dart';
import '../../../../core/utils/custom_appbar.dart';
import '../../../../core/utils/custom_background.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../loading/application/loader_bloc.dart';
import '../../application/auth_bloc.dart';

class OtpPage extends StatefulWidget {
  static const String routeName = '/otpPage';
  final OtpPageArguments arg;

  const OtpPage({super.key, required this.arg});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with SingleTickerProviderStateMixin {
  Timer? timer;
  timerCount(BuildContext cont,
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
            final authBloc = context.read<AuthBloc>();
            authBloc.isOtpVerify = true;
            authBloc.add(
              SignInWithOTPEvent(
                isOtpVerify: widget.arg.isOtpVerify,
                isForgotPassword: false,
                mobileOrEmail: widget.arg.mobileOrEmail,
                dialCode: widget.arg.dialCode,
                isLoginByEmail: widget.arg.isLoginByEmail,
                context: context,
              ),
            );
            timerCount(context, duration: 60);
          } else if (state is GetCommonModuleFailure) {
            CustomLoader.dismiss(context);
          } else if (state is AuthDataSuccessState) {
            CustomLoader.dismiss(context);
          } else if (state is LoginLoadingState) {
            CustomLoader.loader(context);
          } else if (state is LoginFailureState) {
            CustomLoader.dismiss(context);
          } else if (state is NewUserRegisterState) {
            if (mounted) {
              Navigator.pushNamed(context, RegisterPage.routeName,
                  arguments: RegisterPageArguments(
                    isLoginByEmail: widget.arg.isLoginByEmail,
                    dialCode: widget.arg.dialCode,
                    contryCode: widget.arg.countryCode,
                    countryFlag: widget.arg.countryFlag,
                    emailOrMobile: widget.arg.mobileOrEmail,
                    countryList: widget.arg.countryList,
                    isRefferalEarnings: widget.arg.isRefferalEarnings,
                  ));
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
              resizeToAvoidBottomInset: true,
              extendBodyBehindAppBar: true,
              appBar: CustomAppBar(
                title: AppLocalizations.of(context)!.verifyYourAccount,
                automaticallyImplyLeading: true,
                titleFontSize: 17,
                textColor: AppColors.white,
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
                          SizedBox(height: size.width * 0.06),
                          _DestinationChip(
                            dialCode: widget.arg.isLoginByEmail ? null : widget.arg.dialCode,
                            value: widget.arg.mobileOrEmail,
                            changeLabel: widget.arg.isLoginByEmail
                                ? AppLocalizations.of(context)!.changeEmail
                                : AppLocalizations.of(context)!.changeNumber,
                            onChange: () => Navigator.pop(context),
                          ),
                          SizedBox(height: size.width * 0.09),
                          _GlassPanel(child: buildPinField(context)),
                          SizedBox(height: size.width * 0.09),
                          buildSendOtpButton(context),
                          SizedBox(height: size.width * 0.1),
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

  Widget buildPinField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: AppLocalizations.of(context)!.enterOtp,
          textStyle: AppTextStyle.body(size: 14, weight: FontWeight.w700, color: AppColors.white),
        ),
        const SizedBox(height: 4),
        MyText(
          text: AppLocalizations.of(context)!.sendCode,
          textStyle: AppTextStyle.body(size: 12, weight: FontWeight.w500, color: AppColors.darkGrey),
        ),
        const SizedBox(height: 18),
        MaterialPinField(
          pinController: context.read<AuthBloc>().otpController,
          length: 6,
          obscureText: false,
          blinkWhenObscuring: false,
          autoFocus: true,
          enableAutofill: false,
          keyboardType: TextInputType.number,
          theme: MaterialPinTheme(
            textStyle: AppTextStyle.mono(size: 20, weight: FontWeight.w700, color: AppColors.white),
            entryAnimation: MaterialPinAnimation.fade,
            animationDuration: const Duration(milliseconds: 300),
            shape: MaterialPinShape.outlined,
            borderRadius: BorderRadius.circular(14),
            cellSize: const Size(48, 48),
            filledFillColor: AppColors.glassFillStrong,
            fillColor: AppColors.glassFill,
            borderColor: AppColors.glassBorder,
            focusedFillColor: AppColors.glassFillStrong,
            focusedBorderColor: AppColors.meshwarRed,
            filledBorderColor: AppColors.meshwarRed,
            borderWidth: 1,
            focusedBorderWidth: 1.4,
            cursorColor: AppColors.meshwarRed,
            boxShadows: [
              BoxShadow(
                color: AppColors.meshwarRed.withOpacity(0.15),
                blurRadius: 16,
                spreadRadius: -6,
              ),
            ],
          ),
          onChanged: (_) => context.read<AuthBloc>().add(OTPOnChangeEvent()),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: context.read<AuthBloc>().timerDuration != 0
                  ? '${AppLocalizations.of(context)!.resendOtp} 00:${context.read<AuthBloc>().timerDuration}'
                  : '${AppLocalizations.of(context)!.resendOtp} 00:00',
              textStyle: AppTextStyle.mono(
                size: 13,
                weight: FontWeight.w600,
                color: context.read<AuthBloc>().timerDuration != 0
                    ? AppColors.darkGrey
                    : AppColors.white,
              ),
            ),
            InkWell(
              onTap: context.read<AuthBloc>().timerDuration != 0
                  ? null
                  : () {
                final authBloc = context.read<AuthBloc>();
                authBloc.isOtpVerify = true;
                context.read<AuthBloc>().add(
                  SignInWithOTPEvent(
                    isOtpVerify: widget.arg.isOtpVerify,
                    isForgotPassword: false,
                    mobileOrEmail: widget.arg.mobileOrEmail,
                    dialCode: widget.arg.dialCode,
                    isLoginByEmail: widget.arg.isLoginByEmail,
                    context: context,
                  ),
                );
                timerCount(context, duration: 60);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: context.read<AuthBloc>().timerDuration != 0
                      ? Colors.transparent
                      : AppColors.glassFillStrong,
                  border: Border.all(
                    color: context.read<AuthBloc>().timerDuration != 0
                        ? AppColors.glassBorder
                        : AppColors.meshwarRed.withOpacity(0.5),
                  ),
                ),
                child: MyText(
                  text: AppLocalizations.of(context)!.resendOtp,
                  textStyle: AppTextStyle.body(
                    size: 12.5,
                    weight: FontWeight.w700,
                    color: context.read<AuthBloc>().timerDuration != 0
                        ? AppColors.darkGrey
                        : AppColors.meshwarRed,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSendOtpButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return CustomButton(
          borderRadius: 16,
          width: MediaQuery.sizeOf(context).width,
          buttonName: AppLocalizations.of(context)!.verifyOtp,
          textSize: 16,
          isLoader: context.read<AuthBloc>().isLoading,
          onTap: () {
            context.read<AuthBloc>().add(
              ConfirmOrVerifyOTPEvent(
                isUserExist: widget.arg.userExist,
                isLoginByEmail: widget.arg.isLoginByEmail,
                isOtpVerify: context.read<AuthBloc>().isOtpVerify,
                isForgotPasswordVerify: false,
                mobileOrEmail: widget.arg.mobileOrEmail,
                otp: context.read<AuthBloc>().otpController.text,
                password: context.read<AuthBloc>().passwordController.text,
                firebaseVerificationId: context.read<AuthBloc>().firebaseVerificationId,
                context: context,
              ),
            );
          },
        );
      },
    );
  }
}

/// Glass card wrapping the OTP field — a HUD-style readout panel.
class _GlassPanel extends StatelessWidget {
  final Widget child;
  const _GlassPanel({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.glassFill,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.meshwarRed.withOpacity(0.06),
            blurRadius: 30,
            spreadRadius: -12,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Shows the destination (mobile/email) as a glass "readout" chip with a
/// change action, replacing the bordered container from the original design.
class _DestinationChip extends StatelessWidget {
  final String? dialCode;
  final String value;
  final String changeLabel;
  final VoidCallback onChange;

  const _DestinationChip({
    required this.dialCode,
    required this.value,
    required this.changeLabel,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.glassFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (dialCode != null) ...[
                  MyText(
                    text: dialCode!,
                    textStyle:
                    AppTextStyle.mono(size: 16, weight: FontWeight.w700, color: AppColors.meshwarRed),
                  ),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: MyText(
                    text: value,
                    maxLines: 1,
                    textStyle:
                    AppTextStyle.mono(size: 15, weight: FontWeight.w600, color: AppColors.white),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onChange,
            child: MyText(
              text: changeLabel,
              textStyle: AppTextStyle.body(size: 12.5, weight: FontWeight.w700, color: AppColors.meshwarRed),
            ),
          ),
        ],
      ),
    );
  }
}