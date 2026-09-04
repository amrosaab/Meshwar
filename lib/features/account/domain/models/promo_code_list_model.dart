// To parse this JSON data, do
//
//     final promoCodeListModel = promoCodeListModelFromJson(jsonString);

import 'dart:convert';

PromoCodeListModel promoCodeListModelFromJson(String str) =>
    PromoCodeListModel.fromJson(json.decode(str));

class PromoCodeListModel {
  bool success;
  String message;
  List<PromoCodeListData> data;

  PromoCodeListModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PromoCodeListModel.fromJson(Map<String, dynamic> json) =>
      PromoCodeListModel(
        success: json["success"],
        message: json["message"],
        data: List<PromoCodeListData>.from(
            json["data"].map((x) => PromoCodeListData.fromJson(x))),
      );
}

class PromoCodeListData {
  String id;
  String code;
  String serviceLocationId;
  int minimumTripAmount;
  int maximumDiscountAmount;
  int discountPercent;
  int totalUses;
  int usesPerUser;
  DateTime from;
  DateTime to;
  int active;
  bool isApplied;

  PromoCodeListData({
    required this.id,
    required this.code,
    required this.serviceLocationId,
    required this.minimumTripAmount,
    required this.maximumDiscountAmount,
    required this.discountPercent,
    required this.totalUses,
    required this.usesPerUser,
    required this.from,
    required this.to,
    required this.active,
    required this.isApplied,
  });

  factory PromoCodeListData.fromJson(Map<String, dynamic> json) =>
      PromoCodeListData(
        id: json["id"],
        code: json["code"],
        serviceLocationId: json["service_location_id"],
        minimumTripAmount: json["minimum_trip_amount"],
        maximumDiscountAmount: json["maximum_discount_amount"],
        discountPercent: json["discount_percent"],
        totalUses: json["total_uses"],
        usesPerUser: json["uses_per_user"],
        from: DateTime.parse(json["from"]),
        to: DateTime.parse(json["to"]),
        active: json["active"],
        isApplied: json["is_applied"],
      );
}
