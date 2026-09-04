import 'dart:convert';

OnBoardingResponseModel onBoardingResponseModelFromJson(String str) =>
    OnBoardingResponseModel.fromJson(json.decode(str));

class OnBoardingResponseModel {
  bool success;
  OnBoardingList data;

  OnBoardingResponseModel({
    required this.success,
    required this.data,
  });

  factory OnBoardingResponseModel.fromJson(Map<String, dynamic> json) =>
      OnBoardingResponseModel(
        success: json["success"],
        data: OnBoardingList.fromJson(json["data"]),
      );
}

class OnBoardingList {
  Onboarding onboarding;

  OnBoardingList({
    required this.onboarding,
  });

  factory OnBoardingList.fromJson(Map<String, dynamic> json) => OnBoardingList(
        onboarding: Onboarding.fromJson(json["onboarding"]),
      );
}

class Onboarding {
  List<OnBoardingData> data;

  Onboarding({
    required this.data,
  });

  factory Onboarding.fromJson(Map<String, dynamic> json) => Onboarding(
        data: List<OnBoardingData>.from(
            json["data"].map((x) => OnBoardingData.fromJson(x))),
      );
}

class OnBoardingData {
  int order;
  int id;
  String screen;
  String title;
  String onboardingImage;
  String description;
  int active;

  OnBoardingData({
    required this.order,
    required this.id,
    required this.screen,
    required this.title,
    required this.onboardingImage,
    required this.description,
    required this.active,
  });

  factory OnBoardingData.fromJson(Map<String, dynamic> json) => OnBoardingData(
        order: json["order"],
        id: json["id"],
        screen: json["screen"],
        title: json["title"],
        onboardingImage: json["onboarding_image"],
        description: json["description"],
        active: json["active"],
      );
}
