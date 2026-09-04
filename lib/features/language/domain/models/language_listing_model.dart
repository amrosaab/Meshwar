import 'dart:convert';

LanguageListResponseModel languageListResponseModelFromJson(String str) =>
    LanguageListResponseModel.fromJson(json.decode(str));

class LanguageListResponseModel {
  bool success;
  String message;
  Data data;

  LanguageListResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LanguageListResponseModel.fromJson(Map<String, dynamic> json) =>
      LanguageListResponseModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  List<LanguageList> data;

  Data({
    required this.data,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: List<LanguageList>.from(
            json["data"].map((x) => LanguageList.fromJson(x))),
      );
}

class LanguageList {
  int id;
  String lang;
  String name;
  int defaultStatus;

  LanguageList({
    required this.id,
    required this.lang,
    required this.name,
    required this.defaultStatus,
  });

  factory LanguageList.fromJson(Map<String, dynamic> json) => LanguageList(
        id: json["id"] ?? 0,
        lang: json["lang"] ?? '',
        name: json["name"] ?? '',
        defaultStatus: json["default_status"] ?? 0,
      );
}

class LocaleLanguageList {
  String lang;
  String name;

  LocaleLanguageList({
    required this.lang,
    required this.name,
  });

  factory LocaleLanguageList.fromJson(Map<String, dynamic> json) =>
      LocaleLanguageList(
        lang: json["lang"] ?? '',
        name: json["name"] ?? '',
      );
}
