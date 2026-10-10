import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Fits route geometry in the exposed map area without expanding coordinates
/// or applying the sheet inset a second time through native bounds padding.
abstract final class RouteCamera {
  static const double minimumMapHeight = 220;

  static EdgeInsets viewportPadding(Size size,
      {required double sheetHeight, required double topInset}) {
    final top = math.min(topInset + 24, size.height * .25);
    final maximumBottom = math.max(0.0, size.height - top - minimumMapHeight);
    return EdgeInsets.fromLTRB(
      24,
      top,
      24,
      (sheetHeight + 24).clamp(0.0, maximumBottom),
    );
  }

  static bool isValidPoint(LatLng point) =>
      point.latitude.isFinite &&
      point.longitude.isFinite &&
      point.latitude.abs() <= 90 &&
      point.longitude.abs() <= 180 &&
      !(point.latitude.abs() < .00001 && point.longitude.abs() < .00001);

  static LatLngBounds? boundsForPoints(Iterable<LatLng> points) {
    final valid = points.where(isValidPoint).toList();
    if (valid.isEmpty) return null;
    var south = valid.first.latitude;
    var north = south;
    final longitudes = <double>[];
    for (final point in valid) {
      south = math.min(south, point.latitude);
      north = math.max(north, point.latitude);
      longitudes.add((point.longitude + 360) % 360);
    }
    longitudes.sort();
    // The smallest arc containing the route is the complement of the largest
    // empty gap. This also fits routes crossing the international date line.
    var largestGap = -1.0;
    var start = 0;
    for (var i = 0; i < longitudes.length; i++) {
      final next = i == longitudes.length - 1
          ? longitudes.first + 360
          : longitudes[i + 1];
      final gap = next - longitudes[i];
      if (gap > largestGap) {
        largestGap = gap;
        start = (i + 1) % longitudes.length;
      }
    }
    final west = _longitude(longitudes[start]);
    final east = _longitude(longitudes[(start - 1) % longitudes.length]);
    return LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );
  }

  static CameraPosition fit(
      LatLngBounds bounds, Size size, EdgeInsets padding) {
    final west = (bounds.southwest.longitude + 180) / 360;
    var east = (bounds.northeast.longitude + 180) / 360;
    if (east < west) east += 1;
    final north = _mercatorY(bounds.northeast.latitude);
    final south = _mercatorY(bounds.southwest.latitude);
    final xSpan = east - west;
    final ySpan = south - north;
    final target = LatLng(
      _latitude((north + south) / 2),
      _longitude((west + east) / 2 * 360 - 180),
    );
    if ((bounds.northeast.latitude - bounds.southwest.latitude).abs() < .0004 &&
        xSpan * 360 < .0004) {
      return CameraPosition(target: target, zoom: 15.5);
    }
    // Space for the marker artwork at either end of the line. This is used
    // only in this calculation; no extra native bounds padding is applied.
    final width = math.max(1.0, size.width - padding.horizontal - 64);
    final height = math.max(1.0, size.height - padding.vertical - 64);
    double zoomFor(double pixels, double span) =>
        span <= 0 ? 20 : math.log(pixels / (256 * span)) / math.ln2;
    final zoom = math.min(zoomFor(width, xSpan), zoomFor(height, ySpan));
    return CameraPosition(target: target, zoom: zoom.clamp(0.0, 18.0));
  }

  static double _mercatorY(double latitude) {
    final sin =
        math.sin(latitude.clamp(-85.05112878, 85.05112878) * math.pi / 180);
    return .5 - math.log((1 + sin) / (1 - sin)) / (4 * math.pi);
  }

  static double _latitude(double y) {
    final value = math.pi * (1 - 2 * y);
    return math.atan((math.exp(value) - math.exp(-value)) / 2) * 180 / math.pi;
  }

  static double _longitude(double value) => (value + 180) % 360 - 180;
}
