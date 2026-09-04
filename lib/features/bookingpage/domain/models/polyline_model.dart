class PolylineModel {
  bool success;
  String polyString;
  String distance;
  String duration;

  PolylineModel({
    required this.success,
    required this.polyString,
    required this.distance,
    required this.duration,
  });

  factory PolylineModel.fromJson(Map<String, dynamic> json) {
    return PolylineModel(
      success: json["success"],
      polyString: json["polyString"],
      distance: json['distance'],
      duration: json['duration'],
    );
  }
}
