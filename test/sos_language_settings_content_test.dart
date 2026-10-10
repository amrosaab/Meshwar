import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/features/account/presentation/pages/sos/widget/sos_content.dart';
import 'package:meshwar_user/features/account/presentation/pages/settings/widget/settings_content.dart';
import 'package:meshwar_user/features/language/presentation/widget/language_content.dart';
import 'package:meshwar_user/features/language/domain/models/language_listing_model.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

void main() {
  for (final arabic in [false, true]) {
    for (final dark in [false, true]) {
      Future<void> mount(WidgetTester tester, Widget child) async {
        tester.view.physicalSize = const Size(280, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
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
                  child: child)),
        ));
        await tester.pumpAndSettle();
      }

      testWidgets('SOS actions and contacts fit arabic=$arabic dark=$dark',
          (tester) async {
        var selects = 0, deletes = 0, manual = 0, contacts = 0;
        await mount(
            tester,
            Scaffold(
                body: SingleChildScrollView(
                    child: Column(children: [
                  SosContactCard(
                      name: 'Emergency contact with a long name',
                      number: '+96512345678',
                      onDelete: () => deletes++),
                  SosContactCard(
                      name: 'Family contact',
                      number: '+201234567890',
                      selected: true,
                      onSelect: () => selects++),
                  const SosEmptyContent(),
                ])),
                bottomNavigationBar: SosAddActions(
                    onContacts: () => contacts++, onManual: () => manual++)));
        await tester.tap(find.byType(FilledButton));
        await tester.tap(find.byType(OutlinedButton));
        expect(contacts, 1);
        expect(manual, 1);
        await tester.tap(find.byType(IconButton));
        expect(deletes, 1);
        await tester.ensureVisible(find.text('Family contact'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Family contact'));
        expect(selects, 1);
        expect(tester.takeException(), isNull);
      });
      testWidgets(
          'Language selection and confirmation arabic=$arabic dark=$dark',
          (tester) async {
        var selected = 0, confirmed = 0, busy = false;
        await mount(
            tester,
            StatefulBuilder(
                builder: (context, setState) => Scaffold(
                        body: LanguageContent(
                      languages: [
                        LocaleLanguageList(lang: 'en', name: 'English'),
                        LocaleLanguageList(lang: 'ar', name: 'العربية'),
                        LocaleLanguageList(lang: 'fr', name: 'Français'),
                        LocaleLanguageList(lang: 'es', name: 'Español')
                      ],
                      selectedIndex: selected,
                      busy: busy,
                      onSelect: (index) => setState(() => selected = index),
                      onConfirm: () {
                        confirmed++;
                        setState(() => busy = true);
                      },
                    ))));
        await tester.tap(find.text('العربية'));
        await tester.pump();
        expect(selected, 1);
        await tester.tap(find.byType(FilledButton));
        await tester.pump();
        expect(confirmed, 1);
        expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
            isNull);
        await tester.tap(find.text('English'));
        expect(selected, 1);
        expect(tester.takeException(), isNull);
      });
      testWidgets('Settings stays scrollable arabic=$arabic dark=$dark',
          (tester) async {
        var toggles = 0, layouts = 0, faqs = 0, policies = 0, deletes = 0;
        await mount(
            tester,
            Scaffold(
                body: SettingsContent(
              dark: dark,
              version: '1.0.0',
              showLayout: true,
              onTheme: (_) => toggles++,
              onLayout: () => layouts++,
              onFaq: () => faqs++,
              onPrivacy: () => policies++,
              onDelete: () => deletes++,
            )));
        final l10n =
            AppLocalizations.of(tester.element(find.byType(SettingsContent)))!;
        await tester.tap(find.byType(Switch));
        expect(toggles, 1);
        for (final label in [
          l10n.chooseLayout,
          l10n.faq,
          l10n.privacyPolicyAccounts,
          l10n.deleteAccount
        ]) {
          await tester.ensureVisible(find.text(label));
          await tester.pumpAndSettle();
          await tester.tap(find.text(label));
        }
        expect([layouts, faqs, policies, deletes], [1, 1, 1, 1]);
        await tester.ensureVisible(find.text('V 1.0.0'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
