import 'dart:ui' as ui;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/features/bookingpage/presentation/page/booking/widget/driver_search_field.dart';

Widget field(
        {required GlobalKey key,
        bool reducedMotion = false,
        ui.Image? mapImage,
        bool distortMap = true,
        Offset center = const Offset(160, 180),
        VoidCallback? onTap}) =>
    MaterialApp(
        home: MediaQuery(
            data: MediaQueryData(disableAnimations: reducedMotion),
            child: Scaffold(
                body: RepaintBoundary(
                    key: key,
                    child: Stack(children: [
                      Positioned.fill(
                          child: GestureDetector(
                              onTap: onTap,
                              behavior: HitTestBehavior.opaque,
                              child: mapImage == null
                                  ? null
                                  : RawImage(
                                      image: mapImage, fit: BoxFit.fill))),
                      Positioned.fill(
                          child: DriverSearchField(
                              center: center,
                              mapImage: distortMap ? mapImage : null)),
                    ])))));

Future<List<int>> pixels(WidgetTester tester, GlobalKey key) async {
  return (await tester.runAsync(() async {
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    image.dispose();
    return bytes!.buffer.asUint8List().toList();
  }))!;
}

void main() {
  testWidgets(
      'Search field animates independently and leaves map gestures available',
      (tester) async {
    var taps = 0;
    final key = GlobalKey();
    await tester.pumpWidget(field(key: key, onTap: () => taps++));
    await tester.pump(const Duration(milliseconds: 600));
    final before = await pixels(tester, key);
    await tester.pump(const Duration(milliseconds: 900));
    final after = await pixels(tester, key);
    expect(after, isNot(equals(before)));
    await tester.tapAt(const Offset(160, 180));
    expect(taps, 1);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 5));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Reduced motion stays still and anchor changes move the field',
      (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(field(key: key, reducedMotion: true));
    await tester.pump();
    final before = await pixels(tester, key);
    await tester.pump(const Duration(seconds: 2));
    expect(await pixels(tester, key), equals(before));
    await tester.pumpWidget(
        field(key: key, reducedMotion: true, center: const Offset(260, 100)));
    await tester.pump();
    expect(await pixels(tester, key), isNot(equals(before)));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'Map streets distort inside the field and remain unchanged outside',
      (tester) async {
    tester.view.physicalSize = const Size(402, 560);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final map = (await tester.runAsync(() async {
      await ui.FragmentProgram.fromAsset('shaders/driver_search_absorb.frag');
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.drawRect(const Rect.fromLTWH(0, 0, 402, 560),
          Paint()..color = const Color(0xFFE8E9ED));
      for (var x = -30.0; x < 430; x += 55) {
        canvas.drawLine(
            Offset(x, 0),
            Offset(x + 130, 560),
            Paint()
              ..color = Colors.white
              ..strokeWidth = 8);
      }
      for (var y = 0.0; y < 560; y += 55) {
        canvas.drawLine(
            Offset(0, y),
            Offset(402, y - 85),
            Paint()
              ..color = Colors.white
              ..strokeWidth = 8);
      }
      canvas.drawPath(
          Path()
            ..moveTo(50, 0)
            ..cubicTo(10, 160, 95, 300, 35, 560),
          Paint()
            ..color = const Color(0xFFAED6ED)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 42);
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              const Rect.fromLTWH(290, 50, 75, 95), const Radius.circular(12)),
          Paint()..color = const Color(0xFFCBDEC4));
      final picture = recorder.endRecording();
      final image = picture.toImageSync(402, 560);
      picture.dispose();
      return image;
    }))!;
    final key = GlobalKey();
    const center = Offset(201, 270);
    await tester.pumpWidget(
        field(key: key, center: center, mapImage: map, distortMap: false));
    await tester.pump(const Duration(milliseconds: 600));
    final before = await pixels(tester, key);
    await tester.pumpWidget(field(key: key, center: center, mapImage: map));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump();
    final after = await pixels(tester, key);
    var changedInside = 0;
    var changedOutside = 0;
    for (var y = 0; y < 560; y++) {
      for (var x = 0; x < 402; x++) {
        final offset = (y * 402 + x) * 4;
        final radius = (Offset(x.toDouble(), y.toDouble()) - center).distance;
        if (radius > 180) {
          if (after[offset] != before[offset] ||
              after[offset + 1] != before[offset + 1] ||
              after[offset + 2] != before[offset + 2] ||
              after[offset + 3] != before[offset + 3]) {
            changedOutside++;
          }
        } else if (radius > 30 &&
            radius < 140 &&
            after[offset] != before[offset]) {
          changedInside++;
        }
      }
    }
    expect(changedOutside, 0);
    expect(changedInside, greaterThan(1000));
    expect(tester.takeException(), isNull);
    final previewDir = Platform.environment['SEARCH_MOTION_FRAMES'];
    if (previewDir != null) {
      await tester
          .runAsync(() => Directory(previewDir).create(recursive: true));
      for (var frame = 0; frame < 72; frame++) {
        await tester.pump(const Duration(milliseconds: 50));
        await tester.runAsync(() async {
          final boundary =
              key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
          final image = await boundary.toImage(pixelRatio: 2);
          final png = await image.toByteData(format: ui.ImageByteFormat.png);
          await File('$previewDir/${frame.toString().padLeft(3, '0')}.png')
              .writeAsBytes(png!.buffer.asUint8List());
          image.dispose();
        });
      }
    }
    await tester.pumpWidget(const SizedBox());
    map.dispose();
  }, timeout: const Timeout(Duration(minutes: 2)));
}
