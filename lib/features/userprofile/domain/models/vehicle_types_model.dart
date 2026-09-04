class VehicleTypeModel {
  bool success;
  List<VehicleTypeData> data;
  VehicleTypeModel({required this.success, required this.data});

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) {
    List<VehicleTypeData> data = [];
    json['data'].forEach((e) {
      data.add(VehicleTypeData.fromJson(e));
    });
    return VehicleTypeModel(
      success: json["success"],
      data: data,
    );
  }
}

class VehicleTypeData {
  String id;
  String name;
  String icon;
  String iconTypesFor;
  VehicleTypeData(
      {required this.id,
      required this.name,
      required this.icon,
      required this.iconTypesFor});

  factory VehicleTypeData.fromJson(Map<String, dynamic> json) {
    return VehicleTypeData(
        id: json['id'].toString(),
        name: json['name'],
        icon: json['icon'],
        iconTypesFor: json['icon_types_for']);
  }
}
