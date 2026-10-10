import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/features/account/domain/models/history_model.dart';
import 'package:meshwar_user/features/account/presentation/pages/outstation/widget/outstation_history_card.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

HistoryData ride({required bool roundTrip}) => HistoryData.fromJson({
      'id': roundTrip ? 'round' : 'one-way',
      'show_otp_feature': false,
      'completed_ride': false,
      'later_ride': true,
      'cancelled_ride': false,
      'ongoing_ride': false,
      'support_ticket_exists': false,
      'requestProofs': {'data': <dynamic>[]},
      'is_out_station': 1,
      'is_round_trip': roundTrip ? 1 : 0,
      'pick_address': 'Kuwait City, Gulf Road, Building 123',
      'drop_address': 'Salmiya, Kuwait, a longer destination address',
      'offerred_ride_fare': 12.5,
      'requested_currency_symbol': 'KWD',
      'payment_opt': '1',
      'vehicle_type_name': 'Sedan',
      'return_time': roundTrip ? 'Return: 12 Oct, 4:30 PM' : '',
    });

void main() {
  for (final arabic in [false, true]) {
    for (final dark in [false, true]) {
      testWidgets(
          'Outstation fare, assignment, and trip types arabic=$arabic dark=$dark',
          (tester) async {
        tester.view.physicalSize = const Size(280, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final oneWay = ride(roundTrip: false)..driverDetail = Object();
        await tester.pumpWidget(MaterialApp(
          locale: Locale(arabic ? 'ar' : 'en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme:
              ThemeData(brightness: dark ? Brightness.dark : Brightness.light),
          home: Builder(
              builder: (context) => MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: const TextScaler.linear(2)),
                    child: Scaffold(
                        body: SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Column(children: [
                              Material(
                                  child: OutstationHistoryCard(
                                      history: ride(roundTrip: true))),
                              const SizedBox(height: 14),
                              Material(
                                  child:
                                      OutstationHistoryCard(history: oneWay)),
                            ]))),
                  )),
        ));
        await tester.pumpAndSettle();
        final l10n = AppLocalizations.of(
            tester.element(find.byType(OutstationHistoryCard).first))!;
        expect(find.text('KWD 12.5'), findsNWidgets(2));
        expect(find.text(l10n.roundTrip), findsOneWidget);
        expect(find.text(l10n.oneWayTrip), findsOneWidget);
        expect(find.text(l10n.unAssigned), findsOneWidget);
        expect(find.text(l10n.assigned), findsOneWidget);
        expect(find.text(l10n.cash), findsNWidgets(2));
        expect(find.text('Return: 12 Oct, 4:30 PM'), findsOneWidget);
        await tester.ensureVisible(find.text(l10n.assigned));
        expect(tester.takeException(), isNull);
      });
    }
  }
}
