import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/app_arguments.dart';
import '../../../../common/app_validators.dart';
import '../../../../core/utils/custom_snack_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/presentation/pages/settings/page/terms_privacy_policy_view_page.dart';
import '../../application/auth_bloc.dart';
import '../widgets/select_country_widget.dart';
import '../widgets/verify_contact_content.dart';
import 'login_page.dart';
import 'otp_page.dart';

class SignupMobilePage extends StatelessWidget {
  static const String routeName = '/SignupMobilePage';
  final SignupMobilePageArguments arg;
  const SignupMobilePage({super.key, required this.arg});
  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => AuthBloc()
          ..add(GetDirectionEvent())
          ..add(CountryGetEvent())
          ..add(GetCommonModuleEvent()),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is ValidateMobileSuccessState) {
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
          child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
            final bloc = context.read<AuthBloc>();
            final email = arg.mobileOrEmailSignUp;
            return Directionality(
                textDirection: bloc.textDirection == 'rtl'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: VerifyContactLayout(
                  email: email,
                  busy: bloc.isLoading,
                  field: VerifyContactField(
                      controller: email
                          ? bloc.rEmailController
                          : bloc.rMobileController,
                      focusNode:
                          email ? bloc.emailFocusNode : bloc.mobileFocusNode,
                      email: email,
                      dialCode: bloc.dialCode,
                      flagUrl: bloc.flagImage,
                      maxLength: bloc.dialMaxLength,
                      enabled: !bloc.isLoading,
                      onCountry: bloc.countries.isEmpty
                          ? null
                          : () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              useSafeArea: true,
                              builder: (_) => SelectCountryWidget(
                                  countries: bloc.countries, cont: context))),
                  onTerms: () => Navigator.pushNamed(
                      context, TermsPrivacyPolicyViewPage.routeName,
                      arguments: TermsAndPrivacyPolicyArguments(
                          isPrivacyPolicy: false)),
                  onPrivacy: () => Navigator.pushNamed(
                      context, TermsPrivacyPolicyViewPage.routeName,
                      arguments: TermsAndPrivacyPolicyArguments(
                          isPrivacyPolicy: true)),
                  onSignIn: () => Navigator.pushNamedAndRemoveUntil(
                      context, LoginPage.routeName, (_) => false),
                  onSend: () => _send(context),
                ));
          }),
        ),
      );
  void _send(BuildContext context) {
    final bloc = context.read<AuthBloc>();
    if (bloc.isLoading) return;
    final l10n = AppLocalizations.of(context)!;
    final email = arg.mobileOrEmailSignUp;
    final value =
        (email ? bloc.rEmailController : bloc.rMobileController).text.trim();
    if (value.isEmpty) {
      showToast(
          message: email ? l10n.enterEmail : l10n.pleaseEnterMobileNumber);
      return;
    }
    if (email
        ? !AppValidation.emailValidate(value)
        : !AppValidation.mobileNumberValidate(value)) {
      showToast(message: email ? l10n.enterValidEmail : l10n.enterValidMobile);
      return;
    }
    FocusScope.of(context).unfocus();
    bloc.add(ValidateMobileEvent(mobileOrEmail: value, isLoginByEmail: email));
  }
}
