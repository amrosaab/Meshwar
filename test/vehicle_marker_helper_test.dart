import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meshwar_user/common/vehicle_marker_helper.dart';
import 'package:meshwar_user/common/sedan_pose.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(VehicleMarkerHelper.preCacheSedanMarkers);

  for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
    test('$platform keeps an exact heading from the first car frame', () {
      debugDefaultTargetPlatformOverride = platform;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      final source = Marker(
        markerId: const MarkerId('marker#driver#car'),
        position: const LatLng(29.3759, 47.9774),
        rotation: VehicleMarkerHelper.sourceRotation('car', 91.4),
        icon: VehicleMarkerHelper.getMarker('car', bearing: 91.4),
      );
      expect(VehicleMarkerHelper.worldBearingFor(source), closeTo(91.4, .0001));
      final projected = VehicleMarkerHelper.projectForCamera(source,
          cameraBearing: 30, cameraTilt: 45);
      final bitmap = projected.icon as AssetMapBitmap;
      expect(bitmap.width, 64);
      expect(bitmap.height, 64);
      expect(bitmap.bitmapScaling, MapBitmapScaling.auto);
      expect(bitmap.assetName, const SedanPose(60, 45).assetPath);
      expect(projected.rotation, greaterThan(0));
      expect(projected.position, source.position);
      expect(projected.flat, isFalse);
      expect(projected.anchor, const ui.Offset(.5, .5));
    });
  }

  test('source rotation handles north, wrapped headings and other sprites', () {
    expect(VehicleMarkerHelper.sourceRotation('car', 360), 0);
    expect(VehicleMarkerHelper.sourceRotation('taxi', -1), 359);
    expect(VehicleMarkerHelper.sourceRotation('premium', double.nan), 0);
    expect(VehicleMarkerHelper.sourceRotation('bike', 91.4), 0);
    expect(VehicleMarkerHelper.sourceRotation('van', 91.4), 0);
  });

  test('tilt changes the rendered 3D view and preserves the ground anchor', () {
    final source = Marker(
      markerId: const MarkerId('marker#driver#car'),
      position: const LatLng(30, 31),
      rotation: 90,
      icon: VehicleMarkerHelper.getMarker('car', bearing: 90),
    );
    final overhead =
        VehicleMarkerHelper.projectForCamera(source, cameraBearing: 90);
    final tilted = VehicleMarkerHelper.projectForCamera(source,
        cameraBearing: 90, cameraTilt: 60);
    expect((overhead.icon as AssetMapBitmap).assetName,
        const SedanPose(0, 0).assetPath);
    expect((tilted.icon as AssetMapBitmap).assetName,
        const SedanPose(0, 60).assetPath);
    expect(tilted.position, source.position);
    expect(tilted.anchor, const ui.Offset(0.5, 0.5));
    expect(tilted.flat, isFalse);
    expect((tilted.icon as AssetMapBitmap).width, 64);
    expect(
        VehicleMarkerHelper.sedanAssetFor(source,
            cameraBearing: 90, cameraTilt: 60),
        const SedanPose(0, 60).assetPath);
    expect(VehicleMarkerHelper.worldBearingFor(source), 90);
  });

  test(
      'turns take the shortest path through north and resume from visible bearing',
      () {
    expect(SedanPose.turnDelta(359, 1), 2);
    expect(SedanPose.interpolateBearing(359, 1, 0.5), 0);
    expect(SedanPose.turnDelta(1, 359), -2);
    expect(SedanPose.interpolateBearing(1, 359, 0.5), 0);
    final source = Marker(
      markerId: const MarkerId('marker#driver#car'),
      rotation: 173.4,
      icon: VehicleMarkerHelper.getMarker('car', bearing: 173.4),
    );
    expect(VehicleMarkerHelper.worldBearingFor(source), closeTo(173.4, 0.0001));
    expect(
        SedanPose.interpolateBearing(
            VehicleMarkerHelper.worldBearingFor(source)!, 190, 0.5),
        closeTo(181.7, 0.0001));
    final projected = VehicleMarkerHelper.projectForCamera(source,
        cameraBearing: 173.4, cameraTilt: 45);
    expect(projected.rotation, closeTo(0, 0.0001));
  });

  test('tilt clamps safely and sub-frame rotation remains continuous', () {
    expect(SedanPose.tiltFrame(-20), 0);
    expect(SedanPose.tiltFrame(100), 75);
    expect(SedanPose.tiltFrame(double.nan), 0);
    expect(SedanPose.forCamera(0, cameraTilt: 44).tilt, 45);
    const pose = SedanPose(90, 45);
    expect(pose.rotationCorrection(90, 0), closeTo(0, 0.0001));
    expect(pose.rotationCorrection(90.5, 0), greaterThan(0));
    expect(pose.rotationCorrection(89.5, 0), lessThan(0));
  });

  test('camera rotation keeps the car heading relative to the road', () {
    expect(VehicleMarkerHelper.headingFrame(90, cameraBearing: 90), 0);
    expect(VehicleMarkerHelper.headingFrame(0, cameraBearing: 90), 270);
    expect(VehicleMarkerHelper.headingFrame(359, cameraBearing: 1), 357);
    expect(VehicleMarkerHelper.headingFrame(-90), 270);
    expect(VehicleMarkerHelper.headingFrame(720), 0);
    expect(VehicleMarkerHelper.headingFrame(double.nan), 0);
  });

  test('camera projection leaves pickup and drop markers untouched', () {
    const marker = Marker(
      markerId: MarkerId('pick'),
      position: LatLng(30, 31),
      anchor: ui.Offset(0.5, 1),
      rotation: 20,
    );
    expect(VehicleMarkerHelper.projectForCamera(marker, cameraBearing: 90),
        same(marker));
    expect(VehicleMarkerHelper.sedanAssetFor(marker), isNull);
  });

  test('all sedan views are bundled, transparent and contain soft shadow',
      () async {
    for (var tilt = 0; tilt <= SedanPose.maxTilt; tilt += SedanPose.tiltStep) {
      for (var heading = 0; heading < 360; heading += SedanPose.headingStep) {
        final path = SedanPose(heading, tilt).assetPath;
        final bytes = await rootBundle.load(path);
        final codec =
            await ui.instantiateImageCodec(bytes.buffer.asUint8List());
        final image = (await codec.getNextFrame()).image;
        expect(image.width, 192);
        expect(image.height, 192);
        final rgba = (await image.toByteData())!.buffer.asUint8List();
        expect(rgba[3], 0, reason: '$path must have transparent corners');
        var shadowPixels = 0;
        for (var i = 0; i < rgba.length; i += 4) {
          final alpha = rgba[i + 3];
          if (alpha > 8 &&
              alpha < 100 &&
              rgba[i] < 20 &&
              rgba[i + 1] < 20 &&
              rgba[i + 2] < 20) {
            shadowPixels++;
          }
        }
        expect(shadowPixels, greaterThan(50),
            reason: '$path must retain its contact shadow');
        image.dispose();
        codec.dispose();
      }
    }
  });
}
