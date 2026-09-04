import 'dart:convert';

SendEmailOtpResponseModel sendEmailOtpResponseModelFromJson(String str) =>
    SendEmailOtpResponseModel.fromJson(json.decode(str));

class SendEmailOtpResponseModel {
  bool success;

  SendEmailOtpResponseModel({
    required this.success,
  });

  factory SendEmailOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      SendEmailOtpResponseModel(
        success: json["success"],
      );
}
