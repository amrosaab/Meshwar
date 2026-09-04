import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../common/common.dart';
import '../../../../core/network/network.dart';

class AuthApi {
  Future getLanguagesApi() async {
    try {
      Response response = await DioProviderImpl().get(ApiEndpoints.countryList);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future verifyUserApi(
      {required String emailOrMobileNumber,
      required bool isLoginByEmail}) async {
    try {
      Response response = await DioProviderImpl().post(
        ApiEndpoints.verifyUser,
        body: isLoginByEmail
            ? FormData.fromMap({'email': emailOrMobileNumber})
            : FormData.fromMap({'mobile': emailOrMobileNumber}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future validateMobileApi(
      {required String emailOrMobileNumber,
      required bool isLoginByEmail}) async {
    try {
      Response response = await DioProviderImpl().post(
        ApiEndpoints.veryfymobile,
        body: isLoginByEmail
            ? FormData.fromMap({'email': emailOrMobileNumber})
            : FormData.fromMap({'mobile': emailOrMobileNumber}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future commonModuleCheckApi() async {
    try {
      Response response =
          await DioProviderImpl().get(ApiEndpoints.commonModule);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future sendMobileOtpApi(
      {required String mobileNumber, required String dialCode}) async {
    try {
      Response response = await DioProviderImpl().post(
        ApiEndpoints.sendMobileOtp,
        body: FormData.fromMap(
            {"mobile": mobileNumber, "country_code": dialCode}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future verifyMobileOtpApi(
      {required String mobileNumber, required String otp}) async {
    try {
      Response response = await DioProviderImpl().post(
        ApiEndpoints.verifyMobileOtp,
        body: FormData.fromMap({"mobile": mobileNumber, "otp": otp}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future sendEmailOtpApi({required String emailAddress}) async {
    try {
      Response response = await DioProviderImpl().post(
        ApiEndpoints.sendEmailOtp,
        body: FormData.fromMap({"email": emailAddress}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future verifyEmailOtpApi(
      {required String emailAddress, required String otp}) async {
    try {
      Response response = await DioProviderImpl().post(
        ApiEndpoints.verifyEmailOtp,
        body: FormData.fromMap({"email": emailAddress, "otp": otp}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future userLoginApi(
      {required String emailOrMobile,
      required String otp,
      required String password,
      required bool isOtpLogin,
      required bool isLoginByEmail}) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      Response response = await DioProviderImpl().post(
        ApiEndpoints.userLogin,
        body: !isOtpLogin
            ? FormData.fromMap({
                if (!isLoginByEmail) "mobile": emailOrMobile,
                if (isLoginByEmail) "email": emailOrMobile,
                'password': password,
                'device_token': fcmToken,
                "login_by": (Platform.isAndroid) ? 'android' : 'ios',
              })
            : (!isLoginByEmail)
                ? FormData.fromMap({
                    "mobile": emailOrMobile,
                    'device_token': fcmToken,
                    "login_by": (Platform.isAndroid) ? 'android' : 'ios',
                  })
                : FormData.fromMap({
                    "email": emailOrMobile,
                    "otp": otp,
                    'device_token': fcmToken,
                    "login_by": (Platform.isAndroid) ? 'android' : 'ios',
                  }),
        headers: {'Accept': 'application/json'},
      );
      return response;
    } catch (e) {
      print("authErorr${e}");
      rethrow;
    }
  }

  Future userRegisterApi(
      {required String userName,
      required String mobileNumber,
      required String emailAddress,
      required String password,
      required String countryCode,
      required String gender,
      required String profileImage}) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      final choosenLanguage =
          await AppSharedPreference.getSelectedLanguageCode();
      final formData = FormData.fromMap({
        "name": userName,
        "mobile": mobileNumber,
        if (emailAddress.isNotEmpty) "email": emailAddress,
        "password": password,
        "device_token": fcmToken,
        "country": countryCode,
        "login_by": (Platform.isAndroid) ? 'android' : 'ios',
        'lang': choosenLanguage,
        'gender': (gender == 'Male')
            ? 'male'
            : (gender == 'Female')
                ? 'female'
                : 'others',
      });
      if (profileImage.isNotEmpty) {
        formData.files.add(MapEntry(
            'profile_picture', await MultipartFile.fromFile(profileImage)));
      }
      Response response = await DioProviderImpl().post(
        ApiEndpoints.registerUser,
        body: formData,
        headers: {'Accept': 'application/json'},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future updatePasswordApi(
      {required String emailOrMobile,
      required String password,
      required bool isLoginByEmail}) async {
    try {
      Response response = await DioProviderImpl().post(
        ApiEndpoints.updatePassword,
        body: isLoginByEmail
            ? FormData.fromMap({"email": emailOrMobile, "password": password})
            : FormData.fromMap({"mobile": emailOrMobile, "password": password}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future referralApi({required String referralCode}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
        ApiEndpoints.referral,
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
        body: FormData.fromMap({"refferal_code": referralCode}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
