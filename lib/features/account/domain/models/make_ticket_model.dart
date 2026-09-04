// To parse this JSON data, do
//
//     final makeTicketModel = makeTicketModelFromJson(jsonString);

import 'dart:convert';

MakeTicketModel makeTicketModelFromJson(String str) =>
    MakeTicketModel.fromJson(json.decode(str));

String makeTicketModelToJson(MakeTicketModel data) =>
    json.encode(data.toJson());

class MakeTicketModel {
  bool success;
  String message;

  MakeTicketModel({
    required this.success,
    required this.message,
  });

  factory MakeTicketModel.fromJson(Map<String, dynamic> json) =>
      MakeTicketModel(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
