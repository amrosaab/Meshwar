import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/features/account/presentation/pages/history/widget/history_detail_widgets.dart';
import 'package:meshwar_user/features/account/presentation/pages/history/widget/history_fare_content.dart';
import 'package:meshwar_user/features/account/presentation/pages/history/widget/history_trip_summary_content.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

Widget fixture({
  required bool arabic,
  required bool dark,
  required VoidCallback onInvoice,
}) =>
    MaterialApp(
      locale: Locale(arabic ? 'ar' : 'en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: ThemeData(brightness: dark ? Brightness.dark : Brightness.light),
      home: Builder(
          builder: (context) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(2)),
                child: Scaffold(
                  body: ListView(padding: const EdgeInsets.all(20), children: [
                    const HistoryFareContent(
                      lines: [
                        HistoryFareLine('Distance Price (KWD 12.5 x 123.45 KM)',
                            'KWD 1234.567'),
                        HistoryFareLine(
                            'A longer additional charge description',
                            'KWD 48.000'),
                      ],
                      payment: 'Cash',
                      total: 'KWD 1282.567',
                    ),
                    HistoryTripSummaryContent(
                      driverName: arabic
                          ? 'اسم السائق لرحلة سابقة'
                          : 'Driver with a longer name',
                      stops: [
                        HistoryTripStop(
                            label: arabic ? 'الانطلاق' : 'Pickup',
                            address: arabic
                                ? 'ميدان التحرير، عابدين، محافظة القاهرة، مصر'
                                : 'Tahrir Sq, Ad Dawawin, Abdeen, Cairo Governorate 4272077, Egypt',
                            isPickup: true,
                            time: '09:30 PM'),
                        const HistoryTripStop(
                            label: 'Stop 1',
                            isIntermediate: true,
                            address:
                                'A long intermediate stop address that must remain readable.'),
                        const HistoryTripStop(
                            label: 'Drop',
                            address: 'Cairo Festival City, Nasr City, Egypt'),
                      ],
                    ),
                  ]),
                  bottomNavigationBar: SafeArea(
                    minimum: const EdgeInsets.all(20),
                    child: HistoryDetailButton(
                      label: AppLocalizations.of(context)!.downloadInvoice,
                      icon: Icons.download_rounded,
                      onPressed: onInvoice,
                    ),
                  ),
                ),
              )),
    );

void main() {
  for (final arabic in [false, true]) {
    for (final dark in [false, true]) {
      testWidgets('Ride details support large text arabic=$arabic dark=$dark',
          (tester) async {
        tester.view.physicalSize = const Size(280, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        var downloads = 0;
        await tester.pumpWidget(
            fixture(arabic: arabic, dark: dark, onInvoice: () => downloads++));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('KWD 1282.567'), findsOneWidget);
        final stop = find.text('Cairo Festival City, Nasr City, Egypt');
        await tester.scrollUntilVisible(stop, 300,
            scrollable: find.byType(Scrollable).first);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(find.byType(FilledButton));
        expect(downloads, 1);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
