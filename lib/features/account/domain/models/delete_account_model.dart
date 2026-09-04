import 'dart:convert';

DeleteAccountResponseModel deleteAccountResponseModelFromJson(String str) =>
    DeleteAccountResponseModel.fromJson(json.decode(str));

class DeleteAccountResponseModel {
  bool success;
  String message;

  DeleteAccountResponseModel({
    required this.success,
    required this.message,
  });

  factory DeleteAccountResponseModel.fromJson(Map<String, dynamic> json) =>
      DeleteAccountResponseModel(
        success: json["success"] ?? false,
        message: json["message"] ?? '',
      );
}
