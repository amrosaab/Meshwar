import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/common/ride_visuals.dart';
import 'package:meshwar_user/features/account/presentation/widgets/account_content.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

void main() {
  for (final arabic in [false, true]) {
    for (final dark in [false, true]) {
      testWidgets('Account supports large text arabic=$arabic dark=$dark',
          (tester) async {
        tester.view.physicalSize = const Size(280, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        var profileOpens = 0;
        var settingsOpens = 0;
        await tester.pumpWidget(MaterialApp(
          locale: Locale(arabic ? 'ar' : 'en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme:
              ThemeData(brightness: dark ? Brightness.dark : Brightness.light),
          home: Builder(builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(2)),
              child: Scaffold(
                  body: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  AccountProfileCard(
                      name: arabic
                          ? 'اسم طويل لحساب المستخدم'
                          : 'A longer account name',
                      phone: '+96500000000',
                      editLabel: l10n.edit,
                      onPressed: () => profileOpens++),
                  const SizedBox(height: 28),
                  AccountMenuSection(title: l10n.yourAccount, children: [
                    AccountMenuTile(
                        label: l10n.personalInformation,
                        icon: Icons.person_outline_rounded,
                        gradient: RideVisuals.blue,
                        onPressed: () => profileOpens++),
                    AccountMenuTile(
                        label: l10n.settings,
                        icon: Icons.settings_outlined,
                        gradient: RideVisuals.green,
                        onPressed: () => settingsOpens++),
                    AccountMenuTile(
                        label: l10n.changeLanguage,
                        icon: Icons.language_rounded,
                        gradient: RideVisuals.amber,
                        onPressed: () {}),
                  ]),
                ]),
              )),
            );
          }),
        ));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(find.byType(AccountProfileCard));
        expect(profileOpens, 1);
        final settings =
            find.widgetWithIcon(AccountMenuTile, Icons.settings_outlined);
        await tester.ensureVisible(settings);
        await tester.tap(settings);
        expect(settingsOpens, 1);
        expect(tester.takeException(), isNull);
        expect(find.text('+96500000000'), findsOneWidget);
      });
    }
  }
}
