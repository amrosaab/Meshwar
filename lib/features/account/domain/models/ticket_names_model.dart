// To parse this JSON data, do
//
//     final ticketNamesModel = ticketNamesModelFromJson(jsonString);

import 'dart:convert';

TicketNamesModel ticketNamesModelFromJson(String str) =>
    TicketNamesModel.fromJson(json.decode(str));

String ticketNamesModelToJson(TicketNamesModel data) =>
    json.encode(data.toJson());

class TicketNamesModel {
  bool success;
  String message;
  List<TicketNamesList> data;

  TicketNamesModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TicketNamesModel.fromJson(Map<String, dynamic> json) =>
      TicketNamesModel(
        success: json["success"],
        message: json["message"],
        data: List<TicketNamesList>.from(
            json["data"].map((x) => TicketNamesList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class TicketNamesList {
  String id;
  String titleType;
  String userType;
  String title;

  TicketNamesList({
    required this.id,
    required this.titleType,
    required this.userType,
    required this.title,
  });

  factory TicketNamesList.fromJson(Map<String, dynamic> json) =>
      TicketNamesList(
        id: json["id"],
        titleType: json["title_type"],
        userType: json["user_type"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title_type": titleType,
        "user_type": userType,
        "title": title,
      };
}
