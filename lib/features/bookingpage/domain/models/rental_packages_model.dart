import 'dart:convert';

RentalPackagesModel rentalPackagesModelFromJson(String str) =>
    RentalPackagesModel.fromJson(json.decode(str));

String rentalPackagesModelToJson(RentalPackagesModel data) =>
    json.encode(data.toJson());

class RentalPackagesModel {
  bool success;
  String message;
  List<RentalPackagesData> data;
  List<CardDetails> savedCards;

  RentalPackagesModel({
    required this.success,
    required this.message,
    required this.data,
    required this.savedCards,
  });

  factory RentalPackagesModel.fromJson(Map<String, dynamic> json) =>
      RentalPackagesModel(
        success: json["success"],
        message: json["message"],
        data: List<RentalPackagesData>.from(
            json["data"].map((x) => RentalPackagesData.fromJson(x))),
        savedCards: List<CardDetails>.from(
            json["saved_cards"].map((x) => CardDetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "saved_cards": List<CardDetails>.from(data.map((x) => x.toJson())),
      };
}

class CardDetails {
  String gateway;
  bool enabled;
  bool isCard;
  String image;
  String url;

  CardDetails({
    required this.gateway,
    required this.enabled,
    required this.image,
    required this.url,
    required this.isCard,
  });

  factory CardDetails.fromJson(Map<String, dynamic> json) => CardDetails(
        gateway: json["gateway"]?.toString() ?? '',
        enabled: json["enabled"] ?? false,
        image: json["image"] ?? '',
        url: json["url"] ?? '',
        isCard: json["is_card"] ?? false,
      );
}

class RentalPackagesData {
  int id;
  String packageName;
  String description;
  String shortDescription;
  double userWalletBalance;
  String currency;
  String currencyName;
  double? maxPrice;
  double? minPrice;
  dynamic typesWithPrice;

  RentalPackagesData({
    required this.id,
    required this.packageName,
    required this.description,
    required this.shortDescription,
    required this.userWalletBalance,
    required this.currency,
    required this.currencyName,
    required this.maxPrice,
    required this.minPrice,
    required this.typesWithPrice,
  });

  factory RentalPackagesData.fromJson(Map<String, dynamic> json) =>
      RentalPackagesData(
        id: json["id"] ?? 0,
        packageName: json["package_name"] ?? '',
        description: json["description"] ?? '',
        shortDescription: json["short_description"] ?? '',
        userWalletBalance: json["user_wallet_balance"]?.toDouble() ?? 0,
        currency: json["currency"] ?? '',
        currencyName: json["currency_name"] ?? '',
        maxPrice: json["max_price"]?.toDouble() ?? 0,
        minPrice: json["min_price"]?.toDouble() ?? 0,
        typesWithPrice: json["typesWithPrice"] != null
            ? TypesWithPrice.fromJson(json["typesWithPrice"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "package_name": packageName,
        "description": description,
        "short_description": shortDescription,
        "user_wallet_balance": userWalletBalance,
        "currency": currency,
        "currency_name": currencyName,
        "max_price": maxPrice,
        "min_price": minPrice,
        "typesWithPrice": (typesWithPrice != null)
            ? typesWithPrice?.toJson()
            : typesWithPrice,
      };
}

class TypesWithPrice {
  List<RentalEtaDetails> data;

  TypesWithPrice({
    required this.data,
  });

  factory TypesWithPrice.fromJson(Map<String, dynamic> json) => TypesWithPrice(
        data: List<RentalEtaDetails>.from(
            json["data"].map((x) => RentalEtaDetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class RentalEtaDetails {
  String zoneTypeId;
  String typeId;
  String name;
  int capacity;
  String currency;
  int unit;
  String unitInWords;
  String distancePricePerKm;
  String timePricePerMin;
  String freeDistance;
  String freeMin;
  double fareAmount;
  String description;
  String shortDescription;
  dynamic supportedVehicles;
  String icon;
  String driverArivalEstimation;
  bool isDefault;
  String paymentType;
  double discountedTotel;
  bool hasDiscount;
  String promocodeId;
  dynamic rentalPreferencePriceTotal;
  double rentalTotal;
  bool enableGoodsType;
  List<RentalPreferenceDetails>? rentalPreferenceList;

  RentalEtaDetails({
    required this.zoneTypeId,
    required this.typeId,
    required this.name,
    required this.capacity,
    required this.currency,
    required this.unit,
    required this.unitInWords,
    required this.distancePricePerKm,
    required this.timePricePerMin,
    required this.freeDistance,
    required this.freeMin,
    required this.fareAmount,
    required this.description,
    required this.shortDescription,
    required this.supportedVehicles,
    required this.icon,
    required this.driverArivalEstimation,
    required this.isDefault,
    required this.paymentType,
    required this.discountedTotel,
    required this.hasDiscount,
    required this.promocodeId,
    required this.rentalPreferencePriceTotal,
    required this.rentalTotal,
    required this.enableGoodsType,
    this.rentalPreferenceList,
  });

  factory RentalEtaDetails.fromJson(Map<String, dynamic> json) =>
      RentalEtaDetails(
        zoneTypeId: json["zone_type_id"] ?? '',
        typeId: json["type_id"] ?? '',
        name: json["name"] ?? '',
        capacity: json["capacity"] ?? 0,
        currency: json["currency"] ?? '',
        unit: json["unit"] ?? 0,
        unitInWords: json["unit_in_words"] ?? '',
        distancePricePerKm: json["distance_price_per_km"]?.toString() ?? '',
        timePricePerMin: json["time_price_per_min"] ?? '',
        freeDistance: json["free_distance"] ?? '',
        freeMin: json["free_min"] ?? '',
        fareAmount: json["fare_amount"].toDouble() ?? 0.0,
        description: json["description"] ?? '',
        shortDescription: json["short_description"] ?? '',
        supportedVehicles: json["supported_vehicles"] ?? '',
        icon: json["icon"] ?? '',
        driverArivalEstimation: json["driver_arival_estimation"] ?? '',
        isDefault: json["is_default"] ?? false,
        paymentType: json["payment_type"] ?? '',
        discountedTotel: json["discounted_total"]?.toDouble() ?? 0,
        hasDiscount: json["has_discount"] ?? false,
        promocodeId: json["promocode_id"] ?? '',
        rentalPreferencePriceTotal:
            json["preference_price_total"].toDouble() ?? 0.0,
        rentalTotal: json["total"].toDouble() ?? 0.0,
        enableGoodsType: json["enable_goods_type"] ?? false,
        rentalPreferenceList: json["preference"] != null
            ? List<RentalPreferenceDetails>.from(json["preference"]
                .map((x) => RentalPreferenceDetails.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "zone_type_id": zoneTypeId,
        "type_id": typeId,
        "name": name,
        "capacity": capacity,
        "currency": currency,
        "unit": unit,
        "unit_in_words": unitInWords,
        "distance_price_per_km": distancePricePerKm,
        "time_price_per_min": timePricePerMin,
        "free_distance": freeDistance,
        "free_min": freeMin,
        "fare_amount": fareAmount,
        "description": description,
        "short_description": shortDescription,
        "supported_vehicles": supportedVehicles,
        "icon": icon,
        "driver_arival_estimation": driverArivalEstimation,
        "is_default": isDefault,
        "payment_type": paymentType,
        "discounted_totel": discountedTotel,
        "has_discount": hasDiscount,
        "promocode_id": promocodeId,
        "preference_price_total": rentalPreferencePriceTotal,
        "total": rentalTotal,
        "enable_goods_type": enableGoodsType,
        "preference":
            List<dynamic>.from(rentalPreferenceList!.map((x) => x.toJson())),
      };
}

class RentalPreferenceDetails {
  int id;
  int preferenceId;
  String name;
  String icon;
  int price;

  RentalPreferenceDetails({
    required this.id,
    required this.preferenceId,
    required this.name,
    required this.icon,
    required this.price,
  });

  factory RentalPreferenceDetails.fromJson(Map<String, dynamic> json) =>
      RentalPreferenceDetails(
        id: json["id"],
        preferenceId: json["preference_id"],
        name: json["name"],
        icon: json["icon"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "preference_id": preferenceId,
        "name": name,
        "icon": icon,
        "price": price,
      };
}
