import 'dart:convert';

CancelReasonsModel cancelReasonsModelFromJson(String str) =>
    CancelReasonsModel.fromJson(json.decode(str));

class CancelReasonsModel {
  bool success;
  String message;
  List<CancelReasonsData> data;

  CancelReasonsModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CancelReasonsModel.fromJson(Map<String, dynamic> json) =>
      CancelReasonsModel(
        success: json["success"],
        message: json["message"],
        data: List<CancelReasonsData>.from(
            json["data"].map((x) => CancelReasonsData.fromJson(x))),
      );
}

class CancelReasonsData {
  String id;
  String userType;
  String arrivalStatus;
  String reason;

  CancelReasonsData({
    required this.id,
    required this.userType,
    required this.arrivalStatus,
    required this.reason,
  });

  factory CancelReasonsData.fromJson(Map<String, dynamic> json) =>
      CancelReasonsData(
        id: json["id"],
        userType: json["user_type"],
        arrivalStatus: json["arrival_status"],
        reason: json["reason"],
      );
}
