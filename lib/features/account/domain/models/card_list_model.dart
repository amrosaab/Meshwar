import 'dart:convert';

CardListModel cardListModelFromJson(String str) =>
    CardListModel.fromJson(json.decode(str));

String cardListModelToJson(CardListModel data) => json.encode(data.toJson());

class CardListModel {
  bool success;
  String message;
  List<SavedCardDetails> data;

  CardListModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CardListModel.fromJson(Map<String, dynamic> json) => CardListModel(
        success: json["success"] ?? false,
        message: json["message"]?.toString() ?? '',
        data: json["data"] is List
            ? List<SavedCardDetails>.from(
                (json["data"] as List).map((x) => SavedCardDetails.fromJson(x)))
            : <SavedCardDetails>[],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class SavedCardDetails {
  String id;
  String customerId;
  String merchantId;
  String cardToken;
  String validThrough;
  int lastNumber;
  String cardType;
  int userId;
  int isDefault;
  dynamic userRole;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;

  SavedCardDetails({
    required this.id,
    required this.customerId,
    required this.merchantId,
    required this.cardToken,
    required this.validThrough,
    required this.lastNumber,
    required this.cardType,
    required this.userId,
    required this.isDefault,
    required this.userRole,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory SavedCardDetails.fromJson(Map<String, dynamic> json) =>
      SavedCardDetails(
        id: json["id"] ?? '',
        customerId: json["customer_id"] ?? '',
        merchantId: json["merchant_id"] ?? '',
        cardToken: json["card_token"] ?? '',
        validThrough: json["valid_through"] ?? '',
        lastNumber: json["last_number"] ?? 0000,
        cardType: json["card_type"] ?? '',
        userId: json["user_id"] ?? 0,
        isDefault: json["is_default"] ?? 0,
        userRole: json["user_role"] ?? '',
        createdAt: json["created_at"] ?? '',
        updatedAt: json["updated_at"] ?? '',
        deletedAt: json["deleted_at"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "merchant_id": merchantId,
        "card_token": cardToken,
        "valid_through": validThrough,
        "last_number": lastNumber,
        "card_type": cardType,
        "user_id": userId,
        "is_default": isDefault,
        "user_role": userRole,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
      };
}
