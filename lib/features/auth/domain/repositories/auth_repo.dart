import 'package:dartz/dartz.dart';

import '../../../../core/network/network.dart';
import '../models/register_model.dart';
import '../models/send_mobile_otp_res_model.dart';
import '../models/verify_user_res_model.dart';
import '../models/common_module_model.dart';
import '../models/country_list_model.dart';
import '../models/login_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, CountryListModel>> getCountryList();

  Future<Either<Failure, VeifyUserResponseModel>> verifyUser({
    required String emailOrMobileNumber,
    required bool isLoginByEmail,
  });

  Future<Either<Failure, VeifyUserResponseModel>> validateMobile({
    required String emailOrMobileNumber,
    required bool isLoginByEmail,
  });

  Future<Either<Failure, CommonModuleModel>> commonModuleCheck();

  Future<Either<Failure, SendMobileOtpResponseModel>> sendMobileOtp({
    required String mobileNumber,
    required String dialCode,
  });

  Future<Either<Failure, dynamic>> verifyMobileOtp({
    required String mobileNumber,
    required String otp,
  });

  Future<Either<Failure, dynamic>> sendEmailOtp({required String emailAddress});

  Future<Either<Failure, dynamic>> verifyEmailOtp({
    required String emailAddress,
    required String otp,
  });

  Future<Either<Failure, LoginResponseModel>> userLogin({
    required String emailOrMobile,
    required String otp,
    required String password,
    required bool isOtpLogin,
    required bool isLoginByEmail,
  });

  Future<Either<Failure, RegisterResponseModel>> userRegister({
    required String userName,
    required String mobileNumber,
    required String emailAddress,
    required String password,
    required String countryCode,
    required String gender,
    required String profileImage,
  });

  Future<Either<Failure, dynamic>> updatePassword(
      {required String emailOrMobile,
      required String password,
      required bool isLoginByEmail});

  Future<Either<Failure, dynamic>> referralCode({
    required String referralCode,
  });
}
