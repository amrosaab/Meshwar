import 'package:dartz/dartz.dart';

import '../../../../core/network/network.dart';
import '../../domain/models/send_mobile_otp_res_model.dart';
import '../../domain/models/verify_user_res_model.dart';
import '../../domain/models/common_module_model.dart';
import '../../domain/models/country_list_model.dart';
import '../../domain/models/login_model.dart';
import '../../domain/models/register_model.dart';
import '../../domain/repositories/auth_repo.dart';

class AuthUsecase {
  final AuthRepository _authRepository;

  const AuthUsecase(this._authRepository);

  Future<Either<Failure, CountryListModel>> getCountryList() async {
    return _authRepository.getCountryList();
  }

  Future<Either<Failure, VeifyUserResponseModel>> verifyUser({
    required String emailOrMobileNumber,
    required bool isLoginByEmail,
  }) async {
    return _authRepository.verifyUser(
      emailOrMobileNumber: emailOrMobileNumber,
      isLoginByEmail: isLoginByEmail,
    );
  }

  Future<Either<Failure, VeifyUserResponseModel>> validateMobile({
    required String emailOrMobileNumber,
    required bool isLoginByEmail,
  }) async {
    return _authRepository.validateMobile(
      emailOrMobileNumber: emailOrMobileNumber,
      isLoginByEmail: isLoginByEmail,
    );
  }

  Future<Either<Failure, CommonModuleModel>> commonModuleCheck() async {
    return _authRepository.commonModuleCheck();
  }

  Future<Either<Failure, SendMobileOtpResponseModel>> sendMobileOtp({
    required String mobileNumber,
    required String dialCode,
  }) async {
    return _authRepository.sendMobileOtp(
      dialCode: dialCode,
      mobileNumber: mobileNumber,
    );
  }

  Future<Either<Failure, dynamic>> verifyMobileOtp(
      {required String mobileNumber, required String otp}) async {
    return _authRepository.verifyMobileOtp(
      mobileNumber: mobileNumber,
      otp: otp,
    );
  }

  Future<Either<Failure, dynamic>> sendEmailOtp(
      {required String emailAddress}) async {
    return _authRepository.sendEmailOtp(emailAddress: emailAddress);
  }

  Future<Either<Failure, dynamic>> verifyEmailOtp(
      {required String emailAddress, required String otp}) async {
    return _authRepository.verifyEmailOtp(emailAddress: emailAddress, otp: otp);
  }

  Future<Either<Failure, LoginResponseModel>> userLogin(
      {required String emailOrMobile,
      required String otp,
      required String password,
      required bool isOtpLogin,
      required bool isLoginByEmail}) async {
    return _authRepository.userLogin(
      emailOrMobile: emailOrMobile,
      otp: otp,
      password: password,
      isOtpLogin: isOtpLogin,
      isLoginByEmail: isLoginByEmail,
    );
  }

  Future<Either<Failure, RegisterResponseModel>> userRegister({
    required String userName,
    required String mobileNumber,
    required String emailAddress,
    required String password,
    required String countryCode,
    required String gender,
    required String profileImage,
  }) async {
    return _authRepository.userRegister(
      userName: userName,
      mobileNumber: mobileNumber,
      emailAddress: emailAddress,
      password: password,
      countryCode: countryCode,
      gender: gender,
      profileImage: profileImage,
    );
  }

  Future<Either<Failure, dynamic>> updatePassword(
      {required String emailOrMobile,
      required String password,
      required bool isLoginByEmail}) async {
    return _authRepository.updatePassword(
        emailOrMobile: emailOrMobile,
        password: password,
        isLoginByEmail: isLoginByEmail);
  }

  Future<Either<Failure, dynamic>> referralCode({
    required String referralCode,
  }) async {
    return _authRepository.referralCode(referralCode: referralCode);
  }
}
