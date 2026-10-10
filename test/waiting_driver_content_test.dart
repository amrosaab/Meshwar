import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/features/bookingpage/presentation/page/booking/widget/waiting_driver_content.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

Widget fixture({
  bool arabic = false,
  bool dark = false,
  double scale = 1,
  int seconds = 208,
  double maximum = 300,
  String? vehicle = 'Taxi',
  VoidCallback? onCancel,
  GlobalKey? captureKey,
}) =>
    MaterialApp(
        locale: Locale(arabic ? 'ar' : 'en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
            brightness: dark ? Brightness.dark : Brightness.light,
            fontFamily: Platform.environment['WAITING_PREVIEW_FONT'] == null
                ? null
                : 'WaitingPreview'),
        home: Builder(
            builder: (context) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(scale)),
                child: Scaffold(
                    body: SingleChildScrollView(
                        child: RepaintBoundary(
                            key: captureKey,
                            child: WaitingDriverContent(
                                remainingSeconds: seconds,
                                maximumSeconds: maximum,
                                vehicleName: vehicle,
                                stops: [
                                  WaitingRideStop(
                                      address: arabic
                                          ? 'ميدان التحرير، وسط البلد، القاهرة، مصر'
                                          : 'Tahrir Sq, Ad Dawawin, Abdeen, Cairo Governorate 4272077, Egypt',
                                      isPickup: true),
                                  WaitingRideStop(
                                      address: arabic
                                          ? 'شارع المعز، القاهرة، مصر'
                                          : 'Al Moez Street, Cairo, Egypt'),
                                  WaitingRideStop(
                                      address: arabic
                                          ? 'مدينة نصر، القاهرة، مصر'
                                          : 'Nasr City, Cairo, Egypt'),
                                ],
                                paymentLabel:
                                    AppLocalizations.of(context)!.cash,
                                paymentIcon: Icons.payments_outlined,
                                onCancel: onCancel ?? () {})))))));

void main() {
  void setSize(WidgetTester tester, Size size) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets(
      'Timer updates safely while stops and cancel action remain available',
      (tester) async {
    setSize(tester, const Size(402, 1000));
    var cancellations = 0;
    await tester.pumpWidget(fixture(onCancel: () => cancellations++));
    expect(find.text('03:28 mins'), findsOneWidget);
    expect(find.text('Nasr City, Cairo, Egypt'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('cancelWaitingRide')));
    expect(cancellations, 1);
    await tester.pumpWidget(fixture(seconds: 207));
    await tester.pumpAndSettle();
    expect(find.text('03:27 mins'), findsOneWidget);
    expect(
        tester
            .widget<LinearProgressIndicator>(
                find.byType(LinearProgressIndicator))
            .value,
        closeTo(207 / 300, .001));
    for (final maximum in [0.0, -1.0, double.nan, double.infinity]) {
      await tester.pumpWidget(fixture(maximum: maximum, vehicle: null));
      await tester.pumpAndSettle();
      expect(
          tester
              .widget<LinearProgressIndicator>(
                  find.byType(LinearProgressIndicator))
              .value,
          0);
      expect(find.text('Ride details'), findsNothing);
      expect(tester.takeException(), isNull);
    }
    await tester.pumpWidget(fixture(seconds: -1));
    await tester.pumpAndSettle();
    expect(find.text('00:00 mins'), findsOneWidget);
    await tester.pumpWidget(fixture(seconds: 3601));
    await tester.pumpAndSettle();
    expect(find.text('01:00:01 mins'), findsOneWidget);
    expect(
        tester
            .widget<LinearProgressIndicator>(
                find.byType(LinearProgressIndicator))
            .value,
        1);
    expect(tester.takeException(), isNull);
  });

  for (final arabic in [false, true]) {
    for (final dark in [false, true]) {
      testWidgets('Small screen and large text arabic=$arabic dark=$dark',
          (tester) async {
        setSize(tester, const Size(320, 700));
        var cancellations = 0;
        await tester.pumpWidget(fixture(
            arabic: arabic,
            dark: dark,
            scale: 1.8,
            vehicle: 'A vehicle category with a longer name',
            onCancel: () => cancellations++));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final cancel = find.byKey(const ValueKey('cancelWaitingRide'));
        await tester.ensureVisible(cancel);
        await tester.tap(cancel);
        expect(cancellations, 1);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('Render driver search screen for visual review', (tester) async {
    setSize(tester, const Size(402, 1100));
    final fontPath = Platform.environment['WAITING_PREVIEW_FONT'];
    if (fontPath != null) {
      await tester.runAsync(() async {
        final font = FontLoader('WaitingPreview')
          ..addFont(File(fontPath).readAsBytes().then(ByteData.sublistView));
        await font.load();
        final icons = FontLoader('MaterialIcons')
          ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
        await icons.load();
      });
    }
    final key = GlobalKey();
    await tester.pumpWidget(fixture(captureKey: key));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final preview = Platform.environment['WAITING_PREVIEW'];
    if (preview != null) {
      await tester.runAsync(() async {
        final boundary =
            key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 3);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        await File(preview).writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
      });
    }
  });
}
