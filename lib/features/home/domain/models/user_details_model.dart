import 'dart:convert';

UserDetailResponseModel userDetailResponseModelFromJson(String str) =>
    UserDetailResponseModel.fromJson(json.decode(str));
UserDetail? userData;

class UserDetailResponseModel {
  bool success;
  UserDetail data;

  UserDetailResponseModel({
    required this.success,
    required this.data,
  });

  factory UserDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      UserDetailResponseModel(
        success: json["success"],
        data: UserDetail.fromJson(json["data"]),
      );
}

class UserDetail {
  int id;
  String enableUserDocument;
  String zoneTypeId;
  String name;
  String gender;
  String lastName;
  String username;
  String email;
  String mobile;
  String profilePicture;
  int active;
  int emailConfirmed;
  int mobileConfirmed;
  String lastKnownIp;
  String lastLoginAt;
  String rating;
  int noOfRatings;
  String refferalCode;
  String currencyCode;
  String currencySymbol;
  String currencyPointer;
  String countryCode;
  bool showRentalRide;
  bool isDeliveryApp;
  String fcmToken;
  bool showRideLaterFeature;
  String authorizationCode;
  String enableSupportTicketFeature;
  String enableModulesForApplications;
  String contactUsMobile1;
  String contactUsMobile2;
  String contactUsLink;
  String showWalletMoneyTransferFeatureOnMobileApp;
  String showBankInfoFeatureOnMobileApp;
  String showWalletFeatureOnMobileApp;
  int notificationsCount;
  int completedRideCount;
  String referralComissionString;
  String userCanMakeARideAfterXMiniutes;
  String maximumTimeForFindDriversForRegularRide;
  String maximumTimeForFindDriversForBittingRide;
  dynamic enableDriverPreferenceForUser;
  String enablePetPreferenceForUser;
  String enableLuggagePreferenceForUser;
  String biddingAmountIncreaseOrDecrease;
  String showRideWithoutDestination;
  String enableCountryRestrictOnMap;
  String chatId;
  String mapType;
  bool hasOngoingRide;
  String showOutstationRideFeature;
  String showTaxiOutstationRideFeature;
  String showDeliveryOutstationRideFeature;
  SOS sos;
  dynamic bannerImage;
  Wallet wallet;
  dynamic onTripRequest;
  dynamic metaRequest;
  FavoriteLocation favouriteLocations;
  dynamic laterMetaRequest;
  bool showDeliveryRentalRide;
  bool showTaxiRentalRide;
  bool showCardPaymentFeature;
  String distanceUnit;
  String enableMapAppearanceChange;
  String androidApp;
  String iosApp;
  String enableOutstationRoundTripFeature;
  String showOnlyTotalAmount;
  String contactBookingNumber;
  String enableMultipleRideFeature;
  bool hasUpcomingRide;
  String showWalletAddMoneyFeatureOnMobileApp;
  String enableMapShowHomeScreen;
  String mapShowHomePageDesign;
  dynamic appModuleBannerImage;
  OsmMapSettings osmMapSettings;
  int approve;

