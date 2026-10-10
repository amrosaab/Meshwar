import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/features/bookingpage/presentation/page/booking/widget/on_ride/ride_sheet_content.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

Widget fixture(
    {bool arabic = false,
    bool dark = false,
    double scale = 1,
    bool extras = false,
    VoidCallback? onMessage,
    VoidCallback? onCall,
    VoidCallback? onShare,
    VoidCallback? onEdit,
    VoidCallback? onPay,
    VoidCallback? onCancel,
    GlobalKey? captureKey}) {
  return MaterialApp(
    locale: Locale(arabic ? 'ar' : 'en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: ThemeData(
      brightness: dark ? Brightness.dark : Brightness.light,
      fontFamily: Platform.environment['RIDE_SHEET_FONT'] != null
          ? 'RidePreview'
          : null,
    ),
    home: Builder(builder: (context) {
      final l10n = AppLocalizations.of(context)!;
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(scale)),
        child: Scaffold(
            body: SingleChildScrollView(
                child: RepaintBoundary(
          key: captureKey,
          child: RideSheetContent(
            status: extras ? l10n.driverArrived : l10n.onTheWay,
            statusIcon: Icons.directions_car_rounded,
            subtitle: extras
                ? l10n.driverArrivedLocation
                : l10n.driverArriveText.replaceAll('**', '136'),
            eta: extras ? null : '136',
            otp: extras ? '4281' : null,
            waiting: extras ? '03:24' : null,
            stops: [
              RideSheetStop(
                  label: l10n.pickup,
                  address:
                      'Tahrir Sq, Ad Dawawin, Abdeen, Cairo Governorate 4272077, Egypt',
                  isPickup: true),
              if (extras)
                RideSheetStop(
                    label: l10n.drop,
                    address:
                        'An additional delivery stop with a longer address',
                    instruction: 'Please ring the bell at the entrance.',
                    onEdit: onEdit),
              RideSheetStop(
                  label: l10n.drop,
                  address:
                      'Tahrir Sq, Ad Dawawin, Abdeen, Cairo Governorate 4272077, Egypt',
                  onEdit: onEdit),
            ],
            driverName: arabic ? 'أحمد محمد عبد الرحمن' : 'driver test',
            avatarUrl: '',
            rating: '5',
            completedRides: 2,
            vehicleName: 'Toyota Corolla',
            vehicleColor: 'Black',
            vehiclePlate: '123213',
            fareLabel: l10n.rideFare,
            fare: '\$ 94',
            paymentLabel: l10n.cash,
            paymentIcon: Icons.payments_outlined,
            hasUnreadMessages: true,
            extraChargeLabel: extras ? 'Additional waiting charge' : '',
            extraCharge: extras ? '+ \$ 12' : '',
            onMessage: onMessage ?? () {},
            onCall: onCall ?? () {},
            onShare: onShare ?? () {},
            onPay: onPay,
            onCancel: onCancel ?? () {},
          ),
        ))),
      );
    }),
  );
}

void main() {
  testWidgets('Contact and cancellation actions reach their handlers',
      (tester) async {
    tester.view.physicalSize = const Size(430, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final calls = <String>[];
    await tester.pumpWidget(fixture(
        onMessage: () => calls.add('message'),
        onCall: () => calls.add('call'),
        onShare: () => calls.add('share'),
        onCancel: () => calls.add('cancel')));
    await tester.tap(find.text('Message'));
    await tester.tap(find.text('Call'));
    await tester.tap(find.text('Share ride'));
    await tester.tap(find.text('Cancel Ride'));
    expect(calls, ['message', 'call', 'share', 'cancel']);
    expect(tester.takeException(), isNull);
  });

  for (final arabic in [false, true]) {
    for (final dark in [false, true]) {
      testWidgets('No overflow at 320px, large text, arabic=$arabic dark=$dark',
          (tester) async {
        tester.view.physicalSize = const Size(320, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester
            .pumpWidget(fixture(arabic: arabic, dark: dark, scale: 1.8));
        expect(tester.takeException(), isNull);
        var edits = 0;
        var payments = 0;
        await tester.pumpWidget(fixture(
            arabic: arabic,
            dark: dark,
            scale: 1.8,
            extras: true,
            onEdit: () => edits++,
            onPay: () => payments++));
        expect(tester.takeException(), isNull);
        expect(find.text('OTP  4281'), findsOneWidget);
        expect(find.text('03:24 ${arabic ? 'دقائق' : 'mins'}'), findsOneWidget);
        await tester.ensureVisible(find.byIcon(Icons.edit_outlined).first);
        await tester.tap(find.byIcon(Icons.edit_outlined).first);
        await tester.ensureVisible(find.byType(FilledButton));
        await tester.tap(find.byType(FilledButton));
        expect(edits, 1);
        expect(payments, 1);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('Render the redesigned sheet for visual review', (tester) async {
    tester.view.physicalSize = const Size(402, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final fontPath = Platform.environment['RIDE_SHEET_FONT'];
    if (fontPath != null) {
      await tester.runAsync(() async {
        final font = FontLoader('RidePreview')
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
    await tester.pumpWidget(fixture(captureKey: key));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    // Optional artifact output; ordinary test runs do not write preview files.
    final path = Platform.environment['RIDE_SHEET_PREVIEW'];
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
