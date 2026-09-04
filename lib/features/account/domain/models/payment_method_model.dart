import 'dart:convert';

PaymentAuthModel paymentMethodModelFromJson(String str) =>
    PaymentAuthModel.fromJson(json.decode(str));

String paymentMethodModelToJson(PaymentAuthModel data) =>
    json.encode(data.toJson());

class PaymentAuthModel {
  bool success;
  String message;
  PaymentAuthData data;

  PaymentAuthModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PaymentAuthModel.fromJson(Map<String, dynamic> json) =>
      PaymentAuthModel(
        success: json["success"] ?? false,
        message: json["message"] ?? '',
        data: PaymentAuthData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class PaymentAuthData {
  String clientSecret;
  dynamic customerId;
  bool testEnvironment;

  PaymentAuthData({
    required this.clientSecret,
    required this.customerId,
    required this.testEnvironment,
  });

  factory PaymentAuthData.fromJson(Map<String, dynamic> json) =>
      PaymentAuthData(
        clientSecret: json["client_secret"] ?? '',
        customerId: json["customer_id"] ?? '',
        testEnvironment: json["test_environment"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "client_secret": clientSecret,
        "customer_id": customerId,
        "test_environment": testEnvironment,
      };
}
