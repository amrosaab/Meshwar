class VehicleModelModel {
  bool success;
  List<VehicleModelData> data;
  VehicleModelModel({required this.success, required this.data});

  factory VehicleModelModel.fromJson(Map<String, dynamic> json) {
    List<VehicleModelData> data = [];
    json['data'].forEach((e) {
      data.add(VehicleModelData.fromJson(e));
    });
    return VehicleModelModel(
      success: json["success"],
      data: data,
    );
  }
}

class VehicleModelData {
  String id;
  String name;
  VehicleModelData({required this.id, required this.name});

  factory VehicleModelData.fromJson(Map<String, dynamic> json) {
    return VehicleModelData(id: json['id'].toString(), name: json['name']);
  }
}
