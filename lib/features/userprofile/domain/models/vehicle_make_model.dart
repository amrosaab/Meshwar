class VehicleMakeModel {
  bool success;
  List<VehicleMakeData> data;
  VehicleMakeModel({required this.success, required this.data});

  factory VehicleMakeModel.fromJson(Map<String, dynamic> json) {
    List<VehicleMakeData> data = [];
    json['data'].forEach((e) {
      data.add(VehicleMakeData.fromJson(e));
    });
    return VehicleMakeModel(
      success: json["success"],
      data: data,
    );
  }
}

class VehicleMakeData {
  String id;
  String name;
  VehicleMakeData({required this.id, required this.name});

  factory VehicleMakeData.fromJson(Map<String, dynamic> json) {
    return VehicleMakeData(id: json['id'].toString(), name: json['name']);
  }
}
