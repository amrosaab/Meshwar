import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/features/bookingpage/presentation/page/booking/widget/on_ride/ride_chat_content.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

List<RideChatMessage> sampleMessages({bool arabic = false}) => [
      RideChatMessage(
          id: '1',
          isMine: false,
          timestamp: '12:41',
          text: arabic
              ? 'مرحباً، أنا في الطريق إلى نقطة الالتقاء.'
              : 'Hi! I’m on my way to your pickup point.'),
      RideChatMessage(
          id: '2',
          isMine: true,
          timestamp: '12:42',
          seen: true,
          text: arabic
              ? 'شكراً، سأنتظرك عند المدخل الرئيسي.'
              : 'Thanks! I’ll wait by the main entrance.'),
      RideChatMessage(
          id: '3',
          isMine: false,
          timestamp: '12:42',
          text: arabic
              ? 'تمام، سأصل خلال دقيقتين.'
              : 'Perfect, I’ll be there in 2 minutes.'),
      RideChatMessage(
          id: '4',
          isMine: true,
          timestamp: '12:43',
          delivered: true,
          text:
              arabic ? 'أنا أرتدي قميصاً أزرق.' : 'I’m wearing a blue shirt.'),
    ];

Widget fixture(
        {required TextEditingController input,
        required ScrollController scroll,
        List<RideChatMessage>? messages,
        bool arabic = false,
        bool dark = false,
        double scale = 1,
        ValueChanged<String>? onSend,
        VoidCallback? onBack,
        VoidCallback? onCall,
        GlobalKey? captureKey}) =>
    MaterialApp(
      locale: Locale(arabic ? 'ar' : 'en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: ThemeData(
          brightness: dark ? Brightness.dark : Brightness.light,
          fontFamily: Platform.environment['CHAT_PREVIEW_FONT'] == null
              ? null
              : 'ChatPreview'),
      home: Builder(
          builder: (context) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(scale)),
              child: RepaintBoundary(
                  key: captureKey,
                  child: RideChatContent(
                    driverName:
                        arabic ? 'أحمد محمد عبد الرحمن' : 'Ahmed Mohamed',
                    avatarUrl: '',
                    vehicleName: 'Toyota Corolla',
                    vehiclePlate: '123213',
                    messages: messages ?? sampleMessages(arabic: arabic),
                    inputController: input,
                    scrollController: scroll,
                    onBack: onBack ?? () {},
                    onCall: onCall ?? () {},
                    onSend: onSend ?? (_) {},
                  )))),
    );

void main() {
  late TextEditingController input;
  late ScrollController scroll;
  setUp(() {
    input = TextEditingController();
    scroll = ScrollController();
  });
  tearDown(() {
    input.dispose();
    scroll.dispose();
  });

  testWidgets(
      'Whitespace cannot send; send trims text and retains header actions',
      (tester) async {
    final calls = <String>[];
    await tester.pumpWidget(fixture(
        input: input,
        scroll: scroll,
        onSend: calls.add,
        onBack: () => calls.add('back'),
        onCall: () => calls.add('call')));
    await tester.enterText(find.byType(TextField), '   ');
    await tester.pump();
    await tester.tap(find.byTooltip('Send'));
    expect(calls, isEmpty);
    await tester.enterText(find.byType(TextField), '  I’m at the entrance.  ');
    await tester.pump();
    await tester.tap(find.byTooltip('Send'));
    expect(calls, ['I’m at the entrance.']);
    expect(input.text, isEmpty);
    await tester.tap(find.byTooltip('Back'));
    await tester.tap(find.byTooltip('Call'));
    expect(calls, ['I’m at the entrance.', 'back', 'call']);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Receipt refresh preserves the position while reading history',
      (tester) async {
    final messages = List.generate(
        30,
        (i) => RideChatMessage(
            id: '$i',
            text: 'Message $i with pickup details.',
            timestamp: '12:42',
            isMine: i.isEven));
    await tester
        .pumpWidget(fixture(input: input, scroll: scroll, messages: messages));
    scroll.jumpTo(350);
    await tester.pump();
    final before = scroll.offset;
    final updated = [
      for (final message in messages)
        RideChatMessage(
            id: message.id,
            text: message.text,
            timestamp: message.timestamp,
            isMine: message.isMine,
            delivered: true,
            seen: true)
    ];
    await tester
        .pumpWidget(fixture(input: input, scroll: scroll, messages: updated));
    await tester.pumpAndSettle();
    expect(scroll.offset, before);
    expect(tester.takeException(), isNull);
  });

  for (final arabic in [false, true]) {
    for (final dark in [false, true]) {
      testWidgets(
          'Fits a narrow screen with large text and keyboard: ar=$arabic dark=$dark',
          (tester) async {
        tester.view.physicalSize = const Size(320, 800);
        tester.view.devicePixelRatio = 1;
        tester.view.padding = const FakeViewPadding(bottom: 34);
        tester.view.viewInsets = const FakeViewPadding(bottom: 260);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPadding);
        addTearDown(tester.view.resetViewInsets);
        await tester.pumpWidget(fixture(
            input: input,
            scroll: scroll,
            arabic: arabic,
            dark: dark,
            scale: 1.8));
        await tester.enterText(find.byType(TextField),
            'First line\nSecond line\nThird line\nFourth line');
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final composer = tester.getRect(find.byType(TextField));
        expect(composer.bottom, lessThanOrEqualTo(800 - 260));
        await tester.pumpWidget(fixture(
            input: input,
            scroll: scroll,
            arabic: arabic,
            dark: dark,
            scale: 1.8,
            messages: const []));
        expect(tester.takeException(), isNull);
        expect(find.text(arabic ? 'لا توجد رسائل هنا' : 'No Messages Here'),
            findsOneWidget);
      });
    }
  }

  testWidgets('Render the redesigned chat for review', (tester) async {
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1;
    tester.view.padding = const FakeViewPadding(top: 59, bottom: 34);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPadding);
    final fontPath = Platform.environment['CHAT_PREVIEW_FONT'];
    if (fontPath != null) {
      await tester.runAsync(() async {
        final font = FontLoader('ChatPreview')
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
        .pumpWidget(fixture(input: input, scroll: scroll, captureKey: key));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final path = Platform.environment['CHAT_PREVIEW'];
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
