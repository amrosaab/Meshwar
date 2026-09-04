// To parse this JSON data, do
//
//     final updateProfileModel = updateProfileModelFromJson(jsonString);

import 'dart:convert';

UpdateProfileModel updateProfileModelFromJson(String str) =>
    UpdateProfileModel.fromJson(json.decode(str));

class UpdateProfileModel {
  bool success;
  String message;
  UpdateProfileModelData data;

  UpdateProfileModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) =>
      UpdateProfileModel(
        success: json["success"],
        message: json["message"],
        data: UpdateProfileModelData.fromJson(json["data"]),
      );
}

class UpdateProfileModelData {
  int id;
  String name;
  String gender;
  String email;
  String mobile;
  String profilePicture;

  UpdateProfileModelData({
    required this.id,
    required this.name,
    required this.gender,
    required this.email,
    required this.mobile,
    required this.profilePicture,
  });

  factory UpdateProfileModelData.fromJson(Map<String, dynamic> json) =>
      UpdateProfileModelData(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        gender: json["gender"] ?? '',
        email: json["email"] ?? '',
        mobile: json["mobile"] ?? '',
        profilePicture: json["profile_picture"] ?? '',
      );
}
