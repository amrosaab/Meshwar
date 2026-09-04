import 'dart:math';

import 'package:url_launcher/url_launcher.dart';

double calculateDistance({
  required double lat1,
  required double lon1,
  required double lat2,
  required double lon2,
  String unit = 'km',
}) {
  const double p = pi / 180; // More precise than 0.01745...
  const double earthRadiusKm = 6371;

  final a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;

  final distanceKm = 2 * earthRadiusKm * asin(sqrt(a)); // distance in km

  if (unit.toLowerCase() == 'mi') {
    return distanceKm * 0.621371; // convert km to miles
  } else {
    return distanceKm; // in km
  }
}

// launchUrl
openUrl(String url) async {
  if (await launchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}
