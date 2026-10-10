import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meshwar_user/common/route_camera.dart';

void main() {
  const screen = Size(402, 874);
  const cairo = LatLng(30.0444, 31.2357);
  const alexandria = LatLng(31.2001, 29.9187);

  test('The Cairo–Alexandria route stays local with a nearly full-height sheet',
      () {
    final bounds = RouteCamera.boundsForPoints([cairo, alexandria])!;
    final restingPadding =
        RouteCamera.viewportPadding(screen, sheetHeight: 490, topInset: 59);
    final expandedPadding =
        RouteCamera.viewportPadding(screen, sheetHeight: 800, topInset: 59);
    final resting = RouteCamera.fit(bounds, screen, restingPadding);
    final expanded = RouteCamera.fit(bounds, screen, expandedPadding);
    expect(screen.height - expandedPadding.vertical, greaterThanOrEqualTo(220));
    expect(expanded.zoom, inInclusiveRange(6.5, 9.0));
    expect((resting.zoom - expanded.zoom).abs(), lessThan(1));
    expect(expanded.target.latitude, inInclusiveRange(30, 32));
    expect(expanded.target.longitude, inInclusiveRange(29, 32));
  });

  test('Expanded sheets stop shrinking the camera viewport', () {
    final expanded =
        RouteCamera.viewportPadding(screen, sheetHeight: 800, topInset: 59);
    final covered =
        RouteCamera.viewportPadding(screen, sheetHeight: 870, topInset: 59);
    expect(covered, expanded);
  });

  test(
      'All bends of the route fit inside the exposed map with marker clearance',
      () {
    const points = [cairo, LatLng(31.4, 31.6), alexandria];
    final bounds = RouteCamera.boundsForPoints(points)!;
    final padding =
        RouteCamera.viewportPadding(screen, sheetHeight: 500, topInset: 59);
    final camera = RouteCamera.fit(bounds, screen, padding);
    final viewport = Rect.fromLTRB(padding.left, padding.top,
        screen.width - padding.right, screen.height - padding.bottom);
    final worldSize = 256 * math.pow(2, camera.zoom);
    double y(double latitude) {
      final sine = math.sin(latitude * math.pi / 180);
      return .5 - math.log((1 + sine) / (1 - sine)) / (4 * math.pi);
    }

    for (final point in points) {
      final dx = (point.longitude - camera.target.longitude) / 360 * worldSize;
      final dy = (y(point.latitude) - y(camera.target.latitude)) * worldSize;
      final pixel = viewport.center + Offset(dx, dy);
      expect(
          pixel.dx, inInclusiveRange(viewport.left + 31, viewport.right - 31));
      expect(
          pixel.dy, inInclusiveRange(viewport.top + 31, viewport.bottom - 31));
    }
  });

  test('Coincident pickup and drop use a useful street-level zoom', () {
    final bounds = RouteCamera.boundsForPoints([cairo, cairo])!;
    final camera = RouteCamera.fit(bounds, screen, EdgeInsets.zero);
    expect(camera.zoom, 15.5);
    expect(camera.target.latitude, closeTo(cairo.latitude, .000001));
    expect(camera.target.longitude, closeTo(cairo.longitude, .000001));
  });

  test(
      'Kuwait route bounds are retained and zero-coordinate placeholders ignored',
      () {
    const pickup = LatLng(29.3759, 47.9774);
    const drop = LatLng(29.3375, 48.0758);
    final bounds =
        RouteCamera.boundsForPoints([pickup, drop, const LatLng(0, 0)])!;
    expect(bounds.contains(pickup), isTrue);
    expect(bounds.contains(drop), isTrue);
    expect(bounds.contains(const LatLng(0, 0)), isFalse);
    expect(RouteCamera.boundsForPoints([const LatLng(0, 0)]), isNull);
  });

  test('Crossing the date line fits a local route instead of the entire world',
      () {
    final bounds = RouteCamera.boundsForPoints(
        [const LatLng(10, 179.5), const LatLng(10.1, -179.5)])!;
    final camera = RouteCamera.fit(bounds, screen, EdgeInsets.zero);
    expect(camera.target.longitude.abs(), closeTo(180, .001));
    expect(camera.zoom, greaterThan(7));
  });
}
