import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreference {
  // SET LOCAL DATA
  static Future setSelectedLanguageCode(String choosenLanguage) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString('choosenLanguage', choosenLanguage);
  }

  static Future setLanguageDirection(String direction) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString('direction', direction);
  }

  static Future setToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString('token', token);
  }

  static Future setLoginStatus(bool loginStatus) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool('login', loginStatus);
  }

  static Future setLandingStatus(bool landingStatus) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool('landing', landingStatus);
  }

  static Future setRecentSearchPlaces(String recentPlaces) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString('recentPlaces', recentPlaces);
  }

  static Future setMapType(String setMapType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString('mapType', setMapType);
  }

  static Future setSignInKey(String signInKey) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString('signInKey', signInKey);
  }

  static Future setPackageName(String packageName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString('packageName', packageName);
  }

  static Future setDarkThemeStatus(bool darkTheme) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool('dark', darkTheme);
  }

  static Future setIsMyself(bool isMyself) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isMyself', isMyself);
  }

  static Future setContactNumber(String contactNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('contactNumber', contactNumber);
  }

  static Future setContactName(String contactName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('contactName', contactName);
  }

  static Future setHomeLayoutType(String setHomeLayoutType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString('homeLayoutType', setHomeLayoutType);
  }

  // GET LOCAL DATA
  static Future<String> getSelectedLanguageCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('choosenLanguage') ?? '';
  }

  static Future<String> getLanguageDirection() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('direction') ?? 'ltr';
  }

  static Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  static Future getLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('login') ?? false;
  }

  static Future getLandingStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('landing') ?? false;
  }

  static Future<String> getRecentSearchPlaces() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('recentPlaces') ?? '';
  }

  static Future<String> getMapType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('mapType') ?? '';
  }

  static Future<String> getSignInKey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('signInKey') ?? '';
  }

  static Future<String> getPackageName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('packageName') ?? '';
  }

  static Future getDarkThemeStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('dark') ?? false;
  }

  static Future<bool> getIsMyself() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isMyself') ?? true; // default true
  }

  static Future<String> getContactNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('contactNumber') ?? '';
  }

  static Future<String> getContactName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('contactName') ?? '';
  }

  static Future<String> getHomeLayoutType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('homeLayoutType') ?? '';
  }

  // CLEAR
  static Future clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  static Future clearBookingDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isMyself');
    await prefs.remove('contactNumber');
    await prefs.remove('contactName');
  }
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
}
