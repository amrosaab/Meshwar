import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/common/app_arguments.dart';
import 'package:meshwar_user/features/account/application/acc_bloc.dart';
import 'package:meshwar_user/features/account/presentation/pages/history/page/history_page.dart';
import 'package:meshwar_user/features/home/domain/models/user_details_model.dart';
import 'package:meshwar_user/features/account/presentation/pages/history/widget/history_filter_tabs.dart';
import 'package:meshwar_user/features/account/presentation/pages/history/widget/history_nodata.dart';
import 'package:meshwar_user/features/account/presentation/pages/history/widget/history_ride_card.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

class _HistoryPreviewBloc extends AccBloc {
  @override
  Future<void> getDirection(AccEvent event, Emitter<AccState> emit) async {}

  @override
  Future<void> historyInitEvent(
      HistoryPageInitEvent event, Emitter<AccState> emit) async {}
}

class _User extends Fake implements UserDetail {}

Widget fixture({
  bool arabic = false,
  bool dark = false,
  double scale = 1,
  required Widget child,
}) =>
    MaterialApp(
      locale: Locale(arabic ? 'ar' : 'en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: ThemeData(brightness: dark ? Brightness.dark : Brightness.light),
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(scale)),
          child: Scaffold(body: child),
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

  testWidgets('Mounted history follows locale instead of cached bloc direction',
      (tester) async {
    setSize(tester, const Size(402, 874));
    final bloc = _HistoryPreviewBloc();
    addTearDown(bloc.close);
    final page = BlocProvider<AccBloc>.value(
      value: bloc,
      child: HistoryPage(
        arg: HistoryPageArguments(
            isSupportTicketEnabled: '0', userData: _User()),
      ),
    );
    for (final arabic in [false, true, false]) {
      // Deliberately keep the cached setting opposite to the active locale.
      bloc.textDirection = arabic ? 'ltr' : 'rtl';
      await tester.pumpWidget(fixture(arabic: arabic, child: page));
      await tester.pumpAndSettle();
      final context = tester.element(find.byType(HistoryFilterTabs));
      expect(Directionality.of(context),
          arabic ? TextDirection.rtl : TextDirection.ltr);
      final first =
          tester.getCenter(find.byKey(const ValueKey('historyFilter0')));
      final last =
          tester.getCenter(find.byKey(const ValueKey('historyFilter2')));
      expect(first.dx > last.dx, arabic);
      final title = find.text(AppLocalizations.of(context)!.history);
      final badge = find.descendant(
          of: find.byType(AppBar), matching: find.byIcon(Icons.history_rounded));
      expect(tester.getCenter(badge).dx > tester.getCenter(title).dx, arabic);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets(
      'Arabic ride card mirrors route and arrow, preserves numeric order',
      (tester) async {
    setSize(tester, const Size(402, 874));
    await tester.pumpWidget(fixture(
      arabic: true,
      child: const Padding(
        padding: EdgeInsets.all(20),
        child: HistoryRideCard(
          date: '12th Sep 09:31 PM',
          fare: r'$ 48',
          pickup: 'ميدان التحرير',
          drop: 'مدينة نصر',
          pickupTime: '09:30 PM',
          dropTime: '09:31 PM',
          vehicle: 'Taxi',
          status: HistoryRideStatus.completed,
          statusLabel: 'المكتملة',
        ),
      ),
    ));
    await tester.pumpAndSettle();
    for (final entry in {
      Icons.my_location_rounded: 'ميدان التحرير',
      Icons.location_on_rounded: 'مدينة نصر',
      Icons.directions_car_rounded: 'Taxi',
    }.entries) {
      expect(tester.getCenter(find.byIcon(entry.key)).dx,
          greaterThan(tester.getCenter(find.text(entry.value)).dx));
    }
    expect(find.byIcon(Icons.chevron_right_rounded), findsNothing);
    expect(tester.getCenter(find.byIcon(Icons.chevron_left_rounded)).dx,
        lessThan(tester.getCenter(find.text('Taxi')).dx));
    for (final value in [
      '12th Sep 09:31 PM',
      r'$ 48',
      '09:30 PM',
      '09:31 PM'
    ]) {
      expect(tester.widget<Text>(find.text(value)).textDirection,
          TextDirection.ltr);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('Filters select another category and block changes while loading',
      (tester) async {
    setSize(tester, const Size(402, 874));
    var selected = 0;
    var changes = 0;
    await tester.pumpWidget(fixture(
      child: StatefulBuilder(builder: (context, setState) {
        return HistoryFilterTabs(
          selectedIndex: selected,
          onSelected: (index) => setState(() {
            selected = index;
            changes++;
          }),
        );
      }),
    ));
    await tester.tap(find.byKey(const ValueKey('historyFilter1')));
    await tester.pumpAndSettle();
    expect(selected, 1);
    expect(changes, 1);
    await tester.tap(find.byKey(const ValueKey('historyFilter1')));
    expect(changes, 1);
    await tester.pumpWidget(fixture(
        child: HistoryFilterTabs(
            selectedIndex: 1, isLoading: true, onSelected: (_) => changes++)));
    await tester.tap(find.byKey(const ValueKey('historyFilter2')));
    expect(changes, 1);
  });

  for (final arabic in [false, true]) {
    for (final dark in [false, true]) {
      testWidgets('Cards and filters fit large text arabic=$arabic dark=$dark',
          (tester) async {
        setSize(tester, const Size(280, 600));
        var taps = 0;
        final address = arabic
            ? 'ميدان التحرير، عابدين، محافظة القاهرة، جمهورية مصر العربية'
            : 'Tahrir Sq, Ad Dawawin, Abdeen, Cairo Governorate 4272077, Egypt';
        await tester.pumpWidget(fixture(
          arabic: arabic,
          dark: dark,
          scale: 2,
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                HistoryFilterTabs(selectedIndex: 0, onSelected: (_) {}),
                for (final status in HistoryRideStatus.values)
                  Material(
                    child: InkWell(
                      onTap: () => taps++,
                      child: HistoryRideCard(
                        date: '12th Sep 09:31 PM',
                        fare: 'KWD 1234.567',
                        pickup: address,
                        drop: address,
                        pickupTime: '09:30 PM',
                        dropTime: '09:31 PM',
                        vehicle: 'A longer vehicle category name',
                        carColor: 'Black',
                        status: status,
                        statusLabel: status == HistoryRideStatus.upcoming
                            ? 'Rental package for a round trip'
                            : status.name,
                        tripType: 'Round trip',
                        returnTime: 'Return: 14th Sep 11:00 PM',
                      ),
                    ),
                  ),
              ])),
        ));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('KWD 1234.567'), findsNWidgets(3));
        expect(find.text(address), findsNWidgets(6));
        final cancelled = find.text('cancelled');
        await tester.ensureVisible(cancelled);
        await tester.pumpAndSettle();
        await tester.tap(cancelled);
        expect(taps, 1);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('Empty history scrolls on small screens with large Arabic text',
      (tester) async {
    setSize(tester, const Size(280, 480));
    await tester.pumpWidget(fixture(
      arabic: true,
      dark: true,
      scale: 2,
      child: const CustomScrollView(slivers: [
        SliverFillRemaining(hasScrollBody: false, child: HistoryNodataWidget()),
      ]),
    ));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(FilledButton), findsNothing);
  });
}
