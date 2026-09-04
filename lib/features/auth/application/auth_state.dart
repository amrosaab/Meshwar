part of 'auth_bloc.dart';

abstract class AuthState {}

final class AuthUpdateState extends AuthState {}

final class AuthInitialState extends AuthState {}

final class AuthDataLoadingState extends AuthState {}

final class AuthDataLoadedState extends AuthState {}

final class AuthDataSuccessState extends AuthState {}

final class CountryLoadingState extends AuthState {}

final class CountrySuccessState extends AuthState {}

final class CountryFailureState extends AuthState {}

final class SplashChangeIndexState extends AuthState {}

final class EmailorMobileOnChangeState extends AuthState {}

final class EmailorMobileOnTapState extends AuthState {}

final class EmailorMobileOnSubmitState extends AuthState {}

final class VerifyLoadingState extends AuthState {}

final class VerifySuccessState extends AuthState {}

final class VerifyFailureState extends AuthState {}

final class ValidateMobileSuccessState extends AuthState {}

final class ValidateMobileFailureState extends AuthState {
  final String message;
  ValidateMobileFailureState({required this.message});
}

final class VerifyTimerState extends AuthState {
  final int duration;

  VerifyTimerState({required this.duration});
}

final class ShowPasswordIconState extends AuthState {}

final class OTPOnChangeState extends AuthState {}

final class ConfirmOrOTPVerifySuccessState extends AuthState {}

final class ConfirmOrOTPVerifyFailureState extends AuthState {}

final class SignInWithOTPSuccessState extends AuthState {}

final class SignInWithOTPFailureState extends AuthState {}

final class SignInWithDemoState extends AuthState {}

final class NewUserRegisterState extends AuthState {}

final class ConfirmMobileOrEmailState extends AuthState {}

final class LoginLoadingState extends AuthState {}

final class LoginSuccessState extends AuthState {}

final class LoginFailureState extends AuthState {}

final class ImageUpdateState extends AuthState {}

final class ForgotPasswordOTPSendState extends AuthState {}

final class ForgotPasswordOTPVerifyState extends AuthState {}

final class ForgotPasswordUpdateFailureState extends AuthState {}

final class ForgotPasswordUpdateSuccessState extends AuthState {}

final class ReferralSuccessState extends AuthState {}

final class ReferralFailureState extends AuthState {}

final class SelectLoginMethodState extends AuthState {}

final class ForgotPasswordOnTapState extends AuthState {}

final class UserNotExistState extends AuthState {
  final String message;
  UserNotExistState({required this.message});
}

final class OtpVerifyState extends AuthState {}

class GetCommonModuleLoading extends AuthState {}

class GetCommonModuleSuccess extends AuthState {}

class GetCommonModuleFailure extends AuthState {}

class SelectTermsAndConditionCheckBoxState extends AuthState {
  final bool isTermsAndConditionsChecked;

  SelectTermsAndConditionCheckBoxState(
      {required this.isTermsAndConditionsChecked});
}
