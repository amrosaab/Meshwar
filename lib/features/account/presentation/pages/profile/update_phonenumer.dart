import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/app_colors.dart';
import '../../../../../core/utils/custom_appbar.dart';
import '../../../../../core/utils/custom_button.dart';
import '../../../../../core/utils/custom_text.dart';
import '../../../../../core/utils/custom_textfield.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/application/auth_bloc.dart';
import '../../../../auth/presentation/widgets/select_country_widget.dart';
import '../../../application/acc_bloc.dart';

class UpdatePhoneNumberPage extends StatelessWidget {
  const UpdatePhoneNumberPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: context.read<AccBloc>(),
        ),
        BlocProvider(
            create: (context) => AuthBloc()
              ..add(GetCommonModuleEvent())
              ..add(CountryGetEvent())),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AccBloc, AccState>(
            listener: (context, state) {
              if (state is UserDetailsButtonSuccess) {
                Navigator.pop(context);
              }
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is ConfirmOrOTPVerifySuccessState ||
                  state is ForgotPasswordOTPVerifyState) {
                final auth = context.read<AuthBloc>();
                final accBloc = context.read<AccBloc>();

                // Notify rest of the account flow that the mobile edit flow should proceed
                if (accBloc.userData != null) {
                  accBloc.add(
                    UserDetailEditEvent(
                      header: AppLocalizations.of(context)!.mobile,
                      text: accBloc.userData!.mobile,
                    ),
                  );
                }

                // After OTP verified, update phone
                final user = accBloc.userData;
                accBloc.add(
                  UpdateUserDetailsEvent(
                    name: '',
                    email: '',
                    gender: '',
                    profileImage: '',
                    mobile: accBloc.updateController.text.trim(),
                    country: auth.countryCode.isNotEmpty
                        ? auth.countryCode
                        : (user?.countryCode ?? ''),
                  ),
                );
              }
            },
          ),
        ],
        child: Builder(
          builder: (context) {
            final acc = context.read<AccBloc>();
            final auth = context.read<AuthBloc>();
            if (acc.userData != null) {
              String existing = acc.userData!.mobile;
              if (existing.isNotEmpty &&
                  auth.dialCode.isNotEmpty &&
                  existing.startsWith(auth.dialCode)) {
                existing = existing.substring(auth.dialCode.length);
              }
              if (existing.startsWith('+')) {
                existing = existing.replaceFirst('+', '');
              }
              final currentText = acc.updateController.text.trim();
              if (currentText.isEmpty ||
                  !RegExp(r'^\d+$').hasMatch(currentText)) {
                acc.updateController.text = existing;
              }
            }
            return Scaffold(
              appBar: CustomAppBar(
                title:
                '${AppLocalizations.of(context)!.update} ${AppLocalizations.of(context)!.mobile}',
                automaticallyImplyLeading: true,
                titleFontSize: 18,
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.02),
                      MyText(
                        text:
                        '${AppLocalizations.of(context)!.update} ${AppLocalizations.of(context)!.mobile}',
                        textStyle: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      MyText(
                        text: AppLocalizations.of(context)!.smsVerification,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Theme.of(context).hintColor),
                      ),
                      SizedBox(height: size.height * 0.02),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (ctx, state) {
                          final auth = ctx.read<AuthBloc>();
                          return Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  final countries = auth.countries;
                                  if (countries.isNotEmpty) {
                                    showModalBottomSheet(
                                      context: ctx,
                                      isScrollControlled: true,
                                      backgroundColor:
                                      AppColors.surfaceStrong(ctx),
                                      builder: (_) => SelectCountryWidget(
                                          cont: ctx, countries: countries),
                                    );
                                  }
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  height: 52,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface(context),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: AppColors.surfaceBorder(context),
                                        width: 1),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      MyText(
                                        text: auth.dialCode,
                                        textStyle:
                                        Theme.of(ctx).textTheme.bodyMedium,
                                      ),
                                      const Icon(Icons.arrow_drop_down,
                                          size: 20),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomTextField(
                                  controller: acc.updateController,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.025,
                                      vertical: 16),
                                  filled: true,
                                  keyboardType: TextInputType.number,
                                  maxLength: auth.dialMaxLength,
                                  counterText: '',
                                  hintText:
                                  AppLocalizations.of(context)!.mobile,
                                  hintTextStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.surfaceBorder(context),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.surfaceBorder(context),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 16),
                      // OTP box shown after sending OTP
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (ctx, state) {
                          final auth = ctx.read<AuthBloc>();
                          final showOtp = state is SignInWithOTPSuccessState ||
                              auth.isOtpVerify;
                          if (!showOtp) return const SizedBox.shrink();
                          // Build 6 OTP boxes
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                text: AppLocalizations.of(context)!.enterOtp,
                                textStyle:
                                Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 8),
                              Builder(builder: (innerCtx) {
                                final List<TextEditingController> ctrls =
                                List.generate(
                                    6, (i) => TextEditingController(),
                                    growable: false);
                                final List<FocusNode> foci = List.generate(
                                    6, (i) => FocusNode(),
                                    growable: false);
                                // Prefill from existing otpController if present
                                if (auth.otpController.text.isNotEmpty) {
                                  final t = auth.otpController.text;
                                  for (int i = 0; i < 6 && i < t.length; i++) {
                                    ctrls[i].text = t[i];
                                  }
                                }
                                void syncOtp() {
                                  auth.otpController.text =
                                      ctrls.map((c) => c.text).join();
                                }

                                return Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: List.generate(6, (index) {
                                    return SizedBox(
                                      width: 46,
                                      child: TextField(
                                        controller: ctrls[index],
                                        focusNode: foci[index],
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        maxLength: 1,
                                        decoration: InputDecoration(
                                          counterText: '',
                                          filled: true,
                                          contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 14),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.surfaceBorder(
                                                    innerCtx),
                                                width: 1),
                                            borderRadius:
                                            BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(innerCtx)
                                                    .primaryColor,
                                                width: 1),
                                            borderRadius:
                                            BorderRadius.circular(8),
                                          ),
                                        ),
                                        onChanged: (val) {
                                          if (val.isNotEmpty) {
                                            ctrls[index].text =
                                                val.characters.last;
                                            ctrls[index].selection =
                                                TextSelection.fromPosition(
                                                    TextPosition(
                                                        offset: ctrls[index]
                                                            .text
                                                            .length));
                                            // move focus to next
                                            if (index < 5) {
                                              FocusScope.of(innerCtx)
                                                  .requestFocus(
                                                  foci[index + 1]);
                                            } else {
                                              FocusScope.of(innerCtx).unfocus();
                                            }
                                          }
                                          syncOtp();
                                        },
                                      ),
                                    );
                                  }),
                                );
                              }),
                            ],
                          );
                        },
                      ),

                      const Spacer(),
                      Center(
                        child: CustomButton(
                          isLoader: context.watch<AuthBloc>().isLoading ||
                              context.watch<AccBloc>().isLoading,
                          buttonName: context.watch<AuthBloc>().isOtpVerify
                              ? AppLocalizations.of(context)!.verify
                              : AppLocalizations.of(context)!.continueN,
                          width: size.width * 0.9,
                          textSize: 16,
                          onTap: () {
                            final auth = context.read<AuthBloc>();
                            final accBloc = context.read<AccBloc>();
                            final number = accBloc.updateController.text.trim();
                            if (!RegExp(r'^\d{5,}$').hasMatch(number)) {
                              return;
                            }

                            if (!auth.isOtpVerify) {
                              // Send OTP then show OTP field
                              context.read<AuthBloc>().add(SignInWithOTPEvent(
                                isOtpVerify: true,
                                isLoginByEmail: false,
                                isForgotPassword: true,
                                mobileOrEmail: number,
                                dialCode: auth.dialCode,
                                context: context,
                              ));
                            } else {
                              // Verify OTP
                              context
                                  .read<AuthBloc>()
                                  .add(ConfirmOrVerifyOTPEvent(
                                isUserExist: true,
                                isLoginByEmail: false,
                                isOtpVerify: true,
                                isForgotPasswordVerify: true,
                                mobileOrEmail: number,
                                otp: auth.otpController.text.trim(),
                                password: '',
                                firebaseVerificationId:
                                auth.firebaseVerificationId,
                                context: context,
                              ));
                            }
                          },
                        ),
                      ),
                      SizedBox(height: size.width * 0.1),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}