import 'dart:convert';

LogoutResponseModel logoutResponseModelFromJson(String str) =>
    LogoutResponseModel.fromJson(json.decode(str));

class LogoutResponseModel {
  bool success;
  String message;

  LogoutResponseModel({
    required this.success,
    required this.message,
  });

  /// Use when Laravel returns 204 No Content or empty body (e.g. Laravel 12 / Sanctum).
  factory LogoutResponseModel.logoutSuccess() => LogoutResponseModel(
        success: true,
        message: 'Logged out successfully',
      );

  /// Laravel 8 may return { "success": true, "message": "..." }; Laravel 12 may omit "success" or return different shape.
  factory LogoutResponseModel.fromJson(Map<String, dynamic> json) =>
      LogoutResponseModel(
        success: json["success"] == true,
        message: json["message"]?.toString() ?? '',
      );
}
