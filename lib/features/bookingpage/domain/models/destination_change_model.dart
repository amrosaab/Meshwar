// To parse this JSON data, do
//
//     final destinationChangeModel = destinationChangeModelFromJson(jsonString);

import 'dart:convert';

DestinationChangeModel destinationChangeModelFromJson(String str) =>
    DestinationChangeModel.fromJson(json.decode(str));

String destinationChangeModelToJson(DestinationChangeModel data) =>
    json.encode(data.toJson());

class DestinationChangeModel {
  bool success;
  String message;
  DestinationChangeModelData data;

  DestinationChangeModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DestinationChangeModel.fromJson(Map<String, dynamic> json) =>
      DestinationChangeModel(
        success: json["success"],
        message: json["message"],
        data: DestinationChangeModelData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class DestinationChangeModelData {
  String id;
  String requestNumber;
  int rideOtp;
  bool isLater;
  int userId;
  String serviceLocationId;
  String tripStartTime;
  String arrivedAt;
  String acceptedAt;
  String completedAt;
  int isDriverStarted;
  int isDriverArrived;
  String updatedAt;
  int isTripStart;
  String totalDistance;
  String totalTime;
  int isCompleted;
  int isCancelled;
  String cancelMethod;
  String paymentOpt;
  int isPaid;
  int userRated;
  int driverRated;
  String unit;
  String zoneTypeId;
  String vehicleTypeId;
  String vehicleTypeName;
  String vehicleTypeImage;
  String carMakeName;
  String carModelName;
  String carColor;
  String carNumber;
  String pickLat;
  String pickLng;
  String dropLat;
  String dropLng;
  String pickAddress;
  String dropAddress;
  String pickupPocName;
  String pickupPocMobile;
  String dropPocName;
  String dropPocMobile;
  String pickupPocInstruction;
  String dropPocInstruction;
  String requestedCurrencyCode;
  String requestedCurrencySymbol;
  double userCancellationFee;
  bool isRental;
  dynamic rentalPackageId;
  String isOutStation;
  dynamic returnTime;
  dynamic isRoundTrip;
  String rentalPackageName;
  bool showDropLocation;
  String requestEtaAmount;
  bool showRequestEtaAmount;
  String offerredRideFare;
  String acceptedRideFare;
  int isBidRide;
  int rideUserRating;
  int rideDriverRating;
  bool ifDispatch;
  String goodsType;
  dynamic goodsTypeQuantity;
  dynamic convertedTripStartTime;
  dynamic convertedArrivedAt;
  String convertedAcceptedAt;
  dynamic convertedCompletedAt;
  dynamic convertedCancelledAt;
  String convertedCreatedAt;
  String paymentType;
  dynamic discountedTotal;
  String polyLine;
  int isPetAvailable;
  int isLuggageAvailable;
  bool showOtpFeature;
  bool completedRide;
  bool laterRide;
  bool cancelledRide;
  bool ongoingRide;
  dynamic tripStartTimeWithDate;
  dynamic arrivedAtWithDate;
  String acceptedAtWithDate;
  dynamic completedAtWithDate;
  dynamic cancelledAtWithDate;
  String creatededAtWithDate;
  String biddingLowPercentage;
  String biddingHighPercentage;
  int maximumTimeForFindDriversForRegularRide;
  int freeWaitingTimeInMinsBeforeTripStart;
  int freeWaitingTimeInMinsAfterTripStart;
  double waitingCharge;
  String paymentTypeString;
  dynamic cvTripStartTime;
  dynamic cvCompletedAt;
  String cvCreatedAt;
  String transportType;
  dynamic requestStops;
  dynamic driverDetail;
  dynamic requestBill;
  RequestUserDetail? userDetail;
  List<PaymentGatewayData> paymentGateways;
  String enableDriverTipsFeature;
  String minimumTipAmount;
  String parcelType;

  DestinationChangeModelData({
    required this.id,
    required this.requestNumber,
    required this.rideOtp,
    required this.isLater,
    required this.userId,
    required this.serviceLocationId,
    required this.tripStartTime,
    required this.arrivedAt,
    required this.acceptedAt,
    required this.completedAt,
    required this.isDriverStarted,
    required this.isDriverArrived,
    required this.updatedAt,
    required this.isTripStart,
    required this.totalDistance,
    required this.totalTime,
    required this.isCompleted,
    required this.isCancelled,
    required this.cancelMethod,
    required this.paymentOpt,
    required this.isPaid,
    required this.userRated,
    required this.driverRated,
    required this.unit,
    required this.zoneTypeId,
    required this.vehicleTypeId,
    required this.vehicleTypeName,
    required this.vehicleTypeImage,
    required this.carMakeName,
    required this.carModelName,
    required this.carColor,
    required this.carNumber,
    required this.pickLat,
    required this.pickLng,
    required this.dropLat,
    required this.dropLng,
    required this.pickAddress,
    required this.dropAddress,
    required this.pickupPocName,
    required this.pickupPocMobile,
    required this.dropPocName,
    required this.dropPocMobile,
    required this.pickupPocInstruction,
    required this.dropPocInstruction,
    required this.requestedCurrencyCode,
    required this.requestedCurrencySymbol,
    required this.userCancellationFee,
    required this.isRental,
    required this.rentalPackageId,
    required this.isOutStation,
    required this.returnTime,
    required this.isRoundTrip,
    required this.rentalPackageName,
    required this.showDropLocation,
    required this.requestEtaAmount,
    required this.showRequestEtaAmount,
    required this.offerredRideFare,
    required this.acceptedRideFare,
    required this.isBidRide,
    required this.rideUserRating,
    required this.rideDriverRating,
    required this.ifDispatch,
    required this.goodsType,
    required this.goodsTypeQuantity,
    required this.convertedTripStartTime,
    required this.convertedArrivedAt,
    required this.convertedAcceptedAt,
    required this.convertedCompletedAt,
    required this.convertedCancelledAt,
    required this.convertedCreatedAt,
    required this.paymentType,
    required this.discountedTotal,
    required this.polyLine,
    required this.isPetAvailable,
    required this.isLuggageAvailable,
    required this.showOtpFeature,
    required this.completedRide,
    required this.laterRide,
    required this.cancelledRide,
    required this.ongoingRide,
    required this.tripStartTimeWithDate,
    required this.arrivedAtWithDate,
    required this.acceptedAtWithDate,
    required this.completedAtWithDate,
    required this.cancelledAtWithDate,
    required this.creatededAtWithDate,
    required this.biddingLowPercentage,
    required this.biddingHighPercentage,
    required this.maximumTimeForFindDriversForRegularRide,
    required this.freeWaitingTimeInMinsBeforeTripStart,
    required this.freeWaitingTimeInMinsAfterTripStart,
    required this.waitingCharge,
    required this.paymentTypeString,
    required this.cvTripStartTime,
    required this.cvCompletedAt,
    required this.cvCreatedAt,
    required this.transportType,
    required this.requestStops,
    required this.userDetail,
    required this.driverDetail,
    required this.requestBill,
    required this.paymentGateways,
    required this.enableDriverTipsFeature,
    required this.minimumTipAmount,
    required this.parcelType,
  });

  factory DestinationChangeModelData.fromJson(Map<String, dynamic> json) =>
      DestinationChangeModelData(
          id: json["id"] ?? '',
          requestNumber: json["request_number"] ?? '',
          rideOtp: json["ride_otp"] ?? 0,
          isLater: json["is_later"] ?? false,
          userId: json["user_id"] ?? 0,
          serviceLocationId: json["service_location_id"] ?? '',
          tripStartTime: json["trip_start_time"] ?? '',
          arrivedAt: json["arrived_at"] ?? '',
          acceptedAt: json["accepted_at"] ?? '',
          completedAt: json["completed_at"] ?? '',
          isDriverStarted: json["is_driver_started"] ?? 0,
          isDriverArrived: json["is_driver_arrived"] ?? 0,
          updatedAt: json["updated_at"] ?? '',
          isTripStart: json["is_trip_start"] ?? 0,
          totalDistance: json["total_distance"] ?? '0',
          totalTime: json["total_time"].toString(),
          isCompleted: json["is_completed"] ?? 0,
          isCancelled: json["is_cancelled"] ?? 0,
          cancelMethod: json["cancel_method"] ?? "0",
          paymentOpt: json["payment_opt"] ?? '0',
          isPaid: json["is_paid"] ?? 0,
          userRated: json["user_rated"] ?? 0,
          driverRated: json["driver_rated"] ?? 0,
          unit: json["unit"] ?? '',
          zoneTypeId: json["zone_type_id"] ?? '',
          vehicleTypeId: json["vehicle_type_id"] ?? '',
          vehicleTypeName: json["vehicle_type_name"] ?? '',
          vehicleTypeImage: json["vehicle_type_image"] ?? '',
          carMakeName: json["car_make_name"] ?? '',
          carModelName: json["car_model_name"] ?? '',
          carColor: json["car_color"] ?? '',
          carNumber: json["car_number"] ?? '',
          pickLat:
              (json["pick_lat"] != null) ? json["pick_lat"].toString() : '0',
          pickLng:
              (json["pick_lng"] != null) ? json["pick_lng"].toString() : '0',
          dropLat:
              (json["drop_lat"] != null) ? json["drop_lat"].toString() : '0',
          dropLng:
              (json["drop_lng"] != null) ? json["drop_lng"].toString() : '0',
          pickAddress: json["pick_address"] ?? '',
          dropAddress: json["drop_address"] ?? '',
          pickupPocName: json["pickup_poc_name"] ?? '',
          pickupPocMobile: json["pickup_poc_mobile"] ?? '',
          dropPocName: json["drop_poc_name"] ?? '',
          dropPocMobile: json["drop_poc_mobile"] ?? '',
          pickupPocInstruction: json["pickup_poc_instruction"] ?? '',
          dropPocInstruction: json["drop_poc_instruction"] ?? '',
          requestedCurrencyCode: json["requested_currency_code"] ?? '',
          requestedCurrencySymbol: json["requested_currency_symbol"] ?? '',
          userCancellationFee: json["user_cancellation_fee"]?.toDouble() ?? 0,
          isRental: json["is_rental"] ?? false,
          rentalPackageId: json["rental_package_id"] ?? '',
          isOutStation: json["is_out_station"].toString(),
          returnTime: json["return_time"] ?? '',
          isRoundTrip: json["is_round_trip"] ?? '',
          rentalPackageName: json["rental_package_name"] ?? '',
          showDropLocation: json["show_drop_location"] ?? false,
          requestEtaAmount: json["request_eta_amount"].toString(),
          showRequestEtaAmount: json["show_request_eta_amount"] ?? false,
          offerredRideFare: json["offerred_ride_fare"].toString(),
          acceptedRideFare: json["accepted_ride_fare"].toString(),
          isBidRide: json["is_bid_ride"] ?? 0,
          rideUserRating: json["ride_user_rating"] ?? 0,
          rideDriverRating: json["ride_driver_rating"] ?? 0,
          ifDispatch: json["if_dispatch"] ?? false,
          goodsType: json["goods_type"] ?? '',
          goodsTypeQuantity: json["goods_type_quantity"] ?? '',
          convertedTripStartTime: json["converted_trip_start_time"] ?? '',
          convertedArrivedAt: json["converted_arrived_at"] ?? '',
          convertedAcceptedAt: json["converted_accepted_at"] ?? '',
          convertedCompletedAt: json["converted_completed_at"] ?? '',
          convertedCancelledAt: json["converted_cancelled_at"] ?? '',
          convertedCreatedAt: json["converted_created_at"] ?? '',
          paymentType: json["payment_type"] ?? '',
          discountedTotal: json["discounted_total"] ?? '',
          polyLine: json["poly_line"] ?? '',
          isPetAvailable: json["is_pet_available"] ?? 0,
          isLuggageAvailable: json["is_luggage_available"] ?? 0,
          showOtpFeature: json["show_otp_feature"] ?? false,
          completedRide: json["completed_ride"] ?? false,
          laterRide: json["later_ride"] ?? false,
          cancelledRide: json["cancelled_ride"] ?? false,
          ongoingRide: json["ongoing_ride"] ?? false,
          tripStartTimeWithDate: json["trip_start_time_with_date"] ?? '',
          arrivedAtWithDate: json["arrived_at_with_date"] ?? '',
          acceptedAtWithDate: json["accepted_at_with_date"] ?? '',
          completedAtWithDate: json["completed_at_with_date"] ?? '',
          cancelledAtWithDate: json["cancelled_at_with_date"] ?? '',
          creatededAtWithDate: json["createded_at_with_date"] ?? '',
          biddingLowPercentage: json["bidding_low_percentage"] ?? '',
          biddingHighPercentage: json["bidding_high_percentage"] ?? '',
          maximumTimeForFindDriversForRegularRide:
              json["maximum_time_for_find_drivers_for_regular_ride"] ?? 0,
          freeWaitingTimeInMinsBeforeTripStart:
              json["free_waiting_time_in_mins_before_trip_start"] ?? 0,
          freeWaitingTimeInMinsAfterTripStart:
              json["free_waiting_time_in_mins_after_trip_start"] ?? 0,
          waitingCharge: json["waiting_charge"]?.toDouble() ?? 0.0,
          paymentTypeString: json["payment_type_string"] ?? '',
          cvTripStartTime: json["cv_trip_start_time"] ?? '',
          cvCompletedAt: json["cv_completed_at"] ?? '',
          cvCreatedAt: json["cv_created_at"] ?? '',
          transportType: json["transport_type"] ?? '',
          requestStops: (json["requestStops"] != null)
              ? RequestStops.fromJson(json["requestStops"])
              : null,
          userDetail: (json["userDetail"] != null)
              ? RequestUserDetail.fromJson(json["userDetail"])
              : null,
          driverDetail: json["driverDetail"] != null
              ? DriverDetail.fromJson(json["driverDetail"])
              : null,
          requestBill: json["requestBill"] != null
              ? RequestBillModel.fromJson(json["requestBill"])
              : null,
          paymentGateways: json["payment_gateways"] != null
              ? List<PaymentGatewayData>.from(json["payment_gateways"]
                  .map((item) => PaymentGatewayData.fromJson(item)))
              : [],
          enableDriverTipsFeature: json['enable_driver_tips_feature'] ?? '0',
          minimumTipAmount: json['minimum_tip_amount']?.toString() ?? '0',
          parcelType: json['parcel_type'] ?? '');

  Map<String, dynamic> toJson() => {
        "id": id,
        "request_number": requestNumber,
        "ride_otp": rideOtp,
        "is_later": isLater,
        "user_id": userId,
        "service_location_id": serviceLocationId,
        "trip_start_time": tripStartTime,
        "arrived_at": arrivedAt,
        "accepted_at": acceptedAt,
        "completed_at": completedAt,
        "is_driver_started": isDriverStarted,
        "is_driver_arrived": isDriverArrived,
        "updated_at": updatedAt,
        "is_trip_start": isTripStart,
        "total_distance": totalDistance,
        "total_time": totalTime,
        "is_completed": isCompleted,
        "is_cancelled": isCancelled,
        "cancel_method": cancelMethod,
        "payment_opt": paymentOpt,
        "is_paid": isPaid,
        "user_rated": userRated,
        "driver_rated": driverRated,
        "unit": unit,
        "zone_type_id": zoneTypeId,
        "vehicle_type_id": vehicleTypeId,
        "vehicle_type_name": vehicleTypeName,
        "vehicle_type_image": vehicleTypeImage,
        "car_make_name": carMakeName,
        "car_model_name": carModelName,
        "car_color": carColor,
        "car_number": carNumber,
        "pick_lat": pickLat,
        "pick_lng": pickLng,
        "drop_lat": dropLat,
        "drop_lng": dropLng,
        "pick_address": pickAddress,
        "drop_address": dropAddress,
        "pickup_poc_name": pickupPocName,
        "pickup_poc_mobile": pickupPocMobile,
        "drop_poc_name": dropPocName,
        "drop_poc_mobile": dropPocMobile,
        "pickup_poc_instruction": pickupPocInstruction,
        "drop_poc_instruction": dropPocInstruction,
        "requested_currency_code": requestedCurrencyCode,
        "requested_currency_symbol": requestedCurrencySymbol,
        "user_cancellation_fee": userCancellationFee,
        "is_rental": isRental,
        "rental_package_id": rentalPackageId,
        "is_out_station": isOutStation,
        "return_time": returnTime,
        "is_round_trip": isRoundTrip,
        "rental_package_name": rentalPackageName,
        "show_drop_location": showDropLocation,
        "request_eta_amount": requestEtaAmount,
        "show_request_eta_amount": showRequestEtaAmount,
        "offerred_ride_fare": offerredRideFare,
        "accepted_ride_fare": acceptedRideFare,
        "is_bid_ride": isBidRide,
        "ride_user_rating": rideUserRating,
        "ride_driver_rating": rideDriverRating,
        "if_dispatch": ifDispatch,
        "goods_type": goodsType,
        "goods_type_quantity": goodsTypeQuantity,
        "converted_trip_start_time": convertedTripStartTime,
        "converted_arrived_at": convertedArrivedAt,
        "converted_accepted_at": convertedAcceptedAt,
        "converted_completed_at": convertedCompletedAt,
        "converted_cancelled_at": convertedCancelledAt,
        "converted_created_at": convertedCreatedAt,
        "payment_type": paymentType,
        "discounted_total": discountedTotal,
        "poly_line": polyLine,
        "is_pet_available": isPetAvailable,
        "is_luggage_available": isLuggageAvailable,
        "show_otp_feature": showOtpFeature,
        "completed_ride": completedRide,
        "later_ride": laterRide,
        "cancelled_ride": cancelledRide,
        "ongoing_ride": ongoingRide,
        "trip_start_time_with_date": tripStartTimeWithDate,
        "arrived_at__with_date": arrivedAtWithDate,
        "accepted_at__with_date": acceptedAtWithDate,
        "completed_at_with_date": completedAtWithDate,
        "cancelled_at_with_date": cancelledAtWithDate,
        "createded_at_with_date": creatededAtWithDate,
        "bidding_low_percentage": biddingLowPercentage,
        "bidding_high_percentage": biddingHighPercentage,
        "maximum_time_for_find_drivers_for_regular_ride":
            maximumTimeForFindDriversForRegularRide,
        "free_waiting_time_in_mins_before_trip_start":
            freeWaitingTimeInMinsBeforeTripStart,
        "free_waiting_time_in_mins_after_trip_start":
            freeWaitingTimeInMinsAfterTripStart,
        "waiting_charge": waitingCharge,
        "payment_type_string": paymentTypeString,
        "cv_trip_start_time": cvTripStartTime,
        "cv_completed_at": cvCompletedAt,
        "cv_created_at": cvCreatedAt,
        "transport_type": transportType,
        "requestStops": (requestStops != null) ? requestStops!.toJson() : null,
        "driverDetail": (driverDetail != null) ? driverDetail.toJson() : null,
        "requestBill": (requestBill != null) ? requestBill.toJson() : null,
        "payment_gateways":
            List<dynamic>.from(paymentGateways.map((x) => x.toJson())),
        "enable_driver_tips_feature": enableDriverTipsFeature,
        "minimum_tip_amount": minimumTipAmount,
        "parcelType": parcelType
      };
}

class PaymentGatewayData {
  String gateway;
  bool enabled;
  String image;
  String url;

  PaymentGatewayData({
    required this.gateway,
    required this.enabled,
    required this.image,
    required this.url,
  });

  factory PaymentGatewayData.fromJson(Map<String, dynamic> json) =>
      PaymentGatewayData(
        gateway: json["gateway"] ?? '',
        enabled: json["enabled"] ?? false,
        image: json["image"] ?? '',
        url: json["url"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "gateway": gateway,
        "enabled": enabled,
        "image": image,
        "url": url,
      };
}

class RequestBillModel {
  RequestBillData data;

  RequestBillModel({
    required this.data,
  });

  factory RequestBillModel.fromJson(Map<String, dynamic> json) =>
      RequestBillModel(
        data: RequestBillData.fromJson(json["data"]),
      );
}

class RequestBillData {
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
  String totalAmount;
  String requestedCurrencyCode;
  String requestedCurrencySymbol;
  double adminCommisionWithTax;
  String driverTips;
  int calculatedWaitingTime;
  double waitingChargePerMin;
  double adminCommisionFromDriver;
  double additionalChargesAmount;
  String? additionalChargesReason;
  String calculatedDistance;
  String totalTime;
  String unit;

  RequestBillData({
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
    required this.requestedCurrencyCode,
    required this.requestedCurrencySymbol,
    required this.adminCommisionWithTax,
    required this.driverTips,
    required this.calculatedWaitingTime,
    required this.waitingChargePerMin,
    required this.adminCommisionFromDriver,
    required this.additionalChargesAmount,
    required this.additionalChargesReason,
    required this.calculatedDistance,
    required this.totalTime,
    required this.unit,
  });

  factory RequestBillData.fromJson(Map<String, dynamic> json) =>
      RequestBillData(
        id: json["id"],
        basePrice: json["base_price"]?.toDouble(),
        baseDistance: json["base_distance"]?.toDouble(),
        pricePerDistance: json["price_per_distance"]?.toDouble(),
        distancePrice: json["distance_price"]?.toDouble(),
        pricePerTime: json["price_per_time"]?.toDouble(),
        timePrice: json["time_price"]?.toDouble(),
        waitingCharge: json["waiting_charge"]?.toDouble(),
        cancellationFee: json["cancellation_fee"]?.toDouble(),
        airportSurgeFee: json["airport_surge_fee"]?.toDouble(),
        serviceTax: json["service_tax"]?.toDouble(),
        serviceTaxPercentage: json["service_tax_percentage"]?.toDouble(),
        promoDiscount: json["promo_discount"]?.toDouble(),
        adminCommision: json["admin_commision"]?.toDouble(),
        driverCommision: json["driver_commision"]?.toDouble(),
        driverTips: json["driver_tips"]?.toString() ?? '0',
        totalAmount: json["total_amount"].toString(),
        requestedCurrencyCode: json["requested_currency_code"],
        requestedCurrencySymbol: json["requested_currency_symbol"],
        adminCommisionWithTax: json["admin_commision_with_tax"]?.toDouble(),
        calculatedWaitingTime: json["calculated_waiting_time"],
        waitingChargePerMin: json["waiting_charge_per_min"]?.toDouble(),
        adminCommisionFromDriver:
            json["admin_commision_from_driver"]?.toDouble(),
        additionalChargesAmount: json["additional_charges_amount"]?.toDouble(),
        additionalChargesReason: json["additional_charges_reason"],
        calculatedDistance: json["calculated_distance"].toString(),
        totalTime: json["total_time"].toString(),
        unit: json["unit"] ?? '',
      );
}

class RequestProofs {
  List<RequestProofsData> data;

  RequestProofs({
    required this.data,
  });

  factory RequestProofs.fromJson(Map<String, dynamic> json) => RequestProofs(
        data: List<RequestProofsData>.from(
            json["data"].map((x) => RequestProofsData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class RequestProofsData {
  String? id;
  int afterLoad;
  int afterUnload;
  String proofImage;

  RequestProofsData({
    required this.id,
    required this.afterLoad,
    required this.afterUnload,
    required this.proofImage,
  });

  factory RequestProofsData.fromJson(Map<String, dynamic> json) =>
      RequestProofsData(
        id: json["id"].toString(),
        afterLoad: json["after_load"] ?? 0,
        afterUnload: json["after_unload"] ?? 0,
        proofImage: json["proof_image"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "after_load": afterLoad,
        "after_unload": afterUnload,
        "proof_image": proofImage,
      };
}

class RequestStops {
  List<RequestStopsData> data;

  RequestStops({
    required this.data,
  });

  factory RequestStops.fromJson(Map<String, dynamic> json) => RequestStops(
        data: List<RequestStopsData>.from(
            json["data"].map((x) => RequestStopsData.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "data": List<Map<String, dynamic>>.from(data.map((x) => x.toJson())),
      };
}

class RequestStopsData {
  int id;
  int order;
  String address;
  double latitude;
  double longitude;
  String pocName;
  String pocMobile;
  String pocInstruction;
  String type;
  String isPickup;

  RequestStopsData(
      {required this.id,
      required this.address,
      required this.isPickup,
      required this.latitude,
      required this.longitude,
      required this.order,
      required this.pocInstruction,
      required this.pocMobile,
      required this.pocName,
      required this.type});

  factory RequestStopsData.fromJson(Map<String, dynamic> json) =>
      RequestStopsData(
        id: json["id"] ?? 0,
        order: json["order"] ?? 0,
        address: json["address"] ?? '',
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        pocName: json["poc_name"].toString(),
        pocMobile: json["poc_mobile"].toString(),
        pocInstruction: json["poc_instruction"].toString(),
        type: json["type"].toString(),
        isPickup: json["is_pickup"].toString(),
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "order": order,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "poc_name": pocName,
        "poc_mobile": pocMobile,
        "poc_instruction": pocInstruction,
        "type": type,
        "is_pickup": isPickup
      };
}

class RequestUserDetail {
  UserDetailData data;

  RequestUserDetail({
    required this.data,
  });

  factory RequestUserDetail.fromJson(Map<String, dynamic> json) =>
      RequestUserDetail(
        data: UserDetailData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class UserDetailData {
  int id;
  String name;
  String gender;
  dynamic lastName;
  dynamic username;
  String email;
  String mobile;
  String profilePicture;
  int active;
  int emailConfirmed;
  int mobileConfirmed;
  dynamic lastKnownIp;
  dynamic lastLoginAt;
  String rating;
  int noOfRatings;
  dynamic refferalCode;
  String currencyCode;
  String currencySymbol;
  String currencyPointer;
  String countryCode;
  bool showRentalRide;
  bool isDeliveryApp;
  dynamic fcmToken;
  bool showRideLaterFeature;
  dynamic zoneId;
  dynamic authorizationCode;
  String enableSupportTicketFeature;
  String enableModulesForApplications;
  String contactUsMobile1;
  String contactUsMobile2;
  String contactUsLink;
  String showWalletMoneyTransferFeatureOnMobileApp;
  String showBankInfoFeatureOnMobileApp;
  String showWalletFeatureOnMobileApp;
  String showOutstationRideFeature;
  String showTaxiOutstationRideFeature;
  String showDeliveryOutstationRideFeature;
  int notificationsCount;
  bool showTaxiRentalRide;
  bool showDeliveryRentalRide;
  bool showCardPaymentFeature;
  String referralComissionString;
  String userCanMakeARideAfterXMiniutes;
  int maximumTimeForFindDriversForRegularRide;
  String maximumTimeForFindDriversForBittingRide;
  String enablePetPreferenceForUser;
  String enableLuggagePreferenceForUser;
  String biddingAmountIncreaseOrDecrease;
  String showRideWithoutDestination;
  String enableCountryRestrictOnMap;
  String enableMapAppearanceChangeOnMobileApp;
  String conversationId;
  String mapType;
  bool hasOngoingRide;
  int completedRideCount;
  RequestProofs sos;
  RequestProofs bannerImage;
  Wallet wallet;

  UserDetailData({
    required this.id,
    required this.name,
    required this.gender,
    required this.lastName,
    required this.username,
    required this.email,
    required this.mobile,
    required this.profilePicture,
    required this.active,
    required this.emailConfirmed,
    required this.mobileConfirmed,
    required this.lastKnownIp,
    required this.lastLoginAt,
    required this.rating,
    required this.noOfRatings,
    required this.refferalCode,
    required this.currencyCode,
    required this.currencySymbol,
    required this.currencyPointer,
    required this.countryCode,
    required this.showRentalRide,
    required this.isDeliveryApp,
    required this.fcmToken,
    required this.showRideLaterFeature,
    required this.zoneId,
    required this.authorizationCode,
    required this.enableSupportTicketFeature,
    required this.enableModulesForApplications,
    required this.contactUsMobile1,
    required this.contactUsMobile2,
    required this.contactUsLink,
    required this.showWalletMoneyTransferFeatureOnMobileApp,
    required this.showBankInfoFeatureOnMobileApp,
    required this.showWalletFeatureOnMobileApp,
    required this.showOutstationRideFeature,
    required this.showTaxiOutstationRideFeature,
    required this.showDeliveryOutstationRideFeature,
    required this.notificationsCount,
    required this.showTaxiRentalRide,
    required this.showDeliveryRentalRide,
    required this.showCardPaymentFeature,
    required this.referralComissionString,
    required this.userCanMakeARideAfterXMiniutes,
    required this.maximumTimeForFindDriversForRegularRide,
    required this.maximumTimeForFindDriversForBittingRide,
    required this.enablePetPreferenceForUser,
    required this.enableLuggagePreferenceForUser,
    required this.biddingAmountIncreaseOrDecrease,
    required this.showRideWithoutDestination,
    required this.enableCountryRestrictOnMap,
    required this.enableMapAppearanceChangeOnMobileApp,
    required this.conversationId,
    required this.mapType,
    required this.hasOngoingRide,
    required this.completedRideCount,
    required this.sos,
    required this.bannerImage,
    required this.wallet,
  });

  factory UserDetailData.fromJson(Map<String, dynamic> json) => UserDetailData(
        id: json["id"],
        name: json["name"],
        gender: json["gender"],
        lastName: json["last_name"],
        username: json["username"],
        email: json["email"],
        mobile: json["mobile"],
        profilePicture: json["profile_picture"],
        active: json["active"],
        emailConfirmed: json["email_confirmed"],
        mobileConfirmed: json["mobile_confirmed"],
        lastKnownIp: json["last_known_ip"],
        lastLoginAt: json["last_login_at"],
        rating: json["rating"].toString(),
        noOfRatings: json["no_of_ratings"],
        refferalCode: json["refferal_code"],
        currencyCode: json["currency_code"],
        currencySymbol: json["currency_symbol"],
        currencyPointer: json["currency_pointer"],
        countryCode: json["country_code"],
        showRentalRide: json["show_rental_ride"],
        isDeliveryApp: json["is_delivery_app"],
        fcmToken: json["fcm_token"],
        showRideLaterFeature: json["show_ride_later_feature"],
        zoneId: json["zone_id"],
        authorizationCode: json["authorization_code"],
        enableSupportTicketFeature: json["enable_support_ticket_feature"],
        enableModulesForApplications: json["enable_modules_for_applications"],
        contactUsMobile1: json["contact_us_mobile1"],
        contactUsMobile2: json["contact_us_mobile2"],
        contactUsLink: json["contact_us_link"],
        showWalletMoneyTransferFeatureOnMobileApp:
            json["show_wallet_money_transfer_feature_on_mobile_app"],
        showBankInfoFeatureOnMobileApp:
            json["show_bank_info_feature_on_mobile_app"],
        showWalletFeatureOnMobileApp: json["show_wallet_feature_on_mobile_app"],
        showOutstationRideFeature: json["show_outstation_ride_feature"],
        showTaxiOutstationRideFeature:
            json["show_taxi_outstation_ride_feature"],
        showDeliveryOutstationRideFeature:
            json["show_delivery_outstation_ride_feature"],
        notificationsCount: json["notifications_count"],
        showTaxiRentalRide: json["show_taxi_rental_ride"],
        showDeliveryRentalRide: json["show_delivery_rental_ride"],
        showCardPaymentFeature: json["show_card_payment_feature"],
        referralComissionString: json["referral_comission_string"],
        userCanMakeARideAfterXMiniutes:
            json["user_can_make_a_ride_after_x_miniutes"],
        maximumTimeForFindDriversForRegularRide:
            json["maximum_time_for_find_drivers_for_regular_ride"],
        maximumTimeForFindDriversForBittingRide:
            json["maximum_time_for_find_drivers_for_bitting_ride"],
        enablePetPreferenceForUser: json["enable_pet_preference_for_user"],
        enableLuggagePreferenceForUser:
            json["enable_luggage_preference_for_user"],
        biddingAmountIncreaseOrDecrease:
            json["bidding_amount_increase_or_decrease"],
        showRideWithoutDestination: json["show_ride_without_destination"],
        enableCountryRestrictOnMap: json["enable_country_restrict_on_map"],
        enableMapAppearanceChangeOnMobileApp:
            json["enable_map_appearance_change_on_mobile_app"],
        conversationId: json["conversation_id"],
        mapType: json["map_type"],
        hasOngoingRide: json["has_ongoing_ride"],
        completedRideCount: json["completed_ride_count"],
        sos: RequestProofs.fromJson(json["sos"]),
        bannerImage: RequestProofs.fromJson(json["bannerImage"]),
        wallet: Wallet.fromJson(json["wallet"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "gender": gender,
        "last_name": lastName,
        "username": username,
        "email": email,
        "mobile": mobile,
        "profile_picture": profilePicture,
        "active": active,
        "email_confirmed": emailConfirmed,
        "mobile_confirmed": mobileConfirmed,
        "last_known_ip": lastKnownIp,
        "last_login_at": lastLoginAt,
        "rating": rating,
        "no_of_ratings": noOfRatings,
        "refferal_code": refferalCode,
        "currency_code": currencyCode,
        "currency_symbol": currencySymbol,
        "currency_pointer": currencyPointer,
        "country_code": countryCode,
        "show_rental_ride": showRentalRide,
        "is_delivery_app": isDeliveryApp,
        "fcm_token": fcmToken,
        "show_ride_later_feature": showRideLaterFeature,
        "zone_id": zoneId,
        "authorization_code": authorizationCode,
        "enable_support_ticket_feature": enableSupportTicketFeature,
        "enable_modules_for_applications": enableModulesForApplications,
        "contact_us_mobile1": contactUsMobile1,
        "contact_us_mobile2": contactUsMobile2,
        "contact_us_link": contactUsLink,
        "show_wallet_money_transfer_feature_on_mobile_app":
            showWalletMoneyTransferFeatureOnMobileApp,
        "show_bank_info_feature_on_mobile_app": showBankInfoFeatureOnMobileApp,
        "show_wallet_feature_on_mobile_app": showWalletFeatureOnMobileApp,
        "show_outstation_ride_feature": showOutstationRideFeature,
        "show_taxi_outstation_ride_feature": showTaxiOutstationRideFeature,
        "show_delivery_outstation_ride_feature":
            showDeliveryOutstationRideFeature,
        "notifications_count": notificationsCount,
        "show_taxi_rental_ride": showTaxiRentalRide,
        "show_delivery_rental_ride": showDeliveryRentalRide,
        "show_card_payment_feature": showCardPaymentFeature,
        "referral_comission_string": referralComissionString,
        "user_can_make_a_ride_after_x_miniutes": userCanMakeARideAfterXMiniutes,
        "maximum_time_for_find_drivers_for_regular_ride":
            maximumTimeForFindDriversForRegularRide,
        "maximum_time_for_find_drivers_for_bitting_ride":
            maximumTimeForFindDriversForBittingRide,
        "enable_pet_preference_for_user": enablePetPreferenceForUser,
        "enable_luggage_preference_for_user": enableLuggagePreferenceForUser,
        "bidding_amount_increase_or_decrease": biddingAmountIncreaseOrDecrease,
        "show_ride_without_destination": showRideWithoutDestination,
        "enable_country_restrict_on_map": enableCountryRestrictOnMap,
        "enable_map_appearance_change_on_mobile_app":
            enableMapAppearanceChangeOnMobileApp,
        "conversation_id": conversationId,
        "map_type": mapType,
        "has_ongoing_ride": hasOngoingRide,
        "completed_ride_count": completedRideCount,
        "sos": sos.toJson(),
        "bannerImage": bannerImage.toJson(),
        "wallet": wallet.toJson(),
      };
}

class DriverDetail {
  DriverData data;

  DriverDetail({
    required this.data,
  });

  factory DriverDetail.fromJson(Map<String, dynamic> json) => DriverDetail(
        data: DriverData.fromJson(json["data"]),
      );
  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class DriverData {
  int id;
  String name;
  String email;
  dynamic ownerId;
  String mobile;
  String profilePicture;
  bool active;
  dynamic fleetId;
  bool approve;
  bool available;
  bool uploadedDocument;
  dynamic declinedReason;
  String serviceLocationId;
  dynamic vehicleTypeId;
  dynamic vehicleTypeName;
  dynamic vehicleTypeIcon;
  dynamic carMake;
  dynamic carModel;
  String carMakeName;
  String carModelName;
  String carColor;
  dynamic driverLat;
  dynamic driverLng;
  String carNumber;
  String rating;
  int noOfRatings;
  String timezone;
  String refferalCode;
  dynamic companyKey;
  bool showInstantRide;
  String currencySymbol;
  String currencyCode;
  String totalEarnings;
  String currentDate;

  DriverData({
    required this.id,
    required this.name,
    required this.email,
    required this.ownerId,
    required this.mobile,
    required this.profilePicture,
    required this.active,
    required this.fleetId,
    required this.approve,
    required this.available,
    required this.uploadedDocument,
    required this.declinedReason,
    required this.serviceLocationId,
    required this.vehicleTypeId,
    required this.vehicleTypeName,
    required this.vehicleTypeIcon,
    required this.carMake,
    required this.carModel,
    required this.carMakeName,
    required this.carModelName,
    required this.carColor,
    required this.driverLat,
    required this.driverLng,
    required this.carNumber,
    required this.rating,
    required this.noOfRatings,
    required this.timezone,
    required this.refferalCode,
    required this.companyKey,
    required this.showInstantRide,
    required this.currencySymbol,
    required this.currencyCode,
    required this.totalEarnings,
    required this.currentDate,
  });

  factory DriverData.fromJson(Map<String, dynamic> json) => DriverData(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        email: json["email"] ?? '',
        ownerId: json["owner_id"] ?? 0,
        mobile: json["mobile"] ?? '',
        profilePicture: json["profile_picture"] ?? '',
        active: json["active"] ?? false,
        fleetId: json["fleet_id"] ?? 0,
        approve: json["approve"] ?? false,
        available: json["available"] ?? false,
        uploadedDocument: json["uploaded_document"] ?? false,
        declinedReason: json["declined_reason"] ?? '',
        serviceLocationId: json["service_location_id"] ?? '',
        vehicleTypeId: json["vehicle_type_id"] ?? '',
        vehicleTypeName: json["vehicle_type_name"] ?? '',
        vehicleTypeIcon: json["vehicle_type_icon"] ?? '',
        carMake: json["car_make"] ?? '',
        carModel: json["car_model"] ?? '',
        carMakeName: json["car_make_name"] ?? '',
        carModelName: json["car_model_name"] ?? '',
        carColor: json["car_color"] ?? '',
        driverLat: json["driver_lat"],
        driverLng: json["driver_lng"],
        carNumber: json["car_number"] ?? '',
        rating: json["rating"].toString(),
        noOfRatings: json["no_of_ratings"] ?? 0,
        timezone: json["timezone"] ?? '',
        refferalCode: json["refferal_code"] ?? '',
        companyKey: json["company_key"] ?? '',
        showInstantRide: json["show_instant_ride"] ?? false,
        currencySymbol: json["currency_symbol"] ?? '₹',
        currencyCode: json["currency_code"] ?? 'INR',
        totalEarnings: json["total_earnings"].toString(),
        currentDate: json["current_date"] ?? '',
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "owner_id": ownerId,
        "mobile": mobile,
        "profile_picture": profilePicture,
        "active": active,
        "fleet_id": fleetId,
        "approve": approve,
        "available": available,
        "uploaded_document": uploadedDocument,
        "declined_reason": declinedReason,
        "service_location_id": serviceLocationId,
        "vehicle_type_id": vehicleTypeId,
        "vehicle_type_name": vehicleTypeName,
        "vehicle_type_icon": vehicleTypeIcon,
        "car_make": carMake,
        "car_model": carModel,
        "car_make_name": carMakeName,
        "car_model_name": carModelName,
        "car_color": carColor,
        "driver_lat": driverLat,
        "driver_lng": driverLng,
        "car_number": carNumber,
        "rating": rating,
        "no_of_ratings": noOfRatings,
        "timezone": timezone,
        "refferal_code": refferalCode,
        "company_key": companyKey,
        "show_instant_ride": showInstantRide,
        "currency_symbol": currencySymbol,
        "currency_code": currencyCode,
        "total_earnings": totalEarnings,
        "current_date": currentDate,
      };
}

class Wallet {
  WalletData data;

  Wallet({
    required this.data,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        data: WalletData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class WalletData {
  String id;
  int userId;
  int amountAdded;
  int amountBalance;
  int amountSpent;
  String currencySymbol;
  String currencyCode;
  String createdAt;
  String updatedAt;

  WalletData({
    required this.id,
    required this.userId,
    required this.amountAdded,
    required this.amountBalance,
    required this.amountSpent,
    required this.currencySymbol,
    required this.currencyCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) => WalletData(
        id: json["id"],
        userId: json["user_id"],
        amountAdded: json["amount_added"],
        amountBalance: json["amount_balance"],
        amountSpent: json["amount_spent"],
        currencySymbol: json["currency_symbol"],
        currencyCode: json["currency_code"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "amount_added": amountAdded,
        "amount_balance": amountBalance,
        "amount_spent": amountSpent,
        "currency_symbol": currencySymbol,
        "currency_code": currencyCode,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
