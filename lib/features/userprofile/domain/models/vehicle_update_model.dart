class VehicleUpdateModel {
  bool success;
  Map? data;
  VehicleUpdateModel({required this.success, required this.data});

  factory VehicleUpdateModel.fromJson(Map<String, dynamic> json) {
    return VehicleUpdateModel(
      success: json["success"],
      data: json['data'],
    );
  }
}