  UserDetail(
      {required this.id,
      required this.zoneTypeId,
      required this.name,
      required this.approve,
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
      required this.authorizationCode,
      required this.enableSupportTicketFeature,
      required this.enableModulesForApplications,
      required this.contactUsMobile1,
      required this.contactUsMobile2,
      required this.contactUsLink,
      required this.showWalletMoneyTransferFeatureOnMobileApp,
      required this.showBankInfoFeatureOnMobileApp,
      required this.showWalletFeatureOnMobileApp,
      required this.notificationsCount,
      required this.completedRideCount,
      required this.referralComissionString,
      required this.userCanMakeARideAfterXMiniutes,
      required this.maximumTimeForFindDriversForRegularRide,
      required this.maximumTimeForFindDriversForBittingRide,
      required this.enableDriverPreferenceForUser,
      required this.enablePetPreferenceForUser,
      required this.enableLuggagePreferenceForUser,
      required this.biddingAmountIncreaseOrDecrease,
      required this.showRideWithoutDestination,
      required this.enableCountryRestrictOnMap,
      required this.chatId,
      required this.mapType,
      required this.hasOngoingRide,
      required this.showOutstationRideFeature,
      required this.showTaxiOutstationRideFeature,
      required this.showDeliveryOutstationRideFeature,
      required this.sos,
      required this.bannerImage,
      required this.wallet,
      required this.onTripRequest,
      required this.metaRequest,
      required this.favouriteLocations,
      required this.laterMetaRequest,
      required this.showDeliveryRentalRide,
      required this.showTaxiRentalRide,
      required this.showCardPaymentFeature,
      required this.distanceUnit,
      required this.enableMapAppearanceChange,
      required this.androidApp,
      required this.iosApp,
      required this.enableOutstationRoundTripFeature,
      required this.showOnlyTotalAmount,
      required this.contactBookingNumber,
      required this.enableMultipleRideFeature,
      required this.hasUpcomingRide,
      required this.showWalletAddMoneyFeatureOnMobileApp,
      required this.enableMapShowHomeScreen,
      required this.mapShowHomePageDesign,
      required this.appModuleBannerImage,
      required this.enableUserDocument,
      required this.osmMapSettings});

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        id: json["id"] ?? 0,
        approve: json["approve"] ?? 0,
        zoneTypeId: json["zone_type_id"] ?? '',
        name: json["name"] ?? '',
        gender: json["gender"] ?? '',
        lastName: json["last_name"] ?? '',
        username: json["username"] ?? '',
        email: json["email"] ?? '',
        mobile: json["mobile"] ?? '',
        profilePicture: json["profile_picture"] ?? '',
        active: json["active"] ?? 0,
        emailConfirmed: json["email_confirmed"] ?? 0,
        mobileConfirmed: json["mobile_confirmed"] ?? 0,
        lastKnownIp: json["last_known_ip"] ?? '',
        lastLoginAt: json["last_login_at"] ?? '',
        rating: json["rating"].toString(),
        noOfRatings: json["no_of_ratings"] ?? 0,
        refferalCode: json["refferal_code"] ?? '',
        currencyCode: json["currency_code"] ?? '',
        currencySymbol: json["currency_symbol"] ?? '',
        currencyPointer: json["currency_pointer"] ?? 'ltr',
        countryCode: json["country_code"] ?? 'IN',
        showRentalRide: json["show_rental_ride"] ?? false,
        isDeliveryApp: json["is_delivery_app"] ?? false,
        fcmToken: json["fcm_token"] ?? '',
        showRideLaterFeature: json["show_ride_later_feature"] ?? false,
        authorizationCode: json["authorization_code"] ?? '',
        enableSupportTicketFeature: json['enable_support_ticket_feature'] ?? '',
        enableModulesForApplications:
            json["enable_modules_for_applications"] ?? '',
        contactUsMobile1: json["contact_us_mobile1"] ?? '',
        contactUsMobile2: json["contact_us_mobile2"] ?? '',
        contactUsLink: json["contact_us_link"] ?? '',
        showWalletMoneyTransferFeatureOnMobileApp:
            json["show_wallet_money_transfer_feature_on_mobile_app"].toString(),
        showBankInfoFeatureOnMobileApp:
            json["show_bank_info_feature_on_mobile_app"].toString(),
        showWalletFeatureOnMobileApp:
            json["show_wallet_feature_on_mobile_app"].toString(),
        notificationsCount: json["notifications_count"] ?? 0,
        completedRideCount: json["completed_ride_count"] ?? 0,
        referralComissionString: json["referral_comission_string"] ?? '',
        userCanMakeARideAfterXMiniutes:
            json["user_can_make_a_ride_after_x_miniutes"].toString(),
        maximumTimeForFindDriversForRegularRide:
            json["maximum_time_for_find_drivers_for_regular_ride"].toString(),
        maximumTimeForFindDriversForBittingRide:
            json["maximum_time_for_find_drivers_for_bitting_ride"].toString(),
        enableDriverPreferenceForUser:
            json["enable_driver_preference_for_user"] ?? '',
        enablePetPreferenceForUser:
            json["enable_pet_preference_for_user"].toString(),
        enableLuggagePreferenceForUser:
            json["enable_luggage_preference_for_user"].toString(),
        biddingAmountIncreaseOrDecrease:
            json["bidding_amount_increase_or_decrease"] ?? '',
        showRideWithoutDestination:
            json["show_ride_without_destination"].toString(),
        enableCountryRestrictOnMap:
            json["enable_country_restrict_on_map"].toString(),
        enableUserDocument: json["enable_user_document_upload"].toString(),
        chatId: json["conversation_id"] ?? '',
        mapType: json["map_type"] ?? '',
        hasOngoingRide: json["has_ongoing_ride"] ?? false,
        showOutstationRideFeature: json["show_outstation_ride_feature"] ?? '',
        showTaxiOutstationRideFeature:
            json["show_taxi_outstation_ride_feature"] ?? '0',
        showDeliveryOutstationRideFeature:
            json["show_delivery_outstation_ride_feature"] ?? '0',
        sos: SOS.fromJson(json["sos"]),
        bannerImage: json["bannerImage"] != null
            ? BannerImage.fromJson(json["bannerImage"])
            : null,
        wallet: json["wallet"] != null
            ? Wallet.fromJson(json["wallet"])
            : Wallet(
                data: WalletData(
                    id: '',
                    userId: 0,
                    amountAdded: 0.0,
                    amountBalance: 0.0,
                    amountSpent: 0.0,
                    currencySymbol: '',
                    currencyCode: '',
                    createdAt: '',
                    updatedAt: '')),
        onTripRequest: json["onTripRequest"] != null
            ? OnTripRequest.fromJson(json["onTripRequest"])
            : '',
        metaRequest: json["metaRequest"] != null
            ? OnTripRequest.fromJson(json["metaRequest"])
            : '',
        favouriteLocations:
            FavoriteLocation.fromJson(json["favouriteLocations"]),
        laterMetaRequest: json["laterMetaRequest"] ?? '',
        showDeliveryRentalRide: json["show_delivery_rental_ride"] ?? false,
        showTaxiRentalRide: json["show_taxi_rental_ride"] ?? false,
        showCardPaymentFeature: json["show_card_payment_feature"] ?? false,
        distanceUnit: json["distance_unit"] ?? '',
        enableMapAppearanceChange:
            json['enable_map_appearance_change_on_mobile_app'].toString(),
        androidApp: json["android_app"] ?? '',
        iosApp: json["ios_app"] ?? '',
        enableOutstationRoundTripFeature:
            json["enable_outstation_round_trip_feature"] ?? "0",
        showOnlyTotalAmount: json["show_only_total_amount"] ?? '0',
        contactBookingNumber: json["contact_booking_number"] ?? '',
        enableMultipleRideFeature: json["enable_multiple_ride_feature"] ?? '0',
        hasUpcomingRide: json["has_upcoming_ride"] ?? false,
        showWalletAddMoneyFeatureOnMobileApp:
            json["show_wallet_add_money_feature_on_mobile_app"] ?? '0',
        enableMapShowHomeScreen: json["enable_map_show_home_screen"] ?? '0',
        mapShowHomePageDesign: json["map_show"] ?? '',
        appModuleBannerImage: json["appModuleBannerImage"] != null
            ? AppModuleBannerImage.fromJson(json["appModuleBannerImage"])
            : null,
        osmMapSettings: OsmMapSettings.fromJson(json["osm_map_settings"]),
      );
}

