class AddressModel {
  String orderId;
  String? shortAddress;
  String address;
  double lat;
  double lng;
  bool pickup;
  bool? isAirportLocation;
  String? type;
  String? name;
  String? number;
  String? instructions;

  AddressModel({
    required this.orderId,
    this.shortAddress,
    required this.address,
    required this.lat,
    required this.lng,
    required this.pickup,
    this.isAirportLocation,
    this.type,
    this.name,
    this.number,
    this.instructions,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        orderId: json["order"],
        shortAddress: (json["short_address"] != null &&
                json["short_address"].toString().isNotEmpty)
            ? json["short_address"]
            : (json["address"].toString().isNotEmpty)
                ? json["address"].toString().split(',')[0]
                : '',
        address: json["address"],
        lat: json["latitude"].toDouble(),
        lng: json["longitude"].toDouble(),
        pickup: json["pickup"],
        isAirportLocation: json["is_airport"],
        type: json["type"],
        name: json["poc_name"],
        number: json["poc_mobile"],
        instructions: json["poc_instruction"],
      );

  Map<String, dynamic> toJson() => {
        "order": orderId,
        "short_address": (address.toString().isNotEmpty)
            ? address.toString().split(',')[0]
            : shortAddress,
        "address": address,
        "latitude": lat,
        "longitude": lng,
        "pickup": pickup,
        "is_airport": isAirportLocation,
        if (type != null) "type": type,
        "poc_name": name,
        "poc_mobile": number,
        "poc_instruction": instructions,
      };
}
