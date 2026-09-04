class ServiceLocationModel {
  bool success;
  List<ServiceLocationData> data;
  ServiceLocationModel({required this.success, required this.data});

  factory ServiceLocationModel.fromJson(Map<String, dynamic> json) {
    List<ServiceLocationData> data = [];
    json['data'].forEach((e) {
      data.add(ServiceLocationData.fromJson(e));
    });
    return ServiceLocationModel(
      success: json["success"],
      data: data,
    );
  }
}

class ServiceLocationData {
  String id;
  String name;
  ServiceLocationData({required this.id, required this.name});

  factory ServiceLocationData.fromJson(Map<String, dynamic> json) {
    return ServiceLocationData(id: json['id'], name: json['name']);
  }
}
