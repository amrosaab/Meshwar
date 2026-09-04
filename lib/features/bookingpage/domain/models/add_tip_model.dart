// To parse this JSON data, do
//
//     final addTipResponseModel = addTipResponseModelFromJson(jsonString);

import 'dart:convert';

AddTipResponseModel addTipResponseModelFromJson(String str) =>
    AddTipResponseModel.fromJson(json.decode(str));

String addTipResponseModelToJson(AddTipResponseModel data) =>
    json.encode(data.toJson());

class AddTipResponseModel {
  bool success;
  String message;
  AddTipResponseData data;

  AddTipResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AddTipResponseModel.fromJson(Map<String, dynamic> json) =>
      AddTipResponseModel(
        success: json["success"],
        message: json["message"],
        data: AddTipResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class AddTipResponseData {
  int id;
  double basePrice;
  double baseDistance;
  double pricePerDistance;
  double distancePrice;
  double pricePerTime;
  double timePrice;
  double waitingCharge;
  double cancellationFee;
  double airportSurgeFee;
  double serviceTax;
  double serviceTaxPercentage;
  double promoDiscount;
  double adminCommision;
  double driverCommision;
  double driverTips;
  String totalAmount;
  String requestedCurrencyCode;
  String requestedCurrencySymbol;
  double adminCommisionWithTax;
  int calculatedWaitingTime;
  double waitingChargePerMin;
  double adminCommisionFromDriver;
  double additionalChargesAmount;
  String? additionalChargesReason;

  AddTipResponseData({
    required this.id,
    required this.basePrice,
    required this.baseDistance,
    required this.pricePerDistance,
    required this.distancePrice,
    required this.pricePerTime,
    required this.timePrice,
    required this.waitingCharge,
    required this.cancellationFee,
    required this.airportSurgeFee,
    required this.serviceTax,
    required this.serviceTaxPercentage,
    required this.promoDiscount,
    required this.adminCommision,
    required this.driverCommision,
    required this.totalAmount,
    required this.driverTips,
    required this.requestedCurrencyCode,
    required this.requestedCurrencySymbol,
    required this.adminCommisionWithTax,
    required this.calculatedWaitingTime,
    required this.waitingChargePerMin,
    required this.adminCommisionFromDriver,
    required this.additionalChargesReason,
    required this.additionalChargesAmount,
  });

  factory AddTipResponseData.fromJson(Map<String, dynamic> json) =>
      AddTipResponseData(
        id: json["id"],
        basePrice: json["base_price"],
        baseDistance: json["base_distance"],
        pricePerDistance: json["price_per_distance"],
        distancePrice: json["distance_price"],
        pricePerTime: json["price_per_time"],
        timePrice: json["time_price"],
        waitingCharge: json["waiting_charge"],
        cancellationFee: json["cancellation_fee"],
        airportSurgeFee: json["airport_surge_fee"],
        serviceTax: json["service_tax"],
        serviceTaxPercentage: json["service_tax_percentage"],
        promoDiscount: json["promo_discount"],
        adminCommision: json["admin_commision"],
        driverCommision: json["driver_commision"]?.toDouble(),
        totalAmount: json["total_amount"],
        driverTips: json["driver_tips"]?.toDouble(),
        requestedCurrencyCode: json["requested_currency_code"],
        requestedCurrencySymbol: json["requested_currency_symbol"],
        adminCommisionWithTax: json["admin_commision_with_tax"]?.toDouble(),
        calculatedWaitingTime: json["calculated_waiting_time"],
        waitingChargePerMin: json["waiting_charge_per_min"],
        adminCommisionFromDriver:
            json["admin_commision_from_driver"]?.toDouble(),
        additionalChargesReason: json["additional_charges_reason"],
        additionalChargesAmount: json["additional_charges_amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "base_price": basePrice,
        "base_distance": baseDistance,
        "price_per_distance": pricePerDistance,
        "distance_price": distancePrice,
        "price_per_time": pricePerTime,
        "time_price": timePrice,
        "waiting_charge": waitingCharge,
        "cancellation_fee": cancellationFee,
        "airport_surge_fee": airportSurgeFee,
        "service_tax": serviceTax,
        "service_tax_percentage": serviceTaxPercentage,
        "promo_discount": promoDiscount,
        "admin_commision": adminCommision,
        "driver_commision": driverCommision,
        "total_amount": totalAmount,
        "driver_tips": driverTips,
        "requested_currency_code": requestedCurrencyCode,
        "requested_currency_symbol": requestedCurrencySymbol,
        "admin_commision_with_tax": adminCommisionWithTax,
        "calculated_waiting_time": calculatedWaitingTime,
        "waiting_charge_per_min": waitingChargePerMin,
        "admin_commision_from_driver": adminCommisionFromDriver,
        "additional_charges_reason": additionalChargesReason,
        "additional_charges_amount": additionalChargesAmount,
      };
}
