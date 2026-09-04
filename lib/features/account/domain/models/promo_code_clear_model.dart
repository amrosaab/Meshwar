// To parse this JSON data, do
//
//     final promoCodeListModel = promoCodeListModelFromJson(jsonString);

import 'dart:convert';

PromoCodeClearModel promoCodeListModelFromJson(String str) =>
    PromoCodeClearModel.fromJson(json.decode(str));

class PromoCodeClearModel {
  bool success;
  String message;
  List<dynamic> data;

  PromoCodeClearModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PromoCodeClearModel.fromJson(Map<String, dynamic> json) =>
      PromoCodeClearModel(
        success: json["success"],
        message: json["message"],
        data: List<dynamic>.from(json["data"].map((x) => x)),
      );
}
