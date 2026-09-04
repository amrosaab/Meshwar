import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/contact_model.dart';

class ContactLocalStorage {
  static const String contactKey = "saved_contacts";
  static const int maxContacts = 4;

  static Future<void> saveContact(ContactsModel contact) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> existing = prefs.getStringList(contactKey) ?? [];

    // remove duplicate number if already exists
    existing.removeWhere((item) {
      final data = jsonDecode(item);
      return data["number"] == contact.number;
    });

    // if already max → remove oldest
    if (existing.length >= maxContacts) {
      existing.removeAt(0);
    }

    // add new contact
    existing.add(jsonEncode({
      "name": contact.name,
      "number": contact.number,
    }));

    await prefs.setStringList(contactKey, existing);
  }

  static Future<List<ContactsModel>> getContacts() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> stored = prefs.getStringList(contactKey) ?? [];

    return stored.map((e) {
      final json = jsonDecode(e);
      return ContactsModel(
        name: json["name"],
        number: json["number"],
      );
    }).toList();
  }

  // ⭐ CLEAR ALL SAVED CONTACTS (NEW METHOD)
  static Future<void> clearContacts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(contactKey);
  }
}
