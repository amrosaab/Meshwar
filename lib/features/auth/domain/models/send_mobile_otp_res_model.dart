import 'dart:convert';

SendMobileOtpResponseModel sendMobileOtpResponseModelFromJson(String str) =>
    SendMobileOtpResponseModel.fromJson(json.decode(str));

class SendMobileOtpResponseModel {
  bool success;
  String message;

  SendMobileOtpResponseModel({
    required this.success,
    required this.message,
  });

  factory SendMobileOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      SendMobileOtpResponseModel(
        success: json["success"],
        message: json["message"],
      );
}
