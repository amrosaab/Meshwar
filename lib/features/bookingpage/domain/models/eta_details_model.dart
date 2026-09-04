import 'dart:convert';

EtaDetailsListModel etaDetailsModelFromJson(String str) =>
    EtaDetailsListModel.fromJson(json.decode(str));

class EtaDetailsListModel {
  bool success;
  dynamic message;
  List<EtaDetails> data;
  List<CardDetails>? savedCards;
  EnabledDispatchType enabledDispatchType;

  EtaDetailsListModel({
    required this.success,
    required this.message,
    required this.data,
    required this.savedCards,
    required this.enabledDispatchType,
  });

  factory EtaDetailsListModel.fromJson(Map<String, dynamic> json) =>
      EtaDetailsListModel(
        success: json["success"],
        message: json["message"],
        data: List<EtaDetails>.from(
            json["data"].map((x) => EtaDetails.fromJson(x))),
        savedCards: json["saved_cards"] != null
            ? List<CardDetails>.from(
                json["saved_cards"].map((x) => CardDetails.fromJson(x)))
            : [],
        enabledDispatchType:
            EnabledDispatchType.fromJson(json["enabled_dispatch_type"]),
      );
}

class EnabledDispatchType {
  bool ondemand;
  bool bidding;
  bool shared;

  EnabledDispatchType({
    required this.ondemand,
    required this.bidding,
    required this.shared,
  });

  factory EnabledDispatchType.fromJson(Map<String, dynamic> json) =>
      EnabledDispatchType(
        ondemand: json["ondemand"] ?? false,
        bidding: json["bidding"] ?? false,
        shared: json["shared"] ?? false,
      );
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

class EtaDetails {
  String zoneTypeId;
  String name;
  String iconType;
  String vehicleIcon;
  String description;
  String shortDescription;
  String supportedVehicles;
  String? size;
  int capacity;
  String permitType;
  String bodyType;
  String paymentType;
  bool isDefault;
  bool enableBidding;
  String dispatchType;
  String icon;
  String typeId;
  double userWalletBalance;
  bool hasDiscount;
  double discountAmount;
  String distance;
  String calculatedDistance;
  String distanceInMeters;
  double time;
  int baseDistance;
  double basePrice;
  double pricePerDistance;
  double pricePerTime;
  double distancePrice;
  double timePrice;

  double rideFare;
  double taxAmount;
  double withoutDiscountAdminCommision;
  double preferencePriceTotal;
  double discountAdminCommision;
  String tax;
  double total;
  double discountTotal;
  double approximateValue;
  double minAmount;
  double maxAmount;
  String currency;
  String currencyName;
  String typeName;
  int unit;
  String unitInWordsWithoutLang;
  String unitInWords;
  double airportSurgeFee;
  String biddingLowPercentage;
  String biddingHighPercentage;
  int freeWaitingTimeInMinsBeforeTripStart;
  int freeWaitingTimeInMinsAfterTripStart;
  double waitingCharge;
  String promocodeId;
  bool enableSharedRide;
  bool enableGoodsType;
  List<PreferenceDetails>? preferenceList;

  EtaDetails({
    required this.zoneTypeId,
    required this.name,
    required this.iconType,
    required this.vehicleIcon,
    required this.description,
    required this.shortDescription,
    required this.supportedVehicles,
    required this.size,
    required this.capacity,
    required this.permitType,
    required this.bodyType,
    required this.paymentType,
    required this.isDefault,
    required this.enableBidding,
    required this.dispatchType,
    required this.icon,
    required this.typeId,
    required this.userWalletBalance,
    required this.hasDiscount,
    required this.discountAmount,
    required this.distance,
    required this.calculatedDistance,
    required this.distanceInMeters,
    required this.time,
    required this.baseDistance,
    required this.basePrice,
    required this.pricePerDistance,
    required this.pricePerTime,
    required this.distancePrice,
    required this.timePrice,
    required this.rideFare,
    required this.taxAmount,
    required this.withoutDiscountAdminCommision,
    required this.preferencePriceTotal,
    required this.discountAdminCommision,
    required this.tax,
    required this.total,
    required this.discountTotal,
    required this.approximateValue,
    required this.minAmount,
    required this.maxAmount,
    required this.currency,
    required this.currencyName,
    required this.typeName,
    required this.unit,
    required this.unitInWordsWithoutLang,
    required this.unitInWords,
    required this.airportSurgeFee,
    required this.biddingLowPercentage,
    required this.biddingHighPercentage,
    required this.freeWaitingTimeInMinsAfterTripStart,
    required this.freeWaitingTimeInMinsBeforeTripStart,
    required this.waitingCharge,
    required this.promocodeId,
    required this.enableSharedRide,
    required this.enableGoodsType,
    this.preferenceList,
  });

