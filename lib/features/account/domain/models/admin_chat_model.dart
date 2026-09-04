import 'dart:convert';

AdminChatModel adminChatModelFromJson(String str) =>
    AdminChatModel.fromJson(json.decode(str));

class AdminChatModel {
  bool success;
  ChatData data;

  AdminChatModel({
    required this.success,
    required this.data,
  });

  factory AdminChatModel.fromJson(Map<String, dynamic> json) => AdminChatModel(
        success: json["success"],
        data: ChatData.fromJson(json["data"]),
      );
}

class ChatData {
  String message;
  String conversationId;
  String senderId;
  String senderType;
  int count;
  String newChat;
  dynamic createdAt;
  String? messageSuccess;
  String userTimezone;

  ChatData({
    required this.message,
    required this.conversationId,
    required this.senderId,
    required this.senderType,
    required this.count,
    required this.newChat,
    this.createdAt,
    this.messageSuccess,
    required this.userTimezone,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) => ChatData(
        message: json["message"] ?? '',
        conversationId: json["conversation_id"] ?? '',
        senderId: json["sender_id"].toString(),
        senderType: json["sender_type"].toString(),
        count: json["count"] ?? 0,
        newChat: json["new_chat"].toString(),
        createdAt: (json["created_at"] != null) ? json["created_at"] : null,
        messageSuccess: json["message_success"] ?? '',
        userTimezone: json["user_timezone"] ?? '',
      );
}

class CreatedAt {
  String sv;

  CreatedAt({
    required this.sv,
  });

  factory CreatedAt.fromJson(Map<String, dynamic> json) => CreatedAt(
        sv: json[".sv"],
      );
}
