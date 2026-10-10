import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/features/bookingpage/presentation/page/booking/widget/no_driver_found.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

Widget fixture(
        {bool arabic = false,
        bool dark = false,
        double scale = 1,
        GlobalKey? captureKey}) =>
    MaterialApp(
      locale: Locale(arabic ? 'ar' : 'en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: ThemeData(
          brightness: dark ? Brightness.dark : Brightness.light,
          fontFamily: Platform.environment['NO_DRIVER_PREVIEW_FONT'] == null
              ? null
              : 'NoDriverPreview'),
      home: Builder(
          builder: (context) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(scale)),
                child: Scaffold(
                    body: Column(children: [
                  const Text('Ride preview'),
                  TextButton(
                      onPressed: () => showModalBottomSheet<void>(
                            context: context,
                            isDismissible: false,
                            enableDrag: false,
                            isScrollControlled: true,
                            useSafeArea: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                  textScaler: TextScaler.linear(scale)),
                              child: RepaintBoundary(
                                  key: captureKey,
                                  child: const NoDriverFoundWidget()),
                            ),
                          ),
                      child: const Text('Open')),
                ])),
              )),
    );

void main() {
  void setSize(WidgetTester tester, Size size) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('Back to ride dismisses the sheet and keeps the booking preview',
      (tester) async {
    setSize(tester, const Size(402, 874));
    await tester.pumpWidget(fixture());
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('No drivers nearby'), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('backToRide')));
    await tester.pumpAndSettle();
    expect(find.text('No drivers nearby'), findsNothing);
    expect(find.text('Ride preview'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final arabic in [false, true]) {
    testWidgets(
        'Small screen and large text remain scrollable (${arabic ? 'Arabic dark' : 'English'})',
        (tester) async {
      setSize(tester, const Size(280, 480));
      await tester.pumpWidget(fixture(arabic: arabic, dark: arabic, scale: 2));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.byKey(const ValueKey('backToRide')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('backToRide')));
      await tester.pumpAndSettle();
      expect(find.text('Ride preview'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Compact sheet sizes to its content and exports a preview',
      (tester) async {
    setSize(tester, const Size(402, 874));
    final font = Platform.environment['NO_DRIVER_PREVIEW_FONT'];
    if (font != null) {
      final loader = FontLoader('NoDriverPreview')
        ..addFont(
            Future.value(ByteData.sublistView(File(font).readAsBytesSync())));
      await loader.load();
    }
    final key = GlobalKey();
    await tester.pumpWidget(fixture(captureKey: key));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    final height = tester.getSize(find.byType(NoDriverFoundWidget)).height;
    expect(height, lessThan(550));
    expect(height, greaterThan(300));
    expect(tester.takeException(), isNull);
    final path = Platform.environment['NO_DRIVER_PREVIEW'];
    if (path != null) {
      await tester.runAsync(() async {
        final boundary =
            key.currentContext!.findRenderObject() as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 3);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        await File(path).writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
      });
    }
  });
}