  factory EtaDetails.fromJson(Map<String, dynamic> json) => EtaDetails(
        zoneTypeId: json["zone_type_id"] ?? '',
        name: json["name"] ?? '',
        iconType: json["icon_type"] ?? '',
        vehicleIcon: json["vehicle_icon"] ?? '',
        description: json["description"] ?? '',
        shortDescription: json["short_description"] ?? '',
        supportedVehicles: json["supported_vehicles"] ?? '',
        size: json["size"] ?? '',
        capacity: json["capacity"] ?? 0,
        permitType: json["permit_type"] ?? '',
        bodyType: json["body_type"] ?? '',
        paymentType: json["payment_type"] ?? '',
        isDefault: json["is_default"] ?? false,
        enableBidding: json["enable_bidding"] ?? false,
        dispatchType: json["dispatch_type"] ?? 'normal',
        icon: json["icon"] ?? '',
        typeId: json["type_id"] ?? '',
        userWalletBalance: json["user_wallet_balance"]?.toDouble() ?? 0,
        hasDiscount: json["has_discount"] ?? true,
        discountAmount: json["discount_amount"]?.toDouble() ?? 0.0,
        distance: json["distance"].toString(),
        calculatedDistance: json["calculated_distance"].toString(),
        distanceInMeters: json["distance_in_meters"].toString(),
        time: json["time"]?.toDouble() ?? 0.0,
        baseDistance: json["base_distance"] ?? 0,
        basePrice: json["base_price"]?.toDouble() ?? 0.0,
        pricePerDistance: json["price_per_distance"]?.toDouble() ?? 0.0,
        pricePerTime: json["price_per_time"]?.toDouble() ?? 0,
        distancePrice: json["distance_price"]?.toDouble() ?? 0.0,
        timePrice: json["time_price"]?.toDouble() ?? 0.0,
        rideFare: json["ride_fare"]?.toDouble() ?? 0.0,
        taxAmount: json["tax_amount"]?.toDouble() ?? 0,
        withoutDiscountAdminCommision:
            json["without_discount_admin_commision"]?.toDouble() ?? 0,
        discountAdminCommision:
            json["discount_admin_commision"]?.toDouble() ?? 0,
        preferencePriceTotal: json["preference_price_total"]?.toDouble() ?? 0,
        tax: json["tax"].toString(),
        total: json["total"]?.toDouble() ?? 0.0,
        discountTotal: json["discounted_totel"]?.toDouble() ?? 0,
        approximateValue: json["approximate_value"]?.toDouble() ?? 0.0,
        minAmount: json["min_amount"]?.toDouble() ?? 0.0,
        maxAmount: json["max_amount"]?.toDouble() ?? 0,
        currency: json["currency"] ?? '',
        currencyName: json["currency_name"] ?? '',
        typeName: json["type_name"] ?? '',
        unit: json["unit"] ?? 0,
        unitInWordsWithoutLang: json["unit_in_words_without_lang"] ?? '',
        unitInWords: json["unit_in_words"] ?? '',
        airportSurgeFee: json["airport_surge_fee"]?.toDouble() ?? 0.0,
        biddingLowPercentage: json["bidding_low_percentage"] ?? '',
        biddingHighPercentage: json["bidding_high_percentage"] ?? '',
        freeWaitingTimeInMinsAfterTripStart:
            json["free_waiting_time_in_mins_after_trip_start"] ?? 0,
        freeWaitingTimeInMinsBeforeTripStart:
            json["free_waiting_time_in_mins_before_trip_start"] ?? 0,
        waitingCharge: json["waiting_charge"]?.toDouble() ?? 0,
        promocodeId: json["promocode_id"] ?? '',
        enableSharedRide: json["enable_shared_ride"] ?? false,
        enableGoodsType: json["enable_goods_type"] ?? false,
        preferenceList: json["preference"] != null
            ? List<PreferenceDetails>.from(
                json["preference"].map((x) => PreferenceDetails.fromJson(x)))
            : [],
      );
}

class PreferenceDetails {
  int id;
  int preferenceId;
  String name;
  String icon;
  int price;

  PreferenceDetails({
    required this.id,
    required this.preferenceId,
    required this.name,
    required this.icon,
    required this.price,
  });

  factory PreferenceDetails.fromJson(Map<String, dynamic> json) =>
      PreferenceDetails(
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

class Category {
  List<CategoryData> data;

  Category({
    required this.data,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        data: List<CategoryData>.from(
            json["data"].map((x) => CategoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CategoryData {
  String id;
  String name;
  String transportType;

  CategoryData({
    required this.id,
    required this.name,
    required this.transportType,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        transportType: json["transport_type"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "transport_type": transportType,
      };
}
