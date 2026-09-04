// To parse this JSON data, do
//
//     final ticketListModel = ticketListModelFromJson(jsonString);

import 'dart:convert';

TicketListModel ticketListModelFromJson(String str) =>
    TicketListModel.fromJson(json.decode(str));

String ticketListModelToJson(TicketListModel data) =>
    json.encode(data.toJson());

class TicketListModel {
  bool success;
  String message;
  List<TicketData> data;

  TicketListModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TicketListModel.fromJson(Map<String, dynamic> json) =>
      TicketListModel(
        success: json["success"],
        message: json["message"],
        data: List<TicketData>.from(
            json["data"].map((x) => TicketData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class TicketData {
  String id;
  String ticketId;
  String titleId;
  int usersId;
  dynamic driverId;
  String description;
  dynamic assignTo;
  dynamic requestId;
  int status;
  String supportType;
  String serviceLocationId;
  DateTime createdAt;
  DateTime updatedAt;
  String title;
  String userName;
  String convertedCreatedAt;
  dynamic adminName;
  String serviceLocationName;
  dynamic ticketTitle;
  dynamic user;
  dynamic serviceLocation;

  TicketData({
    required this.id,
    required this.ticketId,
    required this.titleId,
    required this.usersId,
    required this.driverId,
    required this.description,
    required this.assignTo,
    required this.requestId,
    required this.status,
    required this.supportType,
    required this.serviceLocationId,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.userName,
    required this.convertedCreatedAt,
    required this.adminName,
    required this.serviceLocationName,
    required this.ticketTitle,
    required this.user,
    required this.serviceLocation,
  });

  factory TicketData.fromJson(Map<String, dynamic> json) => TicketData(
        id: json["id"] ?? '',
        ticketId: json["ticket_id"] ?? '',
        titleId: json["title_id"] ?? '',
        usersId: json["users_id"] ?? 0,
        driverId: json["driver_id"],
        description: json["description"] ?? '',
        assignTo: json["assign_to"],
        requestId: json["request_id"],
        status: json["status"] ?? 0,
        supportType: json["support_type"] ?? '',
        serviceLocationId: json["service_location_id"] ?? '',
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        title: json["title"] ?? '',
        userName: json["user_name"] ?? '',
        convertedCreatedAt: json["converted_created_at"] ?? '',
        adminName: json["admin_name"],
        serviceLocationName: json["service_location_name"] ?? '',
        ticketTitle: json['ticket_title'] != null
            ? TicketTitle.fromJson(json["ticket_title"])
            : null,
        user: json["user"] != null ? User.fromJson(json["user"]) : null,
        serviceLocation: json["service_location"] != null
            ? ServiceLocation.fromJson(json["service_location"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ticket_id": ticketId,
        "title_id": titleId,
        "users_id": usersId,
        "driver_id": driverId,
        "description": description,
        "assign_to": assignTo,
        "request_id": requestId,
        "status": status,
        "support_type": supportType,
        "service_location_id": serviceLocationId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "title": title,
        "user_name": userName,
        "converted_created_at": convertedCreatedAt,
        "admin_name": adminName,
        "service_location_name": serviceLocationName,
        "ticket_title": ticketTitle.toJson(),
        "user": user.toJson(),
        "service_location": serviceLocation.toJson(),
      };
}

class ServiceLocation {
  String id;
  dynamic companyKey;
  String name;
  String translationDataset;
  String currencyName;
  String currencyCode;
  String currencySymbol;
  String currencyPointer;
  String timezone;
  int country;
  int active;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;

  ServiceLocation({
    required this.id,
    required this.companyKey,
    required this.name,
    required this.translationDataset,
    required this.currencyName,
    required this.currencyCode,
    required this.currencySymbol,
    required this.currencyPointer,
    required this.timezone,
    required this.country,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory ServiceLocation.fromJson(Map<String, dynamic> json) =>
      ServiceLocation(
        id: json["id"] ?? "",
        companyKey: json["company_key"] ?? "",
        name: json["name"] ?? "",
        translationDataset: json["translation_dataset"] ?? "",
        currencyName: json["currency_name"] ?? "",
        currencyCode: json["currency_code"] ?? "",
        currencySymbol: json["currency_symbol"] ?? "",
        currencyPointer: json["currency_pointer"] ?? "",
        timezone: json["timezone"] ?? "",
        country: json["country"] ?? "",
        active: json["active"] ?? "",
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
        deletedAt: json["deleted_at"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_key": companyKey,
        "name": name,
        "translation_dataset": translationDataset,
        "currency_name": currencyName,
        "currency_code": currencyCode,
        "currency_symbol": currencySymbol,
        "currency_pointer": currencyPointer,
        "timezone": timezone,
        "country": country,
        "active": active,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class TicketTitle {
  String id;
  String title;
  dynamic categoryType;
  String titleType;
  String userType;
  String translationDataset;
  int active;
  dynamic createdAt;
  dynamic updatedAt;

  TicketTitle({
    required this.id,
    required this.title,
    required this.categoryType,
    required this.titleType,
    required this.userType,
    required this.translationDataset,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TicketTitle.fromJson(Map<String, dynamic> json) => TicketTitle(
        id: json["id"] ?? "",
        title: json["title"] ?? "",
        categoryType: json["category_type"],
        titleType: json["title_type"] ?? "",
        userType: json["user_type"] ?? "",
        translationDataset: json["translation_dataset"] ?? "",
        active: json["active"] ?? 0,
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "category_type": categoryType,
        "title_type": titleType,
        "user_type": userType,
        "translation_dataset": translationDataset,
        "active": active,
        "created_at": createdAt,
        "updated_at": updatedAt.toIso8601String(),
      };
}

class User {
  int id;
  String name;
  dynamic companyKey;
  dynamic username;
  dynamic mapType;
  String email;
  String mobile;
  dynamic rideOtp;
  String? gender;
  String profilePicture;
  dynamic stripeCustomerId;
  dynamic isDeletedAt;
  int country;
  dynamic timezone;
  int active;
  int emailConfirmed;
  int mobileConfirmed;
  dynamic fcmToken;
  dynamic apnToken;
  dynamic refferalCode;
  dynamic referredBy;
  double rating;
  String? lang;
  dynamic zoneId;
  dynamic currentLat;
  dynamic currentLng;
  int ratingTotal;
  int noOfRatings;
  dynamic loginBy;
  dynamic lastKnownIp;
  dynamic lastLoginAt;
  dynamic socialProvider;
  int isBidApp;
  dynamic socialNickname;
  dynamic socialId;
  dynamic socialToken;
  dynamic socialTokenSecret;
  dynamic socialRefreshToken;
  dynamic socialExpiresIn;
  dynamic socialAvatar;
  dynamic socialAvatarOriginal;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic authorizationCode;
  dynamic deletedAt;
  String countryName;
  String mobileNumber;
  dynamic countryDetail;

  User({
    required this.id,
    required this.name,
    required this.companyKey,
    required this.username,
    required this.mapType,
    required this.email,
    required this.mobile,
    required this.rideOtp,
    required this.gender,
    required this.profilePicture,
    required this.stripeCustomerId,
    required this.isDeletedAt,
    required this.country,
    required this.timezone,
    required this.active,
    required this.emailConfirmed,
    required this.mobileConfirmed,
    required this.fcmToken,
    required this.apnToken,
    required this.refferalCode,
    required this.referredBy,
    required this.rating,
    required this.lang,
    required this.zoneId,
    required this.currentLat,
    required this.currentLng,
    required this.ratingTotal,
    required this.noOfRatings,
    required this.loginBy,
    required this.lastKnownIp,
    required this.lastLoginAt,
    required this.socialProvider,
    required this.isBidApp,
    required this.socialNickname,
    required this.socialId,
    required this.socialToken,
    required this.socialTokenSecret,
    required this.socialRefreshToken,
    required this.socialExpiresIn,
    required this.socialAvatar,
    required this.socialAvatarOriginal,
    required this.createdAt,
    required this.updatedAt,
    required this.authorizationCode,
    required this.deletedAt,
    required this.countryName,
    required this.mobileNumber,
    required this.countryDetail,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      companyKey: json["company_key"],
      username: json["username"],
      mapType: json["map_type"],
      email: json["email"] ?? "",
      mobile: json["mobile"] ?? "",
      rideOtp: json["ride_otp"],
      gender: json["gender"],
      profilePicture: json["profile_picture"] ?? "",
      stripeCustomerId: json["stripe_customer_id"],
      isDeletedAt: json["is_deleted_at"],
      country: json["country"] ?? 0,
      timezone: json["timezone"],
      active: json["active"] ?? 0,
      emailConfirmed: json["email_confirmed"] ?? 0,
      mobileConfirmed: json["mobile_confirmed"] ?? 0,
      fcmToken: json["fcm_token"],
      apnToken: json["apn_token"],
      refferalCode: json["refferal_code"],
      referredBy: json["referred_by"],
      rating: (json["rating"] != null) ? json["rating"].toDouble() : 0.0,
      lang: json["lang"],
      zoneId: json["zone_id"],
      currentLat: json["current_lat"],
      currentLng: json["current_lng"],
      ratingTotal: json["rating_total"] ?? 0,
      noOfRatings: json["no_of_ratings"] ?? 0,
      loginBy: json["login_by"],
      lastKnownIp: json["last_known_ip"],
      lastLoginAt: json["last_login_at"],
      socialProvider: json["social_provider"],
      isBidApp: json["is_bid_app"] ?? 0,
      socialNickname: json["social_nickname"],
      socialId: json["social_id"],
      socialToken: json["social_token"],
      socialTokenSecret: json["social_token_secret"],
      socialRefreshToken: json["social_refresh_token"],
      socialExpiresIn: json["social_expires_in"],
      socialAvatar: json["social_avatar"],
      socialAvatarOriginal: json["social_avatar_original"],
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"]) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json["updated_at"] != null
          ? DateTime.tryParse(json["updated_at"]) ?? DateTime.now()
          : DateTime.now(),
      authorizationCode: json["authorization_code"],
      deletedAt: json["deleted_at"],
      countryName: json["country_name"] ?? '',
      mobileNumber: json["mobile_number"] ?? '',
      countryDetail: json["country_detail"] != null
          ? CountryDetail.fromJson(json["country_detail"])
          : null);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "company_key": companyKey,
        "username": username,
        "map_type": mapType,
        "email": email,
        "mobile": mobile,
        "ride_otp": rideOtp,
        "gender": gender,
        "profile_picture": profilePicture,
        "stripe_customer_id": stripeCustomerId,
        "is_deleted_at": isDeletedAt,
        "country": country,
        "timezone": timezone,
        "active": active,
        "email_confirmed": emailConfirmed,
        "mobile_confirmed": mobileConfirmed,
        "fcm_token": fcmToken,
        "apn_token": apnToken,
        "refferal_code": refferalCode,
        "referred_by": referredBy,
        "rating": rating,
        "lang": lang,
        "zone_id": zoneId,
        "current_lat": currentLat,
        "current_lng": currentLng,
        "rating_total": ratingTotal,
        "no_of_ratings": noOfRatings,
        "login_by": loginBy,
        "last_known_ip": lastKnownIp,
        "last_login_at": lastLoginAt,
        "social_provider": socialProvider,
        "is_bid_app": isBidApp,
        "social_nickname": socialNickname,
        "social_id": socialId,
        "social_token": socialToken,
        "social_token_secret": socialTokenSecret,
        "social_refresh_token": socialRefreshToken,
        "social_expires_in": socialExpiresIn,
        "social_avatar": socialAvatar,
        "social_avatar_original": socialAvatarOriginal,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "authorization_code": authorizationCode,
        "deleted_at": deletedAt,
        "country_name": countryName,
        "mobile_number": mobileNumber,
        "country_detail": countryDetail.toJson(),
      };
}

class CountryDetail {
  int id;
  String name;
  String dialCode;
  int dialMinLength;
  int dialMaxLength;
  String code;
  String currencyName;
  String currencyCode;
  String currencySymbol;
  String flag;
  int active;
  dynamic createdAt;
  dynamic updatedAt;

  CountryDetail({
    required this.id,
    required this.name,
    required this.dialCode,
    required this.dialMinLength,
    required this.dialMaxLength,
    required this.code,
    required this.currencyName,
    required this.currencyCode,
    required this.currencySymbol,
    required this.flag,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CountryDetail.fromJson(Map<String, dynamic> json) => CountryDetail(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        dialCode: json["dial_code"] ?? "",
        dialMinLength: json["dial_min_length"] ?? 0,
        dialMaxLength: json["dial_max_length"] ?? 0,
        code: json["code"] ?? "",
        currencyName: json["currency_name"] ?? "",
        currencyCode: json["currency_code"] ?? "",
        currencySymbol: json["currency_symbol"] ?? "",
        flag: json["flag"] ?? "",
        active: json["active"] ?? 0,
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "dial_code": dialCode,
        "dial_min_length": dialMinLength,
        "dial_max_length": dialMaxLength,
        "code": code,
        "currency_name": currencyName,
        "currency_code": currencyCode,
        "currency_symbol": currencySymbol,
        "flag": flag,
        "active": active,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
