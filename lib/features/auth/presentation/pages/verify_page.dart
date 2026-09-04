import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_background.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../loading/application/loader_bloc.dart';
import '../../application/auth_bloc.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';

class VerifyPage extends StatefulWidget {
  static const String routeName = '/verifyPage';
  final VerifyArguments arg;
  const VerifyPage({super.key, required this.arg});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage>
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
    return BlocProvider(
      create: (context) => AuthBloc()
        ..add(GetDirectionEvent())
        ..add(GetCommonModuleEvent()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitialState) {
            CustomLoader.loader(context);
          } else if (state is AuthDataLoadingState) {
            CustomLoader.loader(context);
          } else if (state is AuthDataSuccessState) {
            CustomLoader.dismiss(context);
            if (!widget.arg.userExist && widget.arg.isOtpVerify) {
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
            }
          } else if (state is ForgotPasswordOTPSendState) {
            Navigator.pushNamed(
              context,
              ForgotPasswordPage.routeName,
              arguments: ForgotPasswordPageArguments(
                isLoginByEmail: widget.arg.isLoginByEmail,
                contryCode: widget.arg.dialCode,
                countryFlag: widget.arg.countryFlag,
                emailOrMobile: widget.arg.mobileOrEmail,
              ),
            );
          } else if (state is NewUserRegisterState) {
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
          } else if (state is LoginSuccessState ||
              state is ConfirmMobileOrEmailState) {
            context.read<LoaderBloc>().add(UpdateUserLocationEvent());
            Navigator.pushNamedAndRemoveUntil(
                context, HomePage.routeName, (route) => false);
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
                  resizeToAvoidBottomInset: true,
                  body: CustomBackground(
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            SizedBox(
                                height:
                                MediaQuery.of(context).size.width * 0.1),
                            context.read<AuthBloc>().isOtpVerify
                                ? MyText(
                              text: widget.arg.isLoginByEmail
                                  ? AppLocalizations.of(context)!
                                  .otpSendContent
                                  : AppLocalizations.of(context)!
                                  .testOtp
                                  .replaceAll('***', '123456'),
                              textAlign: TextAlign.center,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                color: AppColors.greyHintColor,
                              ),
                            )
                                : MyText(
                              text: AppLocalizations.of(context)!
                                  .passwordContent,
                              textAlign: TextAlign.center,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                color: AppColors.greyHintColor,
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 20),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                if (!widget.arg.isLoginByEmail)
                                  SizedBox(
                                    height: 20,
                                    width: 30,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: CachedNetworkImage(
                                        imageUrl: widget.arg.countryFlag,
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) =>
                                        const Center(
                                          child: Loader(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                        const Center(
                                          child: Text(""),
                                        ),
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 10),
                                MyText(
                                  text: widget.arg.mobileOrEmail,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                    color: AppColors.black,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: MyText(
                                    text: AppLocalizations.of(context)!.change,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            if (widget.arg.userExist &&
                                !context.read<AuthBloc>().isOtpVerify)
                              passwordField(context),
                            if (!widget.arg.userExist ||
                                context.read<AuthBloc>().isOtpVerify)
                              buildPinField(context),
                            const SizedBox(height: 20),
                            buildLoginButton(context),
                          ],
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

  Widget passwordField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: AppLocalizations.of(context)!.password,
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: AppColors.black, fontSize: 16),
            ),
            InkWell(
              onTap: () {
                context.read<AuthBloc>().isOtpVerify = true;
                context.read<AuthBloc>().add(SignInWithOTPEvent(
                  isOtpVerify: true,
                  isForgotPassword: false,
                  dialCode: widget.arg.dialCode,
                  mobileOrEmail: widget.arg.mobileOrEmail,
                  isLoginByEmail: widget.arg.isLoginByEmail,
                  context: context,
                ));

                timerCount(context, duration: 60);
              },
              child: MyText(
                text: AppLocalizations.of(context)!.signInUsingOtp,
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: context.read<AuthBloc>().passwordController,
          filled: true,
          obscureText: !context.read<AuthBloc>().showPassword,
          hintText: AppLocalizations.of(context)!.enterYourPassword,
          suffixIcon: InkWell(
            onTap: () {
              context.read<AuthBloc>().add(ShowPasswordIconEvent(
                  showPassword: context.read<AuthBloc>().showPassword));
            },
            child: !context.read<AuthBloc>().showPassword
                ? const Icon(
              Icons.visibility_off_outlined,
              color: AppColors.darkGrey,
            )
                : const Icon(
              Icons.visibility,
              color: AppColors.darkGrey,
            ),
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () {
            context.read<AuthBloc>().add(
              SignInWithOTPEvent(
                isOtpVerify: true,
                isForgotPassword: true,
                mobileOrEmail: widget.arg.mobileOrEmail,
                dialCode: widget.arg.dialCode,
                isLoginByEmail: widget.arg.isLoginByEmail,
                context: context,
              ),
            );
          },
          child: MyText(
            text: '${AppLocalizations.of(context)!.forgetPassword} ?',
            textStyle: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: AppColors.greyHintColor, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget buildPinField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: AppLocalizations.of(context)!.enterOtp,
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: AppColors.black, fontSize: 16),
            ),
            if (widget.arg.userExist &&
                context.read<AuthBloc>().timerDuration == 0)
              InkWell(
                onTap: () {
                  context.read<AuthBloc>().isOtpVerify = false;
                  timerCount(context, duration: 0, isCloseTimer: true);
                },
                child: MyText(
                  text: AppLocalizations.of(context)!.signInUsingPass,
                  textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        MaterialPinField(
          pinController: context.read<AuthBloc>().otpController,
          length: 6,
          obscureText: false,
          autoFocus: true,
          blinkWhenObscuring: false,
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
            borderColor: Theme.of(context).scaffoldBackgroundColor,
            focusedFillColor: Theme.of(context).scaffoldBackgroundColor,
            focusedBorderColor: Theme.of(context).disabledColor,
            filledBorderColor: Theme.of(context).scaffoldBackgroundColor,
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
        InkWell(
          onTap: context.read<AuthBloc>().timerDuration != 0
              ? null
              : () {
            context.read<AuthBloc>().add(
              SignInWithOTPEvent(
                isOtpVerify: true,
                isForgotPassword: false,
                dialCode: widget.arg.dialCode,
                mobileOrEmail: widget.arg.mobileOrEmail,
                isLoginByEmail: widget.arg.isLoginByEmail,
                context: context,
              ),
            );
            timerCount(context, duration: 60);
          },
          child: MyText(
            text: context.read<AuthBloc>().timerDuration != 0
                ? '${AppLocalizations.of(context)!.resendOtp} 00:${context.read<AuthBloc>().timerDuration}'
                : AppLocalizations.of(context)!.resendOtp,
            textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: context.read<AuthBloc>().timerDuration != 0
                  ? AppColors.greyHintColor
                  : AppColors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: CustomButton(
            borderRadius: 10,
            height: MediaQuery.of(context).size.height * 0.06,
            buttonName: (!widget.arg.userExist)
                ? AppLocalizations.of(context)!.confirm
                : AppLocalizations.of(context)!.login,
            isLoader: context.read<AuthBloc>().isLoading,
            onTap: () {
              if (widget.arg.isOtpVerify ||
                  context.read<AuthBloc>().isOtpVerify) {
                // OTPverify
                context.read<AuthBloc>().add(
                  ConfirmOrVerifyOTPEvent(
                    isUserExist: widget.arg.userExist,
                    isLoginByEmail: widget.arg.isLoginByEmail,
                    isOtpVerify: context.read<AuthBloc>().isOtpVerify,
                    isForgotPasswordVerify: false,
                    mobileOrEmail: widget.arg.mobileOrEmail,
                    otp: context.read<AuthBloc>().otpController.text,
                    password:
                    context.read<AuthBloc>().passwordController.text,
                    firebaseVerificationId:
                    context.read<AuthBloc>().firebaseVerificationId,
                    context: context,
                  ),
                );
              } else {
                // PasswordLogin
                context.read<AuthBloc>().add(LoginUserEvent(
                  emailOrMobile: widget.arg.mobileOrEmail,
                  otp: context.read<AuthBloc>().otpController.text,
                  password:
                  context.read<AuthBloc>().passwordController.text,
                  isOtpLogin: context.read<AuthBloc>().isOtpVerify,
                  isLoginByEmail: widget.arg.isLoginByEmail,
                  context: context,
                ));
              }
            },
          ),
        );
      },
    );
  }
}