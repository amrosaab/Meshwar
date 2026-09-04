import 'dart:convert';

VeifyUserResponseModel veifyUserResponseModelFromJson(String str) =>
    VeifyUserResponseModel.fromJson(json.decode(str));

class VeifyUserResponseModel {
  bool success;
  String message;
  int? statusCode;

  VeifyUserResponseModel({
    required this.success,
    required this.message,
    required this.statusCode,
  });

  factory VeifyUserResponseModel.fromJson(Map<String, dynamic> json) =>
      VeifyUserResponseModel(
        success: json["success"] ?? false,
        message: json["message"] ?? '',
        statusCode: json["status_code"] ?? 200,
      );
}
