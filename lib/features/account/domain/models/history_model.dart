import 'dart:convert';

HistoryResponseModel historyResponseModelFromJson(String str) =>
    HistoryResponseModel.fromJson(json.decode(str));

class HistoryResponseModel {
  bool success;
  String message;
  List<HistoryData> data;
  HistoryPagination meta;

  HistoryResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory HistoryResponseModel.fromJson(Map<String, dynamic> json) =>
      HistoryResponseModel(
        success: json["success"],
        message: json["message"],
        data: List<HistoryData>.from(
            json["data"].map((x) => HistoryData.fromJson(x))),
        meta: HistoryPagination.fromJson(json["meta"]),
      );
}

class HistoryData {
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
  double totalTime;
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
  int isOutStation;
  dynamic returnTime;
  dynamic isRoundTrip;
  String rentalPackageName;
  bool showDropLocation;
  String requestEtaAmount;
  bool showRequestEtaAmount;
  double offerredRideFare;
  double acceptedRideFare;
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
  bool supportTicketExist;
  String supportTicketId;
  int supportTicketStatus;
  int maximumTimeForFindDriversForRegularRide;
  int freeWaitingTimeInMinsBeforeTripStart;
  int freeWaitingTimeInMinsAfterTripStart;
  double waitingCharge;
  String paymentTypeString;
  dynamic cvTripStartTime;
  dynamic cvCompletedAt;
  String cvCreatedAt;
  String transportType;
  RequestStops? requestStops;
  dynamic driverDetail;
  dynamic requestBill;
  RequestProofs requestProofs;
  List<PaymentGatewayData> paymentGateways;
  String enableDriverTipsFeature;
  String minimumTipAmount;
  String parcelType;

  HistoryData({
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
    required this.supportTicketExist,
    required this.supportTicketId,
    required this.supportTicketStatus,
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
    required this.driverDetail,
    required this.requestBill,
    required this.requestProofs,
    required this.paymentGateways,
    required this.enableDriverTipsFeature,
    required this.minimumTipAmount,
    required this.parcelType,
  });

  factory HistoryData.fromJson(Map<String, dynamic> json) => HistoryData(
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
      totalTime: json["total_time"]?.toDouble() ?? 0,
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
      pickLat: json["pick_lat"].toString(),
      pickLng: json["pick_lng"].toString(),
      dropLat: json["drop_lat"].toString(),
      dropLng: json["drop_lng"].toString(),
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
      userCancellationFee: json["user_cancellation_fee"]?.toDouble() ?? 0.0,
      isRental: json["is_rental"] ?? false,
      rentalPackageId: json["rental_package_id"] ?? '',
      isOutStation: json["is_out_station"] ?? 0,
      returnTime: json["return_time"] ?? '',
      isRoundTrip: json["is_round_trip"] ?? '',
      rentalPackageName: json["rental_package_name"] ?? '',
      showDropLocation: json["show_drop_location"] ?? false,
      requestEtaAmount: json["request_eta_amount"].toString(),
      showRequestEtaAmount: json["show_request_eta_amount"] ?? false,
      offerredRideFare: json["offerred_ride_fare"]?.toDouble() ?? 0.0,
      acceptedRideFare: json["accepted_ride_fare"]?.toDouble() ?? 0.0,
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
      showOtpFeature: json["show_otp_feature"],
      completedRide: json["completed_ride"],
      laterRide: json["later_ride"],
      cancelledRide: json["cancelled_ride"],
      ongoingRide: json["ongoing_ride"],
      tripStartTimeWithDate: json["trip_start_time_with_date"] ?? '',
      arrivedAtWithDate: json["arrived_at_with_date"] ?? '',
      acceptedAtWithDate: json["accepted_at_with_date"] ?? '',
      completedAtWithDate: json["completed_at_with_date"] ?? '',
      cancelledAtWithDate: json["cancelled_at_with_date"] ?? '',
      creatededAtWithDate: json["createded_at_with_date"] ?? '',
      biddingLowPercentage: json["bidding_low_percentage"] ?? '',
      biddingHighPercentage: json["bidding_high_percentage"] ?? '',
      supportTicketExist: json['support_ticket_exists'],
      supportTicketId: json['ticket_id'] ?? '',
      supportTicketStatus: json['ticket_status'] ?? 0,
      maximumTimeForFindDriversForRegularRide:
          json["maximum_time_for_find_drivers_for_regular_ride"] ?? 0,
      freeWaitingTimeInMinsBeforeTripStart:
          json["free_waiting_time_in_mins_before_trip_start"] ?? 0,
      freeWaitingTimeInMinsAfterTripStart:
          json["free_waiting_time_in_mins_after_trip_start"] ?? 0,
      waitingCharge: json["waiting_charge"]?.toDouble() ?? 0,
      paymentTypeString: json["payment_type_string"] ?? '',
      cvTripStartTime: json["cv_trip_start_time"] ?? '',
      cvCompletedAt: json["cv_completed_at"] ?? '',
      cvCreatedAt: json["cv_created_at"] ?? '',
      transportType: json["transport_type"] ?? '',
      requestStops: json["requestStops"] != null
          ? RequestStops.fromJson(json["requestStops"])
          : null,
      driverDetail: json["driverDetail"] != null
          ? DriverDetails.fromJson(json["driverDetail"])
          : null,
      requestBill: json["requestBill"] != null
          ? RequestBill.fromJson(json["requestBill"])
          : null,
      requestProofs: RequestProofs.fromJson(json["requestProofs"]),
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
        "support_ticket_exists": supportTicketExist,
        "ticket_id": supportTicketId,
        "ticket_status": supportTicketStatus,
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
        "requestProofs": requestProofs.toJson(),
        "payment_gateways":
            List<dynamic>.from(paymentGateways.map((x) => x.toJson())),
        "enable_driver_tips_feature": enableDriverTipsFeature,
        "minimum_tip_amount": minimumTipAmount,
        "parcelType": parcelType
      };
}

