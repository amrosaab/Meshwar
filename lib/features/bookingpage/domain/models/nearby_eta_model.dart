class NearbyEtaModel {
  String typeId;
  String duration;

  NearbyEtaModel({
    required this.typeId,
    required this.duration,
  });

  factory NearbyEtaModel.fromJson(Map<String, dynamic> json) {
    return NearbyEtaModel(
      typeId: json["type_id"],
      duration: json['duration'],
    );
  }
}
