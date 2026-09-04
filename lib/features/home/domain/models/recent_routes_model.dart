import 'dart:convert';

RecentRoutesModel recentRoutesModelFromJson(String str) =>
    RecentRoutesModel.fromJson(json.decode(str));

String recentRoutesModelToJson(RecentRoutesModel data) =>
    json.encode(data.toJson());

class RecentRoutesModel {
  bool success;
  String message;
  List<RecentRouteData> data;

  RecentRoutesModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RecentRoutesModel.fromJson(Map<String, dynamic> json) =>
      RecentRoutesModel(
        success: json["success"],
        message: json["message"],
        data: List<RecentRouteData>.from(
            json["data"].map((x) => RecentRouteData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class RecentRouteData {
  int id;
  int userId;
  double pickLat;
  double pickLng;
  double dropLat;
  double dropLng;
  String pickAddress;
  String pickShortAddress;
  String dropAddress;
  String dropShortAddress;
  String pickupPocName;
  String pickupPocMobile;
  String pickupPocInstruction;
  String dropPocName;
  String dropPocMobile;
  String dropPocInstruction;
  double totalDistance;
  double totalTime;
  String polyLine;
  String transportType;
  SearchStops searchStops;

  RecentRouteData({
    required this.id,
    required this.userId,
    required this.pickLat,
    required this.pickLng,
    required this.dropLat,
    required this.dropLng,
    required this.pickAddress,
    required this.pickShortAddress,
    required this.dropAddress,
    required this.dropShortAddress,
    required this.pickupPocName,
    required this.pickupPocMobile,
    required this.pickupPocInstruction,
    required this.dropPocName,
    required this.dropPocMobile,
    required this.dropPocInstruction,
    required this.totalDistance,
    required this.totalTime,
    required this.polyLine,
    required this.transportType,
    required this.searchStops,
  });

  factory RecentRouteData.fromJson(Map<String, dynamic> json) =>
      RecentRouteData(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? 0,
        pickLat: json["pick_lat"]?.toDouble(),
        pickLng: json["pick_lng"]?.toDouble(),
        dropLat: json["drop_lat"]?.toDouble(),
        dropLng: json["drop_lng"]?.toDouble(),
        pickAddress: json["pick_address"] ?? '',
        pickShortAddress: json["pick_short_address"] ?? '',
        dropAddress: json["drop_address"] ?? '',
        dropShortAddress: json["drop_short_address"] ?? '',
        pickupPocName: json["pickup_poc_name"] ?? '',
        pickupPocMobile: json["pickup_poc_mobile"] ?? '',
        pickupPocInstruction: json["pickup_poc_instruction"] ?? '',
        dropPocName: json["drop_poc_name"] ?? '',
        dropPocMobile: json["drop_poc_mobile"] ?? '',
        dropPocInstruction: json["drop_poc_instruction"] ?? '',
        totalDistance: json["total_distance"]?.toDouble(),
        totalTime: json["total_time"]?.toDouble() ?? 0.0,
        polyLine: json["poly_line"] ?? '',
        transportType: json["transport_type"] ?? '',
        searchStops: SearchStops.fromJson(json["searchStops"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "pick_lat": pickLat,
        "pick_lng": pickLng,
        "drop_lat": dropLat,
        "drop_lng": dropLng,
        "pick_address": pickAddress,
        "pick_short_address": pickShortAddress,
        "drop_address": dropAddress,
        "drop_short_address": dropShortAddress,
        "pickup_poc_name": pickupPocName,
        "pickup_poc_mobile": pickupPocMobile,
        "pickup_poc_instruction": pickupPocInstruction,
        "drop_poc_name": dropPocName,
        "drop_poc_mobile": dropPocMobile,
        "drop_poc_instruction": dropPocInstruction,
        "total_distance": totalDistance,
        "total_time": totalTime,
        "poly_line": polyLine,
        "transport_type": transportType,
        "searchStops": searchStops.toJson(),
      };
}

class SearchStops {
  List<SearchStopData> data;

  SearchStops({
    required this.data,
  });

  factory SearchStops.fromJson(Map<String, dynamic> json) => SearchStops(
        data: List<SearchStopData>.from(
            json["data"].map((x) => SearchStopData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class SearchStopData {
  int id;
  int recentSearcheId;
  String address;
  String shortAddress;
  double latitude;
  double longitude;
  String pocName;
  String pocMobile;
  int order;
  String pocInstruction;

  SearchStopData({
    required this.id,
    required this.recentSearcheId,
    required this.address,
    required this.shortAddress,
    required this.latitude,
    required this.longitude,
    required this.pocName,
    required this.pocMobile,
    required this.order,
    required this.pocInstruction,
  });

  factory SearchStopData.fromJson(Map<String, dynamic> json) => SearchStopData(
        id: json["id"] ?? 0,
        recentSearcheId: json["recent_searche_id"] ?? 0,
        address: json["address"] ?? '',
        shortAddress: json["short_address"] ?? '',
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        pocName: json["poc_name"] ?? '',
        pocMobile: json["poc_mobile"] ?? '',
        order: json["order"] ?? '',
        pocInstruction: json["poc_instruction"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "recent_searche_id": recentSearcheId,
        "address": address,
        "short_address": shortAddress,
        "latitude": latitude,
        "longitude": longitude,
        "poc_name": pocName,
        "poc_mobile": pocMobile,
        "order": order,
        "poc_instruction": pocInstruction,
      };
}
