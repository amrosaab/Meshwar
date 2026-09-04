import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/network.dart';
import '../../domain/models/common_module_model.dart';
import '../../domain/models/country_list_model.dart';
import '../../domain/models/login_model.dart';
import '../../domain/models/register_model.dart';
import '../../domain/models/verify_user_res_model.dart';
import '../../domain/repositories/auth_repo.dart';
import '../repository/auth_api.dart';
import '../../domain/models/send_email_otp_res_model.dart';
import '../../domain/models/send_mobile_otp_res_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _authApi;

  AuthRepositoryImpl(this._authApi);
  // CountryList
  @override
  Future<Either<Failure, CountryListModel>> getCountryList() async {
    CountryListModel countryListResponseModel;
    try {
      Response response = await _authApi.getLanguagesApi();
      debugPrint('language : $response');

      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['errors']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          countryListResponseModel = CountryListModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }

    return Right(countryListResponseModel);
  }

  // VerifyUser
  @override
  Future<Either<Failure, VeifyUserResponseModel>> verifyUser(
      {required String emailOrMobileNumber,
      required bool isLoginByEmail}) async {
    VeifyUserResponseModel verifyUserResponseModel;
    try {
      Response response = await _authApi.verifyUserApi(
          emailOrMobileNumber: emailOrMobileNumber,
          isLoginByEmail: isLoginByEmail);
      debugPrint('verifyuser : $response');

      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['errors']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          verifyUserResponseModel =
              VeifyUserResponseModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(verifyUserResponseModel);
  }

  // ValidateMobile
  @override
  Future<Either<Failure, VeifyUserResponseModel>> validateMobile(
      {required String emailOrMobileNumber,
      required bool isLoginByEmail}) async {
    try {
      final Response response = await _authApi.validateMobileApi(
          emailOrMobileNumber: emailOrMobileNumber,
          isLoginByEmail: isLoginByEmail);
      if (response.data == null || response.data.toString().isEmpty) {
        return Left(GetDataFailure(message: 'Empty response from server'));
      }
      if (response.statusCode != null && response.statusCode! >= 400) {
        return Left(
          GetDataFailure(
            message: _extractErrorMessage(response.data),
          ),
        );
      }
      if (response.data is Map && response.data.containsKey('error')) {
        return Left(
          GetDataFailure(
            message: _extractErrorMessage(response.data),
          ),
        );
      }
      if (response.data is Map && response.data['success'] == false) {
        return Left(
          GetDataFailure(
            message: _extractErrorMessage(response.data),
          ),
        );
      }
      final verifyUserResponseModel =
          VeifyUserResponseModel.fromJson(response.data);
      return Right(verifyUserResponseModel);
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    } on DioException catch (e) {
      return Left(GetDataFailure(message: _handleDioError(e)));
    } catch (e) {
      return Left(GetDataFailure(message: e.toString()));
    }
  }

  // CommonModuleCheck
  @override
  Future<Either<Failure, CommonModuleModel>> commonModuleCheck() async {
    CommonModuleModel commonModuleResponseModel;
    try {
      Response response = await _authApi.commonModuleCheckApi();
      debugPrint('getUserHistoryDetails : $response');

      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['errors']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          commonModuleResponseModel = CommonModuleModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(commonModuleResponseModel);
  }

  // SendMobileOtp
  @override
  Future<Either<Failure, SendMobileOtpResponseModel>> sendMobileOtp(
      {required String mobileNumber, required String dialCode}) async {
    SendMobileOtpResponseModel sendMobileOtpResponseModel;
    try {
      Response response = await _authApi.sendMobileOtpApi(
          mobileNumber: mobileNumber, dialCode: dialCode);
      debugPrint('getUserHistoryDetails : $response');

      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['errors']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          sendMobileOtpResponseModel =
              SendMobileOtpResponseModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(sendMobileOtpResponseModel);
  }

  // VerifyMobileOtp
  @override
  Future<Either<Failure, dynamic>> verifyMobileOtp(
      {required String mobileNumber, required String otp}) async {
    dynamic verifyResponseModel;
    try {
      Response response = await _authApi.verifyMobileOtpApi(
          mobileNumber: mobileNumber, otp: otp);
      debugPrint('getUserHistoryDetails : $response');

      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['errors']["otp"][0]));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          verifyResponseModel = response.data;
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(verifyResponseModel);
  }

  // SendEmailOtp
  @override
  Future<Either<Failure, dynamic>> sendEmailOtp(
      {required String emailAddress}) async {
    dynamic sendEmailOtpResponseModel;
    try {
      Response response =
          await _authApi.sendEmailOtpApi(emailAddress: emailAddress);
      debugPrint('getUserHistoryDetails : $response');

      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(
            GetDataFailure(message: response.data['errors']["message"]));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          sendEmailOtpResponseModel =
              SendEmailOtpResponseModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(sendEmailOtpResponseModel);
  }

  // VerifyEmailOtp
  @override
  Future<Either<Failure, dynamic>> verifyEmailOtp(
      {required String emailAddress, required String otp}) async {
    dynamic verifyResponseModel;
    try {
      Response response = await _authApi.verifyEmailOtpApi(
          emailAddress: emailAddress, otp: otp);
      debugPrint('getUserHistoryDetails : $response');

      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        if (response.data['errors']['email'] != null) {
          return Left(
              GetDataFailure(message: response.data['errors']['email'][0]));
        } else if (response.data['errors']['mobile'] != null) {
          return Left(
              GetDataFailure(message: response.data['errors']['mobile'][0]));
        } else {
          return Left(
              GetDataFailure(message: response.data['errors']['message']));
        }
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          verifyResponseModel = response.data;
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(verifyResponseModel);
  }

  @override
  Future<Either<Failure, LoginResponseModel>> userLogin({
    required String emailOrMobile,
    required String otp,
    required String password,
    required bool isOtpLogin,
    required bool isLoginByEmail,
  }) async {
    try {
      final Response response = await _authApi.userLoginApi(
        emailOrMobile: emailOrMobile,
        otp: otp,
        password: password,
        isOtpLogin: isOtpLogin,
        isLoginByEmail: isLoginByEmail,
      );

      //  DEBUG RESPONSE

      //  EMPTY RESPONSE
      if (response.data == null || response.data.toString().isEmpty) {
        return Left(GetDataFailure(message: 'Empty response from server'));
      }

      //  HANDLE NON SUCCESS STATUS
      if (response.statusCode != null && response.statusCode! >= 400) {
        return Left(
          GetDataFailure(
            message: _extractErrorMessage(response.data),
          ),
        );
      }

      //  HANDLE API LEVEL ERROR
      if (response.data is Map && response.data.containsKey('error')) {
        return Left(
          GetDataFailure(
            message: _extractErrorMessage(response.data),
          ),
        );
      }

      //  SUCCESS RESPONSE
      final loginModel = LoginResponseModel.fromJson(response.data);
      return Right(loginModel);
    }

    //  CUSTOM API EXCEPTIONS
    on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }

    //  DIO ERROR HANDLING
    on DioException catch (e) {
      return Left(GetDataFailure(
        message: _handleDioError(e),
      ));
    }

    //  UNKNOWN ERROR
    catch (e) {
      return Left(GetDataFailure(message: e.toString()));
    }
  }

  String _handleDioError(DioException error) {
    if (error.response != null) {
      return _extractErrorMessage(error.response?.data);
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout";
      case DioExceptionType.sendTimeout:
        return "Send timeout";
      case DioExceptionType.receiveTimeout:
        return "Receive timeout";
      case DioExceptionType.badCertificate:
        return "Bad certificate";
      case DioExceptionType.badResponse:
        return "Bad response from server";
      case DioExceptionType.cancel:
        return "Request cancelled";
      case DioExceptionType.connectionError:
        return "No internet connection";
      case DioExceptionType.unknown:
        return "Unexpected error occurred";
      case DioExceptionType.transformTimeout:
        // TODO: Handle this case.
          return "Unexpected error occurred";
    }
  }

  String _extractErrorMessage(dynamic data) {
    if (data == null) return "Unknown error occurred";

    // response as string
    if (data is String) return data;

    if (data is Map) {
      // direct message
      if (data['message'] != null) {
        return data['message'].toString();
      }

      // validation errors
      if (data['errors'] != null) {
        final errors = data['errors'];

        if (errors is Map<String, dynamic>) {
          //  EMAIL ALREADY TAKEN
          if (errors.containsKey('email')) {
            final value = errors['email'];
            if (value is List && value.isNotEmpty) {
              return value.first.toString();
            }
            return value.toString();
          }

          //  MOBILE ALREADY TAKEN
          if (errors.containsKey('mobile')) {
            final value = errors['mobile'];
            if (value is List && value.isNotEmpty) {
              return value.first.toString();
            }
            return value.toString();
          }

          //  PHONE (some APIs)
          if (errors.containsKey('phone')) {
            final value = errors['phone'];
            if (value is List && value.isNotEmpty) {
              return value.first.toString();
            }
            return value.toString();
          }

          //  ANY OTHER FIELD ERROR
          final firstKey = errors.keys.first;
          final value = errors[firstKey];

          if (value is List && value.isNotEmpty) {
            return value.first.toString();
          }

          return value.toString();
        }

        if (errors is List && errors.isNotEmpty) {
          return errors.first.toString();
        }

        if (errors is String) {
          return errors;
        }
      }
    }

    return "Something went wrong";
  }

  @override
  Future<Either<Failure, RegisterResponseModel>> userRegister({
    required String userName,
    required String mobileNumber,
    required String emailAddress,
    required String password,
    required String countryCode,
    required String gender,
    required String profileImage,
  }) async {
    try {
      final Response response = await _authApi.userRegisterApi(
        userName: userName,
        mobileNumber: mobileNumber,
        emailAddress: emailAddress,
        password: password,
        countryCode: countryCode,
        gender: gender,
        profileImage: profileImage,
      );

      //  DEBUG RESPONSE

      //  EMPTY RESPONSE
      if (response.data == null || response.data.toString().isEmpty) {
        return Left(GetDataFailure(message: 'Empty response from server'));
      }

      //  HTTP ERROR STATUS
      if (response.statusCode != null && response.statusCode! >= 400) {
        return Left(
          GetDataFailure(
            message: _extractErrorMessage(response.data),
          ),
        );
      }

      //  API LEVEL ERROR
      if (response.data is Map && response.data.containsKey('error')) {
        return Left(
          GetDataFailure(
            message: _extractErrorMessage(response.data),
          ),
        );
      }

      //  SUCCESS
      final registerModel = RegisterResponseModel.fromJson(response.data);
      return Right(registerModel);
    }

    //  CUSTOM API EXCEPTIONS
    on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }

    //  DIO NETWORK ERRORS
    on DioException catch (e) {
      return Left(
        GetDataFailure(
          message: _handleDioError(e),
        ),
      );
    }

    //  UNKNOWN ERROR
    catch (e) {
      return Left(GetDataFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, dynamic>> updatePassword(
      {required String emailOrMobile,
      required String password,
      required bool isLoginByEmail}) async {
    dynamic updateResponseModel;
    try {
      Response response = await _authApi.updatePasswordApi(
          emailOrMobile: emailOrMobile,
          password: password,
          isLoginByEmail: isLoginByEmail);
      debugPrint('updatePassword : $response');

      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        if (response.data['errors']['email'] != null) {
          return Left(
              GetDataFailure(message: response.data['errors']['email'][0]));
        } else if (response.data['errors']['mobile'] != null) {
          return Left(
              GetDataFailure(message: response.data['errors']['mobile'][0]));
        } else {
          return Left(
              GetDataFailure(message: response.data['errors']['message']));
        }
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          updateResponseModel = response.data;
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(updateResponseModel);
  }

  @override
  Future<Either<Failure, dynamic>> referralCode(
      {required String referralCode}) async {
    dynamic referralResponse;
    try {
      Response response =
          await _authApi.referralApi(referralCode: referralCode);
      debugPrint('getUserHistoryDetails : $response');

      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(
            message: response.data['errors']["refferal_code"][0]));
      } else {
        if (response.statusCode == 400 || response.statusCode == 500) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          referralResponse = response.data;
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
    return Right(referralResponse);
  }
}
