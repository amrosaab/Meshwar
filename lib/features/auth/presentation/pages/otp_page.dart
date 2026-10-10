// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meshwar_user/features/auth/presentation/pages/register_page.dart';

import '../../../../common/app_arguments.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../loading/application/loader_bloc.dart';
import '../../application/auth_bloc.dart';
import '../widgets/otp_content.dart';

class OtpPage extends StatefulWidget {
  static const String routeName = '/otpPage';
  final OtpPageArguments arg;

  const OtpPage({super.key, required this.arg});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with SingleTickerProviderStateMixin {
  Timer? timer;
  bool _preparing = false;

  void timerCount(BuildContext context,
      {required int duration, bool? isCloseTimer}) {
    timer?.cancel();
    final bloc = context.read<AuthBloc>();
    var remaining = isCloseTimer == true ? 0 : duration;
    bloc.add(VerifyTimerEvent(duration: remaining));
    if (remaining == 0) return;
    timer = Timer.periodic(const Duration(seconds: 1), (tick) {
      if (!mounted || bloc.isClosed) {
        tick.cancel();
        return;
      }
      remaining--;
      bloc.add(VerifyTimerEvent(duration: remaining));
      if (remaining == 0) tick.cancel();
    });
  }

  void _send(BuildContext context) {
    final bloc = context.read<AuthBloc>();
    bloc.isOtpVerify = true;
    bloc.add(SignInWithOTPEvent(
      isOtpVerify: widget.arg.isOtpVerify,
      isForgotPassword: false,
      mobileOrEmail: widget.arg.mobileOrEmail,
      dialCode: widget.arg.dialCode,
      isLoginByEmail: widget.arg.isLoginByEmail,
      context: context,
    ));
    timerCount(context, duration: 60);
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
        ..add(CountryGetEvent())
        ..add(GetCommonModuleEvent()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is GetCommonModuleLoading) {
            _preparing = true;
          } else if (state is GetCommonModuleSuccess) {
            _preparing = false;
            _send(context);
          } else if (state is GetCommonModuleFailure) {
            _preparing = false;
          } else if (state is SignInWithOTPFailureState) {
            // A failed send can be retried immediately. Cancel the actual
            // timer so a later tick cannot reinstate its cooldown.
            timerCount(context, duration: 0, isCloseTimer: true);
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
            final bloc = context.read<AuthBloc>();
            return Directionality(
              textDirection: bloc.textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: OtpVerificationLayout(
                email: widget.arg.isLoginByEmail,
                destination: widget.arg.isLoginByEmail
                    ? widget.arg.mobileOrEmail
                    : '${widget.arg.dialCode} ${widget.arg.mobileOrEmail}',
                controller: bloc.otpController.textController,
                remaining: bloc.timerDuration,
                busy: _preparing || bloc.isLoading,
                onChanged: (_) => bloc.add(OTPOnChangeEvent()),
                onChange: () => Navigator.pop(context),
                onResend: () {
                  if (!_preparing &&
                      !bloc.isLoading &&
                      bloc.timerDuration == 0) {
                    _send(context);
                  }
                },
                onVerify: () {
                  if (_preparing ||
                      bloc.isLoading ||
                      bloc.otpController.text.length != 6) {
                    return;
                  }
                  FocusScope.of(context).unfocus();
                  bloc.add(ConfirmOrVerifyOTPEvent(
                    isUserExist: widget.arg.userExist,
                    isLoginByEmail: widget.arg.isLoginByEmail,
                    isOtpVerify: bloc.isOtpVerify,
                    isForgotPasswordVerify: false,
                    mobileOrEmail: widget.arg.mobileOrEmail,
                    otp: bloc.otpController.text,
                    password: bloc.passwordController.text,
                    firebaseVerificationId: bloc.firebaseVerificationId,
                    context: context,
                  ));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
