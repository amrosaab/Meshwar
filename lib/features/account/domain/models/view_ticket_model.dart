// To parse this JSON data, do
//
//     final viewTicketModel = viewTicketModelFromJson(jsonString);

import 'dart:convert';

ViewTicketModel viewTicketModelFromJson(String str) =>
    ViewTicketModel.fromJson(json.decode(str));

String viewTicketModelToJson(ViewTicketModel data) =>
    json.encode(data.toJson());

class ViewTicketModel {
  SupportTicket supportTicket;
  User user;
  List<ReplyMessage> replyMessage;
  List<Attachment> attachment;

  ViewTicketModel({
    required this.supportTicket,
    required this.user,
    required this.replyMessage,
    required this.attachment,
  });

  factory ViewTicketModel.fromJson(Map<String, dynamic> json) =>
      ViewTicketModel(
        supportTicket: SupportTicket.fromJson(json["supportTicket"]),
        user: User.fromJson(json["user"]),
        replyMessage: List<ReplyMessage>.from(
            json["reply_message"].map((x) => ReplyMessage.fromJson(x))),
        attachment: List<Attachment>.from(
            json["attachment"].map((x) => Attachment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "supportTicket": supportTicket.toJson(),
        "user": user.toJson(),
        "reply_message":
            List<dynamic>.from(replyMessage.map((x) => x.toJson())),
        "attachment": List<dynamic>.from(attachment.map((x) => x.toJson())),
      };
}

class Attachment {
  int id;
  String ticketId;
  String imageName;
  dynamic createdAt;
  dynamic updatedAt;
  String image;

  Attachment({
    required this.id,
    required this.ticketId,
    required this.imageName,
    required this.createdAt,
    required this.updatedAt,
    required this.image,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        id: json["id"] ?? 0,
        ticketId: json["ticket_id"] ?? '',
        imageName: json["image_name"] ?? "",
        createdAt: json["created_at"] != null
            ? DateTime.tryParse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.tryParse(json["updated_at"])
            : null,
        image: json["image"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ticket_id": ticketId,
        "image_name": imageName,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "image": image,
      };
}

class ReplyMessage {
  String? id;
  String? ticketId;
  int? userId;
  String? employeeId;
  String? message;
  int? senderId;
  int? isRead;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? convertedCreatedAt;

  ReplyMessage({
    required this.id,
    required this.ticketId,
    required this.userId,
    required this.employeeId,
    required this.message,
    required this.senderId,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    required this.convertedCreatedAt,
  });

  factory ReplyMessage.fromJson(Map<String, dynamic> json) => ReplyMessage(
        id: json["id"] ?? '',
        ticketId: json["ticket_id"] ?? '',
        userId: json["user_id"] ?? 0,
        employeeId: json["employee_id"] ?? '',
        message: json["message"] ?? '',
        senderId: json["sender_id"] ?? 0,
        isRead: json["is_read"] ?? 0,
        createdAt: (json["created_at"] != null &&
                json["created_at"].toString().isNotEmpty)
            ? DateTime.tryParse(json["created_at"])
            : null,
        updatedAt: (json["updated_at"] != null &&
                json["updated_at"].toString().isNotEmpty)
            ? DateTime.tryParse(json["updated_at"])
            : null,
        convertedCreatedAt: json["converted_created_at"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ticket_id": ticketId,
        "user_id": userId,
        "employee_id": employeeId,
        "message": message,
        "sender_id": senderId,
        "is_read": isRead,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "converted_created_at": convertedCreatedAt,
      };
}

class SupportTicket {
  String id;
  String ticketId;
  String titleId;
  int usersId;
  dynamic driverId;
  String description;
  String? assignTo;
  String? requestId;
  int status;
  String supportType;
  String serviceLocationId;
  DateTime createdAt;
  DateTime updatedAt;
  String title;
  String userName;
  String convertedCreatedAt;
  String? adminName;
  String serviceLocationName;
  TicketTitle ticketTitle;
  User user;
  AdminDetails? adminDetails;
  ServiceLocation serviceLocation;

  SupportTicket({
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
    required this.adminDetails,
    required this.serviceLocation,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) => SupportTicket(
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
      createdAt: DateTime.tryParse(json["created_at"] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? '') ?? DateTime.now(),
      title: json["title"] ?? '',
      userName: json["user_name"] ?? '',
      convertedCreatedAt: json["converted_created_at"] ?? '',
      adminName: json["admin_name"],
      serviceLocationName: json["service_location_name"] ?? '',
      ticketTitle: TicketTitle.fromJson(json["ticket_title"]),
      user: User.fromJson(json["user"]),
      adminDetails: json["admin_details"] != null
          ? AdminDetails.fromJson(json["admin_details"])
          : null,
      serviceLocation: ServiceLocation.fromJson(json["service_location"]));

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
        "admin_details": adminDetails!.toJson(),
        "service_location": serviceLocation.toJson(),
      };
}

class AdminDetails {
  String id;
  int userId;
  dynamic serviceLocationId;
  String firstName;
  dynamic lastName;
  dynamic address;
  dynamic country;
  dynamic state;
  dynamic city;
  int active;
  dynamic pincode;
  String email;
  String mobile;
  dynamic createdBy;
  dynamic categoryType;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  String profilePicture;
  dynamic serviceLocationName;
  String roleName;
  int userStatus;
  dynamic user;

  AdminDetails({
    required this.id,
    required this.userId,
    required this.serviceLocationId,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.country,
    required this.state,
    required this.city,
    required this.active,
    required this.pincode,
    required this.email,
    required this.mobile,
    required this.createdBy,
    required this.categoryType,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.profilePicture,
    required this.serviceLocationName,
    required this.roleName,
    required this.userStatus,
    required this.user,
  });

  factory AdminDetails.fromJson(Map<String, dynamic> json) => AdminDetails(
      id: json["id"] ?? '',
      userId: json["user_id"] ?? 0,
      serviceLocationId: json["service_location_id"],
      firstName: json["first_name"] ?? '',
      lastName: json["last_name"],
      address: json["address"],
      country: json["country"],
      state: json["state"],
      city: json["city"],
      active: json["active"] ?? 0,
      pincode: json["pincode"],
      email: json["email"] ?? '',
      mobile: json["mobile"] ?? '',
      createdBy: json["created_by"],
      categoryType: json["category_type"],
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"])
          : null,
      updatedAt: json["updated_at"] != null
          ? DateTime.tryParse(json["updated_at"])
          : null,
      deletedAt: json["deleted_at"],
      profilePicture: json["profile_picture"] ?? '',
      serviceLocationName: json["service_location_name"],
      roleName: json["role_name"] ?? '',
      userStatus: json["user_status"] ?? 0,
      user: json["user"] != null ? User.fromJson(json["user"]) : null);

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "service_location_id": serviceLocationId,
        "first_name": firstName,
        "last_name": lastName,
        "address": address,
        "country": country,
        "state": state,
        "city": city,
        "active": active,
        "pincode": pincode,
        "email": email,
        "mobile": mobile,
        "created_by": createdBy,
        "category_type": categoryType,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "profile_picture": profilePicture,
        "service_location_name": serviceLocationName,
        "role_name": roleName,
        "user_status": userStatus,
        "user": user.toJson(),
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
  int? country;
  String? timezone;
  int active;
  int emailConfirmed;
  int mobileConfirmed;
  dynamic fcmToken;
  dynamic apnToken;
  dynamic refferalCode;
  dynamic referredBy;
  double? rating;
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
  dynamic createdAt;
  dynamic updatedAt;
  dynamic authorizationCode;
  dynamic deletedAt;
  String? countryName;
  String mobileNumber;
  List<Role>? roles;
  CountryDetail? countryDetail;

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
    this.roles,
    required this.countryDetail,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        companyKey: json["company_key"],
        username: json["username"],
        mapType: json["map_type"],
        email: json["email"] ?? '',
        mobile: json["mobile"] ?? '',
        rideOtp: json["ride_otp"],
        gender: json["gender"],
        profilePicture: json["profile_picture"] ?? '',
        stripeCustomerId: json["stripe_customer_id"],
        isDeletedAt: json["is_deleted_at"],
        country: json["country"],
        timezone: json["timezone"],
        active: json["active"] ?? 0,
        emailConfirmed: json["email_confirmed"] ?? 0,
        mobileConfirmed: json["mobile_confirmed"] ?? 0,
        fcmToken: json["fcm_token"],
        apnToken: json["apn_token"],
        refferalCode: json["refferal_code"],
        referredBy: json["referred_by"],
        rating:
            json["rating"] != null ? (json["rating"] as num).toDouble() : null,
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
            ? DateTime.tryParse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.tryParse(json["updated_at"])
            : null,
        authorizationCode: json["authorization_code"],
        deletedAt: json["deleted_at"],
        countryName: json["country_name"],
        mobileNumber: json["mobile_number"] ?? '',
        roles: json["roles"] != null
            ? List<Role>.from(json["roles"].map((x) => Role.fromJson(x)))
            : [],
        countryDetail: json["country_detail"] != null
            ? CountryDetail.fromJson(json["country_detail"])
            : null,
      );

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
        "roles": roles == null
            ? []
            : List<dynamic>.from(roles!.map((x) => x.toJson())),
        "country_detail": countryDetail?.toJson(),
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
        name: json["name"] ?? '',
        dialCode: json["dial_code"] ?? '',
        dialMinLength: json["dial_min_length"] ?? 0,
        dialMaxLength: json["dial_max_length"] ?? 0,
        code: json["code"] ?? '',
        currencyName: json["currency_name"] ?? '',
        currencyCode: json["currency_code"] ?? '',
        currencySymbol: json["currency_symbol"] ?? '',
        flag: json["flag"] ?? '',
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

class Role {
  int id;
  String slug;
  String name;
  String description;
  int all;
  int locked;
  dynamic createdBy;
  dynamic createdAt;
  dynamic updatedAt;
  Pivot pivot;

  Role({
    required this.id,
    required this.slug,
    required this.name,
    required this.description,
    required this.all,
    required this.locked,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"] ?? 0,
        slug: json["slug"] ?? '',
        name: json["name"] ?? '',
        description: json["description"] ?? '',
        all: json["all"] ?? 0,
        locked: json["locked"] ?? 0,
        createdBy: json["created_by"],
        createdAt: json["created_at"] != null
            ? DateTime.tryParse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.tryParse(json["updated_at"])
            : null,
        pivot: json["pivot"] != null
            ? Pivot.fromJson(json["pivot"])
            : Pivot(userId: 0, roleId: 0),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "slug": slug,
        "name": name,
        "description": description,
        "all": all,
        "locked": locked,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "pivot": pivot.toJson(),
      };
}

class Pivot {
  int userId;
  int roleId;

  Pivot({
    required this.userId,
    required this.roleId,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        userId: json["user_id"] ?? 0,
        roleId: json["role_id"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "role_id": roleId,
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
        id: json["id"] ?? '',
        companyKey: json["company_key"],
        name: json["name"] ?? '',
        translationDataset: json["translation_dataset"] ?? '',
        currencyName: json["currency_name"] ?? '',
        currencyCode: json["currency_code"] ?? '',
        currencySymbol: json["currency_symbol"] ?? '',
        currencyPointer: json["currency_pointer"] ?? '',
        timezone: json["timezone"] ?? '',
        country: json["country"] ?? 0,
        active: json["active"] ?? 0,
        createdAt: json["created_at"] != null
            ? DateTime.tryParse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.tryParse(json["updated_at"])
            : null,
        deletedAt: json["deleted_at"],
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
        id: json["id"] ?? '',
        title: json["title"] ?? "",
        categoryType: json["category_type"],
        titleType: json["title_type"] ?? "",
        userType: json["user_type"] ?? "",
        translationDataset: json["translation_dataset"] ?? "",
        active: json["active"] ?? 0,
        createdAt: json["created_at"] != null
            ? DateTime.tryParse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.tryParse(json["updated_at"])
            : null,
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
