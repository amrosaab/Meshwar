import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/app_colors.dart';
import '../../../../../common/ride_visuals.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/application/auth_bloc.dart';
import '../../../../auth/presentation/widgets/select_country_widget.dart';
import '../../../application/acc_bloc.dart';
import 'widget/profile_edit_layout.dart';
import 'widget/profile_mobile_fields.dart';

class UpdatePhoneNumberPage extends StatelessWidget {
  const UpdatePhoneNumberPage({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<AccBloc>()),
          BlocProvider(
              create: (_) => AuthBloc()
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
          child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
            final acc = context.watch<AccBloc>();
            final auth = context.read<AuthBloc>();
            final l10n = AppLocalizations.of(context)!;
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
            final busy = auth.isLoading || acc.isLoading;
            final showOtp =
                state is SignInWithOTPSuccessState || auth.isOtpVerify;
            return Directionality(
              textDirection: acc.textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: ProfileEditLayout(
                title: '${l10n.update} ${l10n.mobile}',
                label: l10n.mobileNumber,
                description: l10n.smsVerification,
                icon: Icons.phone_outlined,
                gradient: RideVisuals.green,
                saveLabel: auth.isOtpVerify ? l10n.verify : l10n.continueN,
                saving: busy,
                onBack: () => Navigator.pop(context),
                onSave: () {
                  final number = acc.updateController.text.trim();
                  if (!RegExp(r'^\d{5,}$').hasMatch(number)) return;
                  if (!auth.isOtpVerify) {
                    auth.add(SignInWithOTPEvent(
                      isOtpVerify: true,
                      isLoginByEmail: false,
                      isForgotPassword: true,
                      mobileOrEmail: number,
                      dialCode: auth.dialCode,
                      context: context,
                    ));
                  } else {
                    auth.add(ConfirmOrVerifyOTPEvent(
                      isUserExist: true,
                      isLoginByEmail: false,
                      isOtpVerify: true,
                      isForgotPasswordVerify: true,
                      mobileOrEmail: number,
                      otp: auth.otpController.text.trim(),
                      password: '',
                      firebaseVerificationId: auth.firebaseVerificationId,
                      context: context,
                    ));
                  }
                },
                field: ProfileMobileFields(
                  phoneController: acc.updateController,
                  otpController: auth.otpController.textController,
                  mobileLabel: l10n.mobile,
                  otpLabel: l10n.enterOtp,
                  countryLabel: l10n.selectContry,
                  dialCode: auth.dialCode,
                  maxLength: auth.dialMaxLength,
                  showOtp: showOtp,
                  enabled: !busy,
                  onCountry: auth.countries.isEmpty
                      ? null
                      : () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: AppColors.surfaceStrong(context),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(28))),
                            builder: (_) => SelectCountryWidget(
                                cont: context, countries: auth.countries),
                          ),
                ),
              ),
            );
          }),
        ),
      );
}
