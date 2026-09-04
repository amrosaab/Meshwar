import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../utils/custom_snack_bar.dart';

class DioErrorHandler {
  static String dioErrorToString(DioException dioError) {
    String? errorText;
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        errorText = "Connection lost, too late to get response.";
        break;
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        errorText = "Connection lost, too late to get response.";
        break;
      case DioExceptionType.badResponse:
        errorText = errorBaseOnHttpStatusCode(dioError);
        break;
      case DioExceptionType.unknown:
        errorText =
            "Connection lost, please check your internet connection and try again.";
        break;
      case DioExceptionType.cancel:
        errorText =
            "Connection lost, please check your internet connection and try again.";
        break;
      case DioExceptionType.badCertificate:
        errorText =
            "Connection lost, please check your internet connection and try again.";
        break;
      case DioExceptionType.connectionError:
        errorText =
            "Connection lost, please check your internet connection and try again.";
        break;
      case DioExceptionType.transformTimeout:
        // TODO: Handle this case.
        errorText =
        "Connection lost, please check your internet connection and try again.";

        break;
    }
    return errorText;
  }

  static String errorBaseOnHttpStatusCode(DioException dioError) {
    String errorText;
    if (dioError.response != null) {
      if (dioError.response!.statusCode == 401) {
        errorText =
            "Something went wrong, please close the app and login again.";
      } else if (dioError.response!.statusCode == 403) {
        errorText =
            "Connection lost, please check your internet connection and try again.";
      } else if (dioError.response!.statusCode == 422) {
        errorText =
            "Connection lost, please check your internet connection and try again.";
      } else if (dioError.response!.statusCode == 500) {
        errorText = "We couldn't connect to the product server";
      } else {
        errorText =
            "Something went wrong, please close the app and login again.";
      }
    } else {
      errorText = "Something went wrong, please close the app and login again.";
    }

    return errorText;
  }
}

void updateErrorToUI(String? errorMsg) {
  if (errorMsg?.isNotEmpty ?? false) {
    showToast(isError: true, message: errorMsg ?? '');
  }
}

void printErrorToConsole(Object? e) {
  if (e != null) {
    debugPrint(e.toString());
  }
}
