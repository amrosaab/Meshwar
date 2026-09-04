import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../db/app_database.dart';
import '../features/language/domain/models/language_listing_model.dart';

class AppConstants {
  static const String title = 'Meshwar';
  static const String baseUrl = 'https://meshwar.ws/';
  static String firbaseApiKey = (Platform.isAndroid)
      ? "AIzaSyANQlGC4GrYjqUn5S2u0uRomN-cnHqdAeM"
      : "AIzaSyAEKTPr1fiwgKzdqyAIOmMxUebAwW14F8Q";
  static String firebaseAppId =
      (Platform.isAndroid) ? "android firebase app id" : "ios firebase app id";
  static String firebasemessagingSenderId = (Platform.isAndroid)
      ? "android firebase sender id"
      : "ios firebase sender id";
  static String firebaseProjectId = (Platform.isAndroid)
      ? "android firebase project id"
      : "ios firebase project id";

  static String mapKey =
      (Platform.isAndroid) ? 'AIzaSyA4tuYaOWXDRLICWhWKc_P1819Xo3A0Ebc' : 'AIzaSyA4tuYaOWXDRLICWhWKc_P1819Xo3A0Ebc';

  static const String stripPublishKey = '';

  static List<LocaleLanguageList> languageList = [
    LocaleLanguageList(name: 'English', lang: 'en'),
    LocaleLanguageList(name: 'Arabic', lang: 'ar'),
    // LocaleLanguageList(name: 'Azerbaijani', lang: 'az'),
    LocaleLanguageList(name: 'French', lang: 'fr'),
    LocaleLanguageList(name: 'Spanish', lang: 'es'),
    // LocaleLanguageList(name: 'Albanian', lang: 'sq'),
    // LocaleLanguageList(name: 'Vietnamese', lang: 'vi'),
  ];

  static String packageName = '';
  static String signKey = '';
  static LatLng currentLocations = const LatLng(0, 0);
}

AppDatabase db = AppDatabase();
bool isAppMapChange = false;
bool isAppHomeLayoutChange = false;