class SOS {
  List<SOSDatum> data;

  SOS({
    required this.data,
  });

  factory SOS.fromJson(Map<String, dynamic> json) => SOS(
        data: json["data"] != []
            ? List<SOSDatum>.from(json["data"].map((x) => SOSDatum.fromJson(x)))
            : [],
      );
}

class BannerImage {
  List<BannerImageData> data;

  BannerImage({
    required this.data,
  });

  factory BannerImage.fromJson(Map<String, dynamic> json) => BannerImage(
        data: List<BannerImageData>.from(
            json["data"].map((x) => BannerImageData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BannerImageData {
  String image;
  String imageUrl;

  BannerImageData({required this.image, required this.imageUrl});

  factory BannerImageData.fromJson(Map<String, dynamic> json) =>
      BannerImageData(
        image: json["image"] ?? '',
        imageUrl: json["image_url"] ?? '',
      );

  Map<String, dynamic> toJson() => {"image": image, "image_url": imageUrl};
}

class AppModuleBannerImage {
  List<AppModuleBannerImageData> data;

  AppModuleBannerImage({
    required this.data,
  });

  factory AppModuleBannerImage.fromJson(Map<String, dynamic> json) =>
      AppModuleBannerImage(
        data: List<AppModuleBannerImageData>.from(
            json["data"].map((x) => AppModuleBannerImageData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class AppModuleBannerImageData {
  String previewImage;
  dynamic imageUrl;
  int active;
  AppModuleBannerImageModule? module;

  AppModuleBannerImageData({
    required this.previewImage,
    required this.imageUrl,
    required this.active,
    this.module,
  });

  factory AppModuleBannerImageData.fromJson(Map<String, dynamic> json) =>
      AppModuleBannerImageData(
        previewImage: json["preview_image"],
        imageUrl: json["image_url"],
        active: json["active"],
        module: json["module"] == null
            ? null
            : AppModuleBannerImageModule.fromJson(json["module"]),
      );

  Map<String, dynamic> toJson() => {
        "preview_image": previewImage,
        "image_url": imageUrl,
        "active": active,
        "module": module?.toJson(),
      };
}

class AppModuleBannerImageModule {
  String name;
  String transportType;
  String serviceType;

  AppModuleBannerImageModule({
    required this.name,
    required this.transportType,
    required this.serviceType,
  });

  factory AppModuleBannerImageModule.fromJson(Map<String, dynamic> json) =>
      AppModuleBannerImageModule(
        name: json["name"],
        transportType: json["transport_type"],
        serviceType: json["service_type"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "transport_type": transportType,
        "service_type": serviceType,
      };
}

class OsmMapSettings {
  bool enableMapbox;
  String mapboxPublicKey;
  bool enableThunderforest;
  String thunderforestApiKey;
  bool enableStadia;
  String stadiaApiKey;

  OsmMapSettings({
    required this.enableMapbox,
    required this.mapboxPublicKey,
    required this.enableThunderforest,
    required this.thunderforestApiKey,
    required this.enableStadia,
    required this.stadiaApiKey,
  });

  factory OsmMapSettings.fromJson(Map<String, dynamic> json) => OsmMapSettings(
        enableMapbox: json["enable_mapbox"],
        mapboxPublicKey: json["mapbox_public_key"],
        enableThunderforest: json["enable_thunderforest"],
        thunderforestApiKey: json["thunderforest_api_key"],
        enableStadia: json["enable_stadia"],
        stadiaApiKey: json["stadia_api_key"],
      );

  Map<String, dynamic> toJson() => {
        "enable_mapbox": enableMapbox,
        "mapbox_public_key": mapboxPublicKey,
        "enable_thunderforest": enableThunderforest,
        "thunderforest_api_key": thunderforestApiKey,
        "enable_stadia": enableStadia,
        "stadia_api_key": stadiaApiKey,
      };
}

class SOSDatum {
  String? id;
  String? name;
  String? number;
  String? userType;
  bool? status;

  SOSDatum({
    this.id,
    this.name,
    this.number,
    this.userType,
    this.status,
  });

  factory SOSDatum.fromJson(Map<String, dynamic> json) => SOSDatum(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        number: json["number"] ?? '',
        userType: json["user_type"] ?? '',
        status: json["status"] ?? '',
      );
}

class FavoriteLocation {
  List<FavoriteLocationData> data;

  FavoriteLocation({
    required this.data,
  });

  factory FavoriteLocation.fromJson(Map<String, dynamic> json) =>
      FavoriteLocation(
        data: json["data"] != []
            ? List<FavoriteLocationData>.from(
                json["data"].map((x) => FavoriteLocationData.fromJson(x)))
            : [],
      );
}

class FavoriteLocationData {
  String id;
  String pickLat;
  String pickLng;
  String dropLat;
  String dropLng;
  String pickAddress;
  String dropAddress;
  String addressName;
  String landmark;

  FavoriteLocationData({
    required this.id,
    required this.pickLat,
    required this.pickLng,
    required this.dropLat,
    required this.dropLng,
    required this.pickAddress,
    required this.dropAddress,
    required this.addressName,
    required this.landmark,
  });

  factory FavoriteLocationData.fromJson(Map<String, dynamic> json) =>
      FavoriteLocationData(
        id: json["id"].toString(),
        pickLat: json["pick_lat"].toString(),
        pickLng: json["pick_lng"].toString(),
        dropLat: json["drop_lat"] ?? '',
        dropLng: json["drop_lng"] ?? '',
        pickAddress: json["pick_address"] ?? '',
        dropAddress: json["drop_address"] ?? '',
        addressName: json["address_name"] ?? '',
        landmark: json["landmark"] ?? '',
      );
}

class OnTripRequest {
  OnTripRequestData data;

  OnTripRequest({
    required this.data,
  });

  factory OnTripRequest.fromJson(Map<String, dynamic> json) => OnTripRequest(
        data: OnTripRequestData.fromJson(json["data"]),
      );
}

class OnTripRequestData {
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
  dynamic requestPreferences;
  String showOnlyTotalAmount;
  String contactBookingNumber;
  String enableMultipleRideFeature;
  bool bookForOthers;
  String contactNumberOthers;

  OnTripRequestData(
      {required this.id,
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
      required this.requestPreferences,
      required this.showOnlyTotalAmount,
      required this.contactBookingNumber,
      required this.enableMultipleRideFeature,
      required this.bookForOthers,
      required this.contactNumberOthers});

  factory OnTripRequestData.fromJson(Map<String, dynamic> json) =>
      OnTripRequestData(
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
        pickLat: (json["pick_lat"] != null) ? json["pick_lat"].toString() : '0',
        pickLng: (json["pick_lng"] != null) ? json["pick_lng"].toString() : '0',
        dropLat: (json["drop_lat"] != null) ? json["drop_lat"].toString() : '0',
        dropLng: (json["drop_lng"] != null) ? json["drop_lng"].toString() : '0',
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
        parcelType: json['parcel_type'] ?? '',
        requestPreferences: (json["requestPreferences"] != null)
            ? RequestPreferences.fromJson(json["requestPreferences"])
            : null,
        showOnlyTotalAmount: json["show_only_total_amount"] ?? '0',
        contactBookingNumber: json["contact_booking_number"] ?? '',
        enableMultipleRideFeature: json["enable_multiple_ride_feature"] ?? '0',
        bookForOthers: json["book_for_other"] ?? false,
        contactNumberOthers: json["contact_no_other"] ?? '',
      );
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
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        pocName: json["poc_name"].toString(),
        pocMobile: json["poc_mobile"].toString(),
        pocInstruction: json["poc_instruction"].toString(),
        type: json["type"].toString(),
        isPickup: json["is_pickup"].toString(),
      );
}

class RequestPreferences {
  List<RequestPreferencesData> data;

  RequestPreferences({
    required this.data,
  });

  factory RequestPreferences.fromJson(Map<String, dynamic> json) =>
      RequestPreferences(
        data: List<RequestPreferencesData>.from(
            json["data"].map((x) => RequestPreferencesData.fromJson(x))),
      );
}

class RequestPreferencesData {
  int id;
  int preferencePriceId;
  int preferenceId;
  String name;
  String icon;
  int price;

  RequestPreferencesData({
    required this.id,
    required this.preferencePriceId,
    required this.preferenceId,
    required this.name,
    required this.icon,
    required this.price,
  });

  factory RequestPreferencesData.fromJson(Map<String, dynamic> json) =>
      RequestPreferencesData(
        id: json["id"],
        preferencePriceId: json["preference_price_id"],
        preferenceId: json["preference_id"],
        name: json["name"],
        icon: json["icon"],
        price: json["price"],
      );
}

class RequestUserDetail {
  RequestUserDetailData data;

  RequestUserDetail({
    required this.data,
  });

  factory RequestUserDetail.fromJson(Map<String, dynamic> json) =>
      RequestUserDetail(
        data: RequestUserDetailData.fromJson(json["data"]),
      );
}

class RequestUserDetailData {
  int id;
  String name;
  String gender;
  String lastName;
  String username;
  String email;
  String mobile;
  String profilePicture;
  int active;
  int emailConfirmed;
  int mobileConfirmed;
  String lastKnownIp;
  String lastLoginAt;
  double rating;
  int noOfRatings;
  String refferalCode;
  String currencyCode;
  String currencySymbol;
  String countryCode;
  bool showRentalRide;
  bool showRideLaterFeature;
  dynamic authorizationCode;
  String enableModulesForApplications;
  String contactUsMobile1;
  String contactUsMobile2;
  String contactUsLink;
  String showWalletMoneyTransferFeatureOnMobileApp;
  String showBankInfoFeatureOnMobileApp;
  String showWalletFeatureOnMobileApp;
  int notificationsCount;
  String referralComissionString;
  String userCanMakeARideAfterXMiniutes;
  int maximumTimeForFindDriversForRegularRide;
  String maximumTimeForFindDriversForBittingRide;
  dynamic enableDriverPreferenceForUser;
  String enablePetPreferenceForUser;
  String enableLuggagePreferenceForUser;
  String biddingAmountIncreaseOrDecrease;
  String showRideWithoutDestination;
  String enableCountryRestrictOnMap;
  String chatId;
  String mapType;
  bool hasOngoingRide;
  String showOutstationRideFeature;
  String showTaxiOutstationRideFeature;
  String showDeliveryOutstationRideFeature;
  SOS sos;
  dynamic bannerImage;
  Wallet wallet;
  // bool hasUpcomingRide;

  RequestUserDetailData({
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
    required this.countryCode,
    required this.showRentalRide,
    required this.showRideLaterFeature,
    required this.authorizationCode,
    required this.enableModulesForApplications,
    required this.contactUsMobile1,
    required this.contactUsMobile2,
    required this.contactUsLink,
    required this.showWalletMoneyTransferFeatureOnMobileApp,
    required this.showBankInfoFeatureOnMobileApp,
    required this.showWalletFeatureOnMobileApp,
    required this.notificationsCount,
    required this.referralComissionString,
    required this.userCanMakeARideAfterXMiniutes,
    required this.maximumTimeForFindDriversForRegularRide,
    required this.maximumTimeForFindDriversForBittingRide,
    required this.enableDriverPreferenceForUser,
    required this.enablePetPreferenceForUser,
    required this.enableLuggagePreferenceForUser,
    required this.biddingAmountIncreaseOrDecrease,
    required this.showRideWithoutDestination,
    required this.enableCountryRestrictOnMap,
    required this.chatId,
    required this.mapType,
    required this.hasOngoingRide,
    required this.showOutstationRideFeature,
    required this.showTaxiOutstationRideFeature,
    required this.showDeliveryOutstationRideFeature,
    required this.sos,
    required this.bannerImage,
    required this.wallet,
    // required this.hasUpcomingRide,
  });

  factory RequestUserDetailData.fromJson(Map<String, dynamic> json) =>
      RequestUserDetailData(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        gender: json["gender"] ?? '',
        lastName: json["last_name"] ?? '',
        username: json["username"] ?? '',
        email: json["email"] ?? '',
        mobile: json["mobile"] ?? '',
        profilePicture: json["profile_picture"] ?? '',
        active: json["active"] ?? 0,
        emailConfirmed: json["email_confirmed"] ?? 0,
        mobileConfirmed: json["mobile_confirmed"] ?? 0,
        lastKnownIp: json["last_known_ip"] ?? '',
        lastLoginAt: json["last_login_at"] ?? '',
        rating: json["rating"]?.toDouble(),
        noOfRatings: json["no_of_ratings"] ?? 0,
        refferalCode: json["refferal_code"] ?? '',
        currencyCode: json["currency_code"] ?? '',
        currencySymbol: json["currency_symbol"] ?? '',
        countryCode: json["country_code"] ?? '',
        showRentalRide: json["show_rental_ride"] ?? false,
        showRideLaterFeature: json["show_ride_later_feature"] ?? false,
        authorizationCode: json["authorization_code"] ?? '',
        enableModulesForApplications:
            json["enable_modules_for_applications"] ?? '',
        contactUsMobile1: json["contact_us_mobile1"] ?? '',
        contactUsMobile2: json["contact_us_mobile2"] ?? '',
        contactUsLink: json["contact_us_link"] ?? '',
        showWalletMoneyTransferFeatureOnMobileApp:
            json["show_wallet_money_transfer_feature_on_mobile_app"] ?? '',
        showBankInfoFeatureOnMobileApp:
            json["show_bank_info_feature_on_mobile_app"] ?? '',
        showWalletFeatureOnMobileApp:
            json["show_wallet_feature_on_mobile_app"] ?? '',
        notificationsCount: json["notifications_count"] ?? 0,
        referralComissionString: json["referral_comission_string"] ?? '',
        userCanMakeARideAfterXMiniutes:
            json["user_can_make_a_ride_after_x_miniutes"] ?? '0',
        maximumTimeForFindDriversForRegularRide:
            json["maximum_time_for_find_drivers_for_regular_ride"] ?? '0',
        maximumTimeForFindDriversForBittingRide:
            json["maximum_time_for_find_drivers_for_bitting_ride"] ?? '0',
        enableDriverPreferenceForUser:
            json["enable_driver_preference_for_user"] ?? '',
        enablePetPreferenceForUser:
            json["enable_pet_preference_for_user"] ?? '0',
        enableLuggagePreferenceForUser:
            json["enable_luggage_preference_for_user"] ?? '0',
        biddingAmountIncreaseOrDecrease:
            json["bidding_amount_increase_or_decrease"] ?? '',
        showRideWithoutDestination:
            json["show_ride_without_destination"] ?? '0',
        enableCountryRestrictOnMap:
            json["enable_country_restrict_on_map"] ?? '0',
        chatId: json["conversation_id"] ?? '',
        mapType: json["map_type"] ?? '',
        hasOngoingRide: json["has_ongoing_ride"] ?? false,
        showOutstationRideFeature: json["show_outstation_ride_feature"] ?? '0',
        showTaxiOutstationRideFeature:
            json["show_taxi_outstation_ride_feature"] ?? '0',
        showDeliveryOutstationRideFeature:
            json["show_delivery_outstation_ride_feature"] ?? '0',
        sos: SOS.fromJson(json["sos"]),
        bannerImage: json["bannerImage"] ?? '',
        wallet: Wallet.fromJson(json["wallet"]),
        // hasUpcomingRide: json["has_upcoming_ride"] ?? false,
      );
}

class DriverDetail {
  DriverDetailData data;

  DriverDetail({
    required this.data,
  });

  factory DriverDetail.fromJson(Map<String, dynamic> json) => DriverDetail(
        data: DriverDetailData.fromJson(json["data"]),
      );
}

class DriverDetailData {
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
  dynamic vehicleTypeImage;
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
  int completedRides;

  DriverDetailData({
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
    required this.vehicleTypeImage,
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
    required this.completedRides,
  });

  factory DriverDetailData.fromJson(Map<String, dynamic> json) =>
      DriverDetailData(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        email: json["email"] ?? '',
        ownerId: json["owner_id"] ?? '',
        mobile: json["mobile"] ?? '',
        profilePicture: json["profile_picture"] ?? '',
        active: json["active"] ?? false,
        fleetId: json["fleet_id"] ?? '',
        approve: json["approve"] ?? false,
        available: json["available"] ?? false,
        uploadedDocument: json["uploaded_document"] ?? '',
        declinedReason: json["declined_reason"] ?? '',
        serviceLocationId: json["service_location_id"] ?? '',
        vehicleTypeId: json["vehicle_type_id"] ?? '',
        vehicleTypeName: json["vehicle_type_name"] ?? '',
        vehicleTypeIcon: json["vehicle_type_icon"] ?? '',
        vehicleTypeImage: json["vehicle_type_image"] ?? '',
        carMake: json["car_make"] ?? '',
        carModel: json["car_model"] ?? '',
        carMakeName: json["car_make_name"] ?? '',
        carModelName: json["car_model_name"] ?? '',
        carColor: json["car_color"] ?? '',
        driverLat: json["driver_lat"] ?? '',
        driverLng: json["driver_lng"] ?? '',
        carNumber: json["car_number"] ?? '',
        rating: json["rating"].toString(),
        noOfRatings: json["no_of_ratings"],
        timezone: json["timezone"] ?? '',
        refferalCode: json["refferal_code"] ?? '',
        companyKey: json["company_key"] ?? '',
        showInstantRide: json["show_instant_ride"] ?? false,
        currencySymbol: json["currency_symbol"] ?? '₹',
        currencyCode: json["currency_code"] ?? 'INR',
        totalEarnings: json["total_earnings"].toString(),
        currentDate: json["current_date"] ?? '',
        completedRides: json["completed_ride_count"] ?? 0,
      );
}

class Wallet {
  WalletData data;

  Wallet({
    required this.data,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        data: WalletData.fromJson(json["data"]),
      );
}

class WalletData {
  String id;
  int userId;
  double amountAdded;
  double amountBalance;
  double amountSpent;
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
        id: json["id"] ?? '',
        userId: json["user_id"] ?? 0,
        amountAdded: json["amount_added"]?.toDouble(),
        amountBalance: json["amount_balance"]?.toDouble(),
        amountSpent: json["amount_spent"]?.toDouble(),
        currencySymbol: json["currency_symbol"] ?? '',
        currencyCode: json["currency_code"] ?? '',
        createdAt: json["created_at"] ?? '',
        updatedAt: json["updated_at"] ?? '',
      );
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
  double preferencePriceTotal;

  RequestBillData(
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
      required this.driverTips,
      required this.calculatedWaitingTime,
      required this.waitingChargePerMin,
      required this.adminCommisionFromDriver,
      required this.additionalChargesAmount,
      required this.additionalChargesReason,
      required this.calculatedDistance,
      required this.totalTime,
      required this.unit,
      required this.preferencePriceTotal});

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
        preferencePriceTotal: json['preference_price_total']?.toDouble() ?? 0,
      );
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
}
