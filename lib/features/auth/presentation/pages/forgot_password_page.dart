// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_appbar.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/auth_bloc.dart';
import 'login_page.dart';
import 'update_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const String routeName = '/forgotPasswordPage';
  final ForgotPasswordPageArguments arg;
  const ForgotPasswordPage({super.key, required this.arg});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
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
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AuthBloc()..add(GetDirectionEvent()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitialState) {
            CustomLoader.loader(context);
          }
          if (state is AuthDataLoadingState) {
            CustomLoader.loader(context);
          }
          if (state is AuthDataLoadedState) {
            final authBloc = context.read<AuthBloc>();
            CustomLoader.dismiss(context);
            authBloc.isOtpVerify = true;
            authBloc.add(
              SignInWithOTPEvent(
                isOtpVerify: true,
                isForgotPassword: true,
                dialCode: widget.arg.contryCode,
                mobileOrEmail: widget.arg.emailOrMobile,
                isLoginByEmail: widget.arg.isLoginByEmail,
                context: context,
              ),
            );
            timerCount(context, duration: 60);
          }
          if (state is AuthDataSuccessState) {
            CustomLoader.dismiss(context);
          }
          if (state is ForgotPasswordOTPVerifyState) {
            Navigator.pushNamed(context, UpdatePasswordPage.routeName,
                arguments: UpdatePasswordPageArguments(
                    isLoginByEmail: widget.arg.isLoginByEmail,
                    emailOrMobile: widget.arg.emailOrMobile));
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Directionality(
                textDirection: context.read<AuthBloc>().textDirection == 'rtl'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Scaffold(
                  appBar: CustomAppBar(
                    title: AppLocalizations.of(context)!.forgetPassword,
                    automaticallyImplyLeading: true,
                    titleFontSize: 18,
                    textColor: Theme.of(context).primaryColorDark,
                  ),
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: context.read<AuthBloc>().formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(
                                    size.width * 0.025,
                                    size.width * 0.05,
                                    size.width * 0.025,
                                    size.width * 0.05),
                                width: MediaQuery.sizeOf(context).width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 1.2,
                                      color: const Color(0xffFAFAFB)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                      text: AppLocalizations.of(context)!
                                          .sendCode,
                                      textAlign: TextAlign.center,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                          color:
                                          Theme.of(context).hintColor,
                                          fontSize: 14),
                                    ),
                                    SizedBox(
                                      height: size.width * 0.05,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            if (widget.arg.isLoginByEmail ==
                                                false)
                                              MyText(
                                                text: widget.arg.contryCode,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(fontSize: 18),
                                              ),
                                            SizedBox(
                                              width: size.width * 0.45,
                                              child: MyText(
                                                text: widget.arg.emailOrMobile,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                    fontSize: (widget.arg
                                                        .isLoginByEmail ==
                                                        false)
                                                        ? 18
                                                        : 16),
                                                maxLines: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                LoginPage.routeName,
                                                    (route) => false);
                                          },
                                          child: MyText(
                                            text: (widget.arg.isLoginByEmail ==
                                                false)
                                                ? AppLocalizations.of(context)!
                                                .changeNumber
                                                : AppLocalizations.of(context)!
                                                .changeEmail,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                              color: AppColors.primary,
                                              fontSize: ((context
                                                  .read<
                                                  AuthBloc>()
                                                  .languageCode ==
                                                  'fr' ||
                                                  context
                                                      .read<
                                                      AuthBloc>()
                                                      .languageCode ==
                                                      'az' ||
                                                  (context
                                                      .read<
                                                      AuthBloc>()
                                                      .languageCode ==
                                                      'es') ||
                                                  context
                                                      .read<
                                                      AuthBloc>()
                                                      .languageCode ==
                                                      'sq'))
                                                  ? 10
                                                  : 11,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: size.width * 0.1),
                              Container(
                                  padding: EdgeInsets.all(size.width * 0.025),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xffFAFAFB)),
                                  child: buildPinField(context)),
                              SizedBox(height: size.width * 0.02),
                              SizedBox(height: size.width * 0.1),
                              buildButton(context),
                              SizedBox(height: size.width * 0.3),
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

  Widget buildButton(BuildContext context) {
    return Center(
      child: CustomButton(
        buttonName: AppLocalizations.of(context)!.confirm,
        borderRadius: 10,
        textSize: 16,
        width: MediaQuery.sizeOf(context).width,
        isLoader: context.read<AuthBloc>().isLoading,
        onTap: () {
          context.read<AuthBloc>().add(
            ConfirmOrVerifyOTPEvent(
              isUserExist: true,
              isLoginByEmail: widget.arg.isLoginByEmail,
              isOtpVerify: true,
              isForgotPasswordVerify: true,
              mobileOrEmail: widget.arg.emailOrMobile,
              otp: context.read<AuthBloc>().otpController.text,
              password: '',
              firebaseVerificationId:
              context.read<AuthBloc>().firebaseVerificationId,
              context: context,
            ),
          );
        },
      ),
    );
  }

  Widget buildPinField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: AppLocalizations.of(context)!.enterOtp,
          textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 16,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        const SizedBox(height: 10),
        MaterialPinField(
          pinController: context.read<AuthBloc>().otpController,
          length: 6,
          obscureText: false,
          blinkWhenObscuring: false,
          autoFocus: true,
          enableAutofill: false,
          keyboardType: TextInputType.number,
          theme: MaterialPinTheme(
            textStyle: Theme.of(context).textTheme.bodyLarge,
            entryAnimation: MaterialPinAnimation.fade,
            animationDuration: const Duration(milliseconds: 300),
            shape: MaterialPinShape.outlined,
            borderRadius: BorderRadius.circular(12),
            cellSize: const Size(45, 45),
            filledFillColor: Theme.of(context).scaffoldBackgroundColor,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            borderColor: AppColors.borderColors,
            focusedFillColor: Theme.of(context).scaffoldBackgroundColor,
            focusedBorderColor: Theme.of(context).disabledColor,
            filledBorderColor: AppColors.borderColors,
            borderWidth: 1,
            focusedBorderWidth: 1,
            cursorColor: Theme.of(context).dividerColor,
            boxShadows: const [
              BoxShadow(
                offset: Offset(0, 1),
                color: Colors.black12,
                blurRadius: 10,
              )
            ],
          ),
          onChanged: (_) => context.read<AuthBloc>().add(OTPOnChangeEvent()),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: context.read<AuthBloc>().timerDuration != 0
                  ? '${AppLocalizations.of(context)!.resendOtp}  00:${context.read<AuthBloc>().timerDuration}'
                  : '${AppLocalizations.of(context)!.resendOtp} 00:00',
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: context.read<AuthBloc>().timerDuration != 0
                    ? Theme.of(context).hintColor
                    : Theme.of(context).primaryColorDark,
                fontSize: ((context.read<AuthBloc>().languageCode == 'fr' ||
                    context.read<AuthBloc>().languageCode == 'az' ||
                    (context.read<AuthBloc>().languageCode == 'es') ||
                    context.read<AuthBloc>().languageCode == 'sq'))
                    ? 10
                    : 14,
              ),
            ),
            InkWell(
              onTap: context.read<AuthBloc>().timerDuration != 0
                  ? null
                  : () {
                context.read<AuthBloc>().add(
                  SignInWithOTPEvent(
                    isOtpVerify: true,
                    isForgotPassword: true,
                    dialCode: widget.arg.contryCode,
                    mobileOrEmail: widget.arg.emailOrMobile,
                    isLoginByEmail: widget.arg.isLoginByEmail,
                    context: context,
                  ),
                );
                timerCount(context, duration: 60);
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.white,
                    border:
                    Border.all(width: 1.1, color: AppColors.borderColors)),
                child: MyText(
                  text: AppLocalizations.of(context)!.resendOtp,
                  textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: ((context.read<AuthBloc>().languageCode ==
                        'fr' ||
                        context.read<AuthBloc>().languageCode == 'az' ||
                        (context.read<AuthBloc>().languageCode ==
                            'es') ||
                        context.read<AuthBloc>().languageCode == 'sq'))
                        ? 10
                        : 14,
                    color: context.read<AuthBloc>().timerDuration != 0
                        ? AppColors.primary.withOpacity(0.5)
                        : AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}