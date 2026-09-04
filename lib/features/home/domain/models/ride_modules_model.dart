import 'dart:convert';

RideModulesModel rideModulesModelFromJson(String str) =>
    RideModulesModel.fromJson(json.decode(str));

String rideModulesModelToJson(RideModulesModel data) =>
    json.encode(data.toJson());

class RideModulesModel {
  bool success;
  String message;
  List<ModulesData> data;

  RideModulesModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RideModulesModel.fromJson(Map<String, dynamic> json) =>
      RideModulesModel(
        success: json["success"],
        message: json["message"],
        data: List<ModulesData>.from(
            json["data"].map((x) => ModulesData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ModulesData {
  String id;
  String name;
  String transportType;
  String serviceType;
  String menuIcon;
  String iconTypesFor;
  String description;
  String shortDescription;

  ModulesData({
    required this.id,
    required this.name,
    required this.transportType,
    required this.serviceType,
    required this.menuIcon,
    required this.iconTypesFor,
    required this.description,
    required this.shortDescription,
  });

  factory ModulesData.fromJson(Map<String, dynamic> json) => ModulesData(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        transportType: json["transport_type"] ?? '',
        serviceType: json["service_type"] ?? '',
        menuIcon: json["menu_icon"] ?? '',
        iconTypesFor: json["icon_types_for"] ?? '',
        description: json["description"] ?? '',
        shortDescription: json["short_description"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "transport_type": transportType,
        "service_type": serviceType,
        "menu_icon": menuIcon,
        "icon_types_for": iconTypesFor,
        "description": description,
        "short_description": shortDescription,
      };
}
