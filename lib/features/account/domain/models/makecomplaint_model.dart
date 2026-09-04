import 'dart:convert';

ComplaintResponseModel complaintResponseModelFromJson(String str) =>
    ComplaintResponseModel.fromJson(json.decode(str));

class ComplaintResponseModel {
  bool success;
  String message;
  List<ComplaintList> data;

  ComplaintResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ComplaintResponseModel.fromJson(Map<String, dynamic> json) =>
      ComplaintResponseModel(
        success: json["success"],
        message: json["message"],
        data: List<ComplaintList>.from(
            json["data"].map((x) => ComplaintList.fromJson(x))),
      );
}

class ComplaintList {
  String id;
  String userType;
  String complaintType;
  String title;

  ComplaintList({
    required this.id,
    required this.userType,
    required this.complaintType,
    required this.title,
  });

  factory ComplaintList.fromJson(Map<String, dynamic> json) => ComplaintList(
        id: json["id"],
        userType: json["user_type"],
        complaintType: json["complaint_type"],
        title: json["title"],
      );
}
