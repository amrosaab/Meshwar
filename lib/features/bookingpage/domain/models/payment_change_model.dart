// To parse this JSON data, do
//
//     final paymentChange = paymentChangeFromJson(jsonString);

import 'dart:convert';

PaymentChange paymentChangeFromJson(String str) =>
    PaymentChange.fromJson(json.decode(str));

String paymentChangeToJson(PaymentChange data) => json.encode(data.toJson());

class PaymentChange {
  bool success;
  String message;

  PaymentChange({
    required this.success,
    required this.message,
  });

  factory PaymentChange.fromJson(Map<String, dynamic> json) => PaymentChange(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
