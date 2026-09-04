import 'dart:convert';

CommonModuleModel commonModuleResponseModelFromJson(String str) =>
    CommonModuleModel.fromJson(json.decode(str));

class CommonModuleModel {
  bool success;
  String message;
  String enableOwnerLogin;
  String enableEmailOtp;
  bool firebaseOtpEnabled;
  int enableRefferal;
  String enableEmailLogin;
  String enableUserSignInEmailOtp;
  String enableUserSignInEmailPassword;
  String enableUserSignInMobileOtp;
  String enableUserSignInMobilePassword;
  String enableUserEmailLogin;
  String enableUserMobileLogin;

  CommonModuleModel({
    required this.success,
    required this.message,
    required this.enableOwnerLogin,
    required this.enableEmailOtp,
    required this.firebaseOtpEnabled,
    required this.enableRefferal,
    required this.enableEmailLogin,
    required this.enableUserSignInEmailOtp,
    required this.enableUserSignInEmailPassword,
    required this.enableUserSignInMobileOtp,
    required this.enableUserSignInMobilePassword,
    required this.enableUserEmailLogin,
    required this.enableUserMobileLogin,
  });

  factory CommonModuleModel.fromJson(Map<String, dynamic> json) =>
      CommonModuleModel(
        success: json["success"] ?? false,
        message: json["message"] ?? '',
        enableOwnerLogin: json["enable_owner_login"] ?? '0',
        enableEmailOtp: json["enable_email_otp"] ?? '0',
        firebaseOtpEnabled: json["firebase_otp_enabled"] ?? false,
        enableRefferal: json["enable_user_referral_earnings"] != null
            ? int.parse(json["enable_user_referral_earnings"].toString())
            : 0,
        enableEmailLogin: json["enable_email_login"] ?? '0',
        enableUserSignInEmailOtp: json["enable_user_sign_in_email_otp"] ?? '0',
        enableUserSignInEmailPassword:
            json["enable_user_sign_in_email_password"] ?? '0',
        enableUserSignInMobileOtp:
            json["enable_user_sign_in_mobile_otp"] ?? '0',
        enableUserSignInMobilePassword:
            json["enable_user_sign_in_mobile_password"] ?? '0',
        enableUserEmailLogin: json["enable_user_email_login"] ?? '0',
        enableUserMobileLogin: json["enable_user_mobile_login"] ?? '0',
      );
}
