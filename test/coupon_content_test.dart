import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/features/account/presentation/pages/coupon_list/widget/coupon_content.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

void main() {
  for (final arabic in [false, true]) {
    for (final dark in [false, true]) {
      testWidgets('Coupon terms, apply, and remove arabic=$arabic dark=$dark',
          (tester) async {
        tester.view.physicalSize = const Size(280, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        var applies = 0;
        var removes = 0;
        var busy = false;
        final terms = arabic
            ? 'استخدم رمز الخصم لتوفير مبلغ على الرحلات التي تزيد قيمتها عن الحد الأدنى المحدد.'
            : 'Use this coupon to save on bookings above the minimum trip amount, subject to the stated offer conditions.';
        await tester.pumpWidget(MaterialApp(
          locale: Locale(arabic ? 'ar' : 'en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme:
              ThemeData(brightness: dark ? Brightness.dark : Brightness.light),
          home: StatefulBuilder(
              builder: (context, setState) => MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: const TextScaler.linear(2)),
                    child: Scaffold(
                        body: SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Column(children: [
                              CouponOfferCard(
                                  code: 'SAVE123456789',
                                  saving: 'Save KWD 30',
                                  terms: terms,
                                  expiry: '31 Dec 2026',
                                  applied: false,
                                  busy: busy,
                                  enabled: !busy,
                                  onSelect: () {},
                                  onAction: () {
                                    applies++;
                                    setState(() => busy = true);
                                  }),
                              const SizedBox(height: 16),
                              CouponOfferCard(
                                  code: 'APPLIED',
                                  saving: 'Save KWD 10',
                                  terms: terms,
                                  expiry: '31 Dec 2026',
                                  applied: true,
                                  onSelect: () {},
                                  onAction: () => removes++),
                            ]))),
                  )),
        ));
        await tester.pumpAndSettle();
        final l10n = AppLocalizations.of(
            tester.element(find.byType(CouponOfferCard).first))!;
        final apply = find.widgetWithText(FilledButton, l10n.apply);
        await tester.ensureVisible(apply);
        await tester.tap(apply);
        await tester.pump();
        expect(applies, 1);
        expect(
            tester
                .widget<FilledButton>(find.byType(FilledButton).first)
                .onPressed,
            isNull);
        expect(tester.widget<Text>(find.text(terms).first).maxLines, isNull);
        final remove = find.widgetWithText(FilledButton, l10n.remove);
        await tester.ensureVisible(remove);
        await tester.tap(remove);
        await tester.pump();
        expect(removes, 1);
        expect(tester.takeException(), isNull);
      });
    }
  }
  testWidgets('Coupon empty state scrolls with large Arabic text',
      (tester) async {
    tester.view.physicalSize = const Size(280, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var refreshes = 0;
    await tester.pumpWidget(MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(
            builder: (context) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(2)),
                  child: Scaffold(
                      body: CustomScrollView(slivers: [
                    SliverFillRemaining(
                        hasScrollBody: false,
                        child:
                            CouponEmptyContent(onRefresh: () => refreshes++)),
                  ])),
                ))));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(OutlinedButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(OutlinedButton));
    expect(refreshes, 1);
    expect(tester.takeException(), isNull);
  });
}
