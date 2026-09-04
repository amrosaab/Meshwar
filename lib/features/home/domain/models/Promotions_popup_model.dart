// To parse this JSON data, do
//
//     final promotionsPopupModel = promotionsPopupModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

PromotionsPopupModel promotionsPopupModelFromJson(String str) =>
    PromotionsPopupModel.fromJson(json.decode(str));

String promotionsPopupModelToJson(PromotionsPopupModel data) =>
    json.encode(data.toJson());

class PromotionsPopupModel {
  PromotionsPopupData data;

  PromotionsPopupModel({
    required this.data,
  });

  factory PromotionsPopupModel.fromJson(Map<String, dynamic> json) =>
      PromotionsPopupModel(
        data: PromotionsPopupData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class PromotionsPopupData {
  String subject;
  String previewImage;
  DateTime from;
  DateTime to;
  int time;
  bool active;

  PromotionsPopupData({
    required this.subject,
    required this.previewImage,
    required this.from,
    required this.to,
    required this.time,
    required this.active,
  });

  factory PromotionsPopupData.fromJson(Map<String, dynamic> json) =>
      PromotionsPopupData(
        subject: json["subject"],
        previewImage: json["preview_image"],
        from: DateTime.parse(json["from"]),
        to: DateTime.parse(json["to"]),
        time: json["time"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "subject": subject,
        "preview_image": previewImage,
        "from": from.toIso8601String(),
        "to": to.toIso8601String(),
        "time": time,
        "active": active,
      };
}
