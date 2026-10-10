import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/features/account/presentation/pages/refferal/widget/referral_content.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

void main() {
  for (final arabic in [false, true]) {
    for (final dark in [false, true]) {
      testWidgets(
          'Referral code, tabs, and rewards fit large text arabic=$arabic dark=$dark',
          (tester) async {
        tester.view.physicalSize = const Size(280, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        var copies = 0;
        var history = false;
        var changes = 0;
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
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const ReferralRewardCard(
                                      message:
                                          'Refer a friend and earn KWD 30'),
                                  const SizedBox(height: 18),
                                  ReferralCodeCard(
                                      code: 'YT123456', onCopy: () => copies++),
                                  const SizedBox(height: 18),
                                  ReferralTabs(
                                      showHistory: history,
                                      onSelected: (value) => setState(() {
                                            history = value;
                                            changes++;
                                          })),
                                  if (history)
                                    const ReferralHistoryTile(
                                        name: 'A friend with a longer name',
                                        date: '12 Oct, 09:45 PM',
                                        earning: 'KWD 1234.567',
                                        status: 'Reward pending approval'),
                                ]))),
                  )),
        ));
        await tester.pumpAndSettle();
        final l10n =
            AppLocalizations.of(tester.element(find.byType(ReferralTabs)))!;
        final copy = find.text(l10n.copy);
        await tester.ensureVisible(copy);
        await tester.tap(copy);
        await tester.pump();
        expect(copies, 1);
        expect(
            tester
                .widget<SelectableText>(find.byType(SelectableText))
                .textDirection,
            TextDirection.ltr);
        final tab = find.text(l10n.referralHistory);
        await tester.ensureVisible(tab);
        await tester.tap(tab);
        await tester.pumpAndSettle();
        expect(history, isTrue);
        expect(find.text('KWD 1234.567'), findsOneWidget);
        await tester.ensureVisible(tab);
        await tester.tap(tab);
        expect(changes, 1);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