class DriverDetails {
  DriverData data;

  DriverDetails({
    required this.data,
  });

  factory DriverDetails.fromJson(Map<String, dynamic> json) => DriverDetails(
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

class RequestBill {
  RequestbillData data;

  RequestBill({
    required this.data,
  });

  factory RequestBill.fromJson(Map<String, dynamic> json) => RequestBill(
        data: RequestbillData.fromJson(json["data"]),
      );
  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class RequestbillData {
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
  int calculatedWaitingTime;
  double waitingChargePerMin;
  double adminCommisionFromDriver;
  double additionalChargesAmount;
  String additionalChargesReason;
  String driverTips;
  String calculatedDistance;
  String totalTime;
  String unit;
  double preferencePriceTotal;

  RequestbillData(
      {required this.id,
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
      required this.calculatedWaitingTime,
      required this.waitingChargePerMin,
      required this.adminCommisionFromDriver,
      required this.additionalChargesAmount,
      required this.additionalChargesReason,
      required this.driverTips,
      required this.calculatedDistance,
      required this.totalTime,
      required this.unit,
      required this.preferencePriceTotal});

  factory RequestbillData.fromJson(Map<String, dynamic> json) =>
      RequestbillData(
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
        totalAmount: json["total_amount"].toString(),
        requestedCurrencyCode: json["requested_currency_code"],
        requestedCurrencySymbol: json["requested_currency_symbol"],
        adminCommisionWithTax: json["admin_commision_with_tax"]?.toDouble(),
        calculatedWaitingTime: json["calculated_waiting_time"],
        waitingChargePerMin: json["waiting_charge_per_min"]?.toDouble(),
        adminCommisionFromDriver:
            json["admin_commision_from_driver"]?.toDouble(),
        additionalChargesAmount: json["additional_charges_amount"]?.toDouble(),
        additionalChargesReason: json["additional_charges_reason"] ?? '',
        driverTips: json["driver_tips"]?.toString() ?? '0',
        calculatedDistance: json["calculated_distance"].toString(),
        totalTime: json["total_time"].toString(),
        unit: json["unit"] ?? '',
        preferencePriceTotal: json['preference_price_total']?.toDouble() ?? 0,
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
        "requested_currency_code": requestedCurrencyCode,
        "requested_currency_symbol": requestedCurrencySymbol,
        "admin_commision_with_tax": adminCommisionWithTax,
        "calculated_waiting_time": calculatedWaitingTime,
        "waiting_charge_per_min": waitingChargePerMin,
        "admin_commision_from_driver": adminCommisionFromDriver,
        "additional_charges_amount": additionalChargesAmount,
        "additional_charges_reason": additionalChargesReason,
        "driver_tips": driverTips,
        "calculated_distance": calculatedDistance,
        "total_time": totalTime,
        "unit": unit,
        "preference_price_total": preferencePriceTotal,
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

class HistoryPagination {
  dynamic pagination;

  HistoryPagination({
    required this.pagination,
  });

  factory HistoryPagination.fromJson(Map<String, dynamic> json) =>
      HistoryPagination(
        pagination: (json["pagination"] != null)
            ? Pagination.fromJson(json["pagination"])
            : null,
      );
}

class Pagination {
  int total;
  int count;
  int perPage;
  int currentPage;
  int totalPages;
  dynamic links;

  Pagination({
    required this.total,
    required this.count,
    required this.perPage,
    required this.currentPage,
    required this.totalPages,
    required this.links,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json["total"] ?? 0,
        count: json["count"] ?? 0,
        perPage: json["per_page"] ?? 0,
        currentPage: json["current_page"] ?? 0,
        totalPages: json["total_pages"] ?? 0,
        links: (json["links"] != null) ? Links.fromJson(json["links"]) : null,
      );
}

class Links {
  String next;

  Links({
    required this.next,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        next: json["next"] ?? '',
      );
  Map<String, dynamic> toJson() => {"next": next};
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
  int id;
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
        id: json["id"] ?? 0,
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
