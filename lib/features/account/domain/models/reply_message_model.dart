// To parse this JSON data, do
//
//     final replyMessage = replyMessageFromJson(jsonString);

import 'dart:convert';

ReplyMessage replyMessageFromJson(String str) =>
    ReplyMessage.fromJson(json.decode(str));

String replyMessageToJson(ReplyMessage data) => json.encode(data.toJson());

class ReplyMessage {
  String successMessage;
  ReplyTicket replyTicket;

  ReplyMessage({
    required this.successMessage,
    required this.replyTicket,
  });

  factory ReplyMessage.fromJson(Map<String, dynamic> json) => ReplyMessage(
        successMessage: json["successMessage"],
        replyTicket: ReplyTicket.fromJson(json["reply_ticket"]),
      );

  Map<String, dynamic> toJson() => {
        "successMessage": successMessage,
        "reply_ticket": replyTicket.toJson(),
      };
}

class ReplyTicket {
  String message;
  String ticketId;
  int userId;
  String employeeId;
  String senderId;
  String id;
  DateTime updatedAt;
  DateTime createdAt;
  String convertedCreatedAt;

  ReplyTicket({
    required this.message,
    required this.ticketId,
    required this.userId,
    required this.employeeId,
    required this.senderId,
    required this.id,
    required this.updatedAt,
    required this.createdAt,
    required this.convertedCreatedAt,
  });

  factory ReplyTicket.fromJson(Map<String, dynamic> json) => ReplyTicket(
        message: json["message"],
        ticketId: json["ticket_id"],
        userId: json["user_id"],
        employeeId: json["employee_id"],
        senderId: json["sender_id"],
        id: json["id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        convertedCreatedAt: json["converted_created_at"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "ticket_id": ticketId,
        "user_id": userId,
        "employee_id": employeeId,
        "sender_id": senderId,
        "id": id,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "converted_created_at": convertedCreatedAt,
      };
}
