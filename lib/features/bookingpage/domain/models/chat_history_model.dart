import 'dart:convert';

ChatHistoryModel chatHistoryModelFromJson(String str) =>
    ChatHistoryModel.fromJson(json.decode(str));

String chatHistoryModelToJson(ChatHistoryModel data) =>
    json.encode(data.toJson());

class ChatHistoryModel {
  bool success;
  String message;
  List<ChatHistoryData> data;

  ChatHistoryModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) =>
      ChatHistoryModel(
        success: json["success"],
        message: json["message"],
        data: List<ChatHistoryData>.from(
            json["data"].map((x) => ChatHistoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ChatHistoryData {
  String id;
  String message;
  int fromType;
  String requestId;
  int userId;
  int delivered;
  int seen;
  String createdAt;
  String updatedAt;
  String messageStatus;
  String convertedCreatedAt;

  ChatHistoryData({
    required this.id,
    required this.message,
    required this.fromType,
    required this.requestId,
    required this.userId,
    required this.delivered,
    required this.seen,
    required this.createdAt,
    required this.updatedAt,
    required this.messageStatus,
    required this.convertedCreatedAt,
  });

  factory ChatHistoryData.fromJson(Map<String, dynamic> json) =>
      ChatHistoryData(
        id: json["id"],
        message: json["message"],
        fromType: json["from_type"],
        requestId: json["request_id"],
        userId: json["user_id"],
        delivered: json["delivered"],
        seen: json["seen"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        messageStatus: json["message_status"],
        convertedCreatedAt: json["converted_created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
        "from_type": fromType,
        "request_id": requestId,
        "user_id": userId,
        "delivered": delivered,
        "seen": seen,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "message_status": messageStatus,
        "converted_created_at": convertedCreatedAt,
      };
}
