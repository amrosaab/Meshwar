import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/features/bookingpage/presentation/page/booking/widget/on_ride/cancel_reason_content.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

Widget fixture(
        {required TextEditingController other,
        bool arabic = false,
        bool dark = false,
        double scale = 1,
        String selected = '',
        bool custom = false,
        ValueChanged<CancelReasonOption>? onSelect,
        ValueChanged<String>? onOther,
        VoidCallback? onBack,
        VoidCallback? onCancel,
        GlobalKey? captureKey}) =>
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
          builder: (context) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(scale)),
              child: RepaintBoundary(
                  key: captureKey,
                  child: CancelReasonContent(
                    reasons: [
                      CancelReasonOption(
                          id: '1',
                          title: arabic
                              ? 'السائق يستغرق وقتاً طويلاً للوصول'
                              : 'Driver taking too long'),
                      CancelReasonOption(
                          id: '2',
                          title: arabic
                              ? 'لا أريد ذكر السبب'
                              : 'Do not want to say'),
                    ],
                    selectedId: selected,
                    isCustom: custom,
                    otherController: other,
                    onSelect: onSelect ?? (_) {},
                    onOtherChanged: onOther ?? (_) {},
                    onBack: onBack ?? () {},
                    onCancel: onCancel ?? () {},
                  )))),
    );

void main() {
  late TextEditingController other;
  setUp(() => other = TextEditingController());
  tearDown(() => other.dispose());

  testWidgets(
      'Selection alone never cancels; a valid choice enables the explicit action',
      (tester) async {
    var cancelled = 0;
    var backed = 0;
    String? chosen;
    await tester.pumpWidget(fixture(
        other: other,
        onCancel: () => cancelled++,
        onSelect: (reason) => chosen = reason.id));
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull);
    await tester.tap(find.text('Driver taking too long'));
    expect(chosen, '1');
    expect(cancelled, 0);
    await tester.pumpWidget(fixture(
        other: other,
        selected: '1',
        onCancel: () => cancelled++,
        onBack: () => backed++));
    await tester.tap(find.byType(FilledButton));
    expect(cancelled, 1);
    await tester.tap(find.widgetWithText(TextButton, 'Back'));
    expect(backed, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Custom cancellation requires meaningful text', (tester) async {
    var cancelled = 0;
    String? changed;
    await tester.pumpWidget(fixture(
        other: other,
        custom: true,
        onOther: (value) => changed = value,
        onCancel: () => cancelled++));
    await tester.enterText(find.byType(TextField), '   ');
    await tester.pump();
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull);
    await tester.enterText(find.byType(TextField), 'Plans have changed.');
    await tester.pump();
    expect(changed, 'Plans have changed.');
    await tester.tap(find.byType(FilledButton));
    expect(cancelled, 1);
    expect(tester.takeException(), isNull);
  });

  for (final arabic in [false, true]) {
    for (final dark in [false, true]) {
      testWidgets(
          'Narrow screen, large text and keyboard: ar=$arabic dark=$dark',
          (tester) async {
        tester.view.physicalSize = const Size(320, 800);
        tester.view.devicePixelRatio = 1;
        tester.view.padding = const FakeViewPadding(bottom: 34);
        tester.view.viewInsets = const FakeViewPadding(bottom: 280);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPadding);
        addTearDown(tester.view.resetViewInsets);
        await tester.pumpWidget(fixture(
            other: other,
            arabic: arabic,
            dark: dark,
            scale: 1.8,
            selected: '1'));
        await tester.scrollUntilVisible(find.byType(TextField), 150,
            scrollable: find.byType(Scrollable).first);
        await tester.enterText(
            find.byType(TextField), 'Other reason\nWith additional details');
        await tester.pumpAndSettle();
        expect(tester.getRect(find.byType(FilledButton)).bottom,
            lessThanOrEqualTo(520));
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('Render cancellation design for review', (tester) async {
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1;
    tester.view.padding = const FakeViewPadding(top: 59, bottom: 34);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPadding);
    final fontPath = Platform.environment['CANCEL_PREVIEW_FONT'];
    if (fontPath != null) {
      await tester.runAsync(() async {
        final font = FontLoader('CancelPreview')
          ..addFont(File(fontPath)
              .readAsBytes()
              .then((bytes) => ByteData.sublistView(bytes)));
        await font.load();
        final icons = FontLoader('MaterialIcons')
          ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
        await icons.load();
      });
    }
    final key = GlobalKey();
    await tester
        .pumpWidget(fixture(other: other, selected: '1', captureKey: key));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final path = Platform.environment['CANCEL_PREVIEW'];
    if (path != null) {
      await tester.runAsync(() async {
        final boundary =
            key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 3);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        await File(path).writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
      });
    }
  });
}
