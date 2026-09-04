class ReferralResponseData {
  bool success;
  String message;
  ReferralData data;

  ReferralResponseData({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ReferralResponseData.fromJson(Map<String, dynamic> json) =>
      ReferralResponseData(
        success: json["success"],
        message: json["message"],
        data: ReferralData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class ReferralData {
  final ReferralContent referralContent;
  final DriverBanner driverBanner;

  ReferralData({
    required this.referralContent,
    required this.driverBanner,
  });

  factory ReferralData.fromJson(Map<String, dynamic> json) {
    final bannerJson = json["user_banner"] ?? json["driver_banner"];
    return ReferralData(
      referralContent: ReferralContent.fromJson(json["referral_content"]),
      driverBanner: bannerJson != null
          ? DriverBanner.fromJson(bannerJson)
          : DriverBanner.empty(),
    );
  }

  Map<String, dynamic> toJson() => {
        "referral_content": referralContent.toJson(),
        "driver_banner": driverBanner.toJson(),
      };
}

class ReferralContent {
  ReferralItem data;

  ReferralContent({
    required this.data,
  });

  factory ReferralContent.fromJson(Map<String, dynamic> json) =>
      ReferralContent(
        data: ReferralItem.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class DriverBanner {
  final ReferralItem data;

  DriverBanner({
    required this.data,
  });

  factory DriverBanner.fromJson(Map<String, dynamic> json) => DriverBanner(
        data: ReferralItem.fromJson(json["data"]),
      );

  factory DriverBanner.empty() => DriverBanner(data: ReferralItem.empty());

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class ReferralItem {
  final int id;
  final String referralType;
  final String description;
  final String labelReferral;
  final String translationDataset;

  ReferralItem({
    required this.id,
    required this.referralType,
    required this.description,
    required this.labelReferral,
    required this.translationDataset,
  });

  factory ReferralItem.fromJson(Map<String, dynamic> json) => ReferralItem(
        id: json["id"] ?? 0,
        referralType: json["referral_type"] ?? '',
        description: json["description"] ?? '',
        labelReferral: json["label_referral"] ?? '',
        translationDataset: json["translation_dataset"] ?? '',
      );

  factory ReferralItem.empty() => ReferralItem(
        id: 0,
        referralType: '',
        description: '',
        labelReferral: '',
        translationDataset: '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "referral_type": referralType,
        "description": description,
        "label_referral": labelReferral,
        "translation_dataset": translationDataset,
      };
}
