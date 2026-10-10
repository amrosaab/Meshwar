import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/features/bookingpage/presentation/page/booking/widget/cancel_ride_confirmation_content.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

Widget fixture({
  bool arabic = false,
  bool dark = false,
  double scale = 1,
  GlobalKey? captureKey,
  required VoidCallback onCancel,
}) =>
    MaterialApp(
      locale: Locale(arabic ? 'ar' : 'en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: ThemeData(
          brightness: dark ? Brightness.dark : Brightness.light,
          fontFamily: Platform.environment['CANCEL_PREVIEW_FONT'] == null
              ? null
              : 'CancelPreview'),
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              enableDrag: false,
              backgroundColor: Colors.transparent,
              builder: (sheetContext) => MediaQuery(
                data: MediaQuery.of(sheetContext)
                    .copyWith(textScaler: TextScaler.linear(scale)),
                child: RepaintBoundary(
                    key: captureKey,
                    child: CancelRideConfirmationContent(
                      onKeepRide: () => Navigator.pop(sheetContext),
                      onCancelRide: onCancel,
                    )),
              ),
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    );

void main() {
  void setSize(WidgetTester tester, Size size) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('Keep searching dismisses without cancelling the request',
      (tester) async {
    setSize(tester, const Size(402, 874));
    final fontPath = Platform.environment['CANCEL_PREVIEW_FONT'];
    if (fontPath != null) {
      await tester.runAsync(() async {
        final font = FontLoader('CancelPreview')
          ..addFont(File(fontPath).readAsBytes().then(ByteData.sublistView));
        await font.load();
        final icons = FontLoader('MaterialIcons')
          ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
        await icons.load();
      });
    }
    final captureKey = GlobalKey();
    var cancellations = 0;
    await tester.pumpWidget(
        fixture(captureKey: captureKey, onCancel: () => cancellations++));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(cancellations, 0);
    expect(tester.getSize(find.byType(CancelRideConfirmationContent)).height,
        lessThan(550));
    final preview = Platform.environment['CANCEL_PREVIEW'];
    if (preview != null) {
      await tester.runAsync(() => precacheImage(
          const AssetImage('assets/sedan_sprites/tilt_45_heading_225.png'),
          tester.element(find.byType(CancelRideConfirmationContent))));
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        final boundary = captureKey.currentContext!.findRenderObject()
            as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 3);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        await File(preview).writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
      });
    }
    await tester.tap(find.byKey(const ValueKey('keepSearching')));
    await tester.pumpAndSettle();
    expect(find.byType(CancelRideConfirmationContent), findsNothing);
    expect(cancellations, 0);
  });

  testWidgets('Cancel ride calls only the supplied cancellation action',
      (tester) async {
    setSize(tester, const Size(402, 874));
    var cancellations = 0;
    await tester.pumpWidget(fixture(onCancel: () => cancellations++));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(cancellations, 0);
    await tester.tap(find.byKey(const ValueKey('confirmCancelRide')));
    expect(cancellations, 1);
    expect(tester.takeException(), isNull);
  });

  for (final arabic in [false, true]) {
    testWidgets('Small screen and large text: Arabic dark=$arabic',
        (tester) async {
      setSize(tester, const Size(280, 480));
      var cancellations = 0;
      await tester.pumpWidget(fixture(
          arabic: arabic,
          dark: arabic,
          scale: 2,
          onCancel: () => cancellations++));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final cancel = find.byKey(const ValueKey('confirmCancelRide'));
      await tester.ensureVisible(cancel);
      await tester.pumpAndSettle();
      await tester.tap(cancel);
      expect(cancellations, 1);
      expect(tester.takeException(), isNull);
    });
  }
}
