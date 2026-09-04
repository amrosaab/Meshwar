import 'dart:convert';

CountryListModel countryListResponseModelFromJson(String str) =>
    CountryListModel.fromJson(json.decode(str));

class CountryListModel {
  bool success;
  List<Country> data;

  CountryListModel({
    required this.success,
    required this.data,
  });

  factory CountryListModel.fromJson(Map<String, dynamic> json) =>
      CountryListModel(
        success: json["success"],
        data: List<Country>.from(json["data"].map((x) => Country.fromJson(x))),
      );
}

class Country {
  int id;
  String dialCode;
  String name;
  String code;
  String? flag;
  int dialMinLength;
  int dialMaxLength;
  bool active;
  bool datumDefault;

  Country({
    required this.id,
    required this.dialCode,
    required this.name,
    required this.code,
    required this.flag,
    required this.dialMinLength,
    required this.dialMaxLength,
    required this.active,
    required this.datumDefault,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"] ?? 0,
        dialCode: json["dial_code"] ?? '',
        name: json["name"] ?? '',
        code: json["code"] ?? '',
        flag: json["flag"] ?? '',
        dialMinLength: json["dial_min_length"] ?? 0,
        dialMaxLength: json["dial_max_length"] ?? 0,
        active: json["active"] ?? false,
        datumDefault: json["default"] ?? false,
      );
}
