import 'dart:convert';

ContactsModel contactsModelFromJson(String str) =>
    ContactsModel.fromJson(json.decode(str));

class ContactsModel {
  String name;
  String number;

  ContactsModel({
    required this.name,
    required this.number,
  });

  factory ContactsModel.fromJson(Map<String, dynamic> json) => ContactsModel(
        name: json["name"],
        number: json["number"],
      );
}
