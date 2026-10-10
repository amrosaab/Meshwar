import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/features/auth/presentation/widgets/verify_contact_content.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

void main() {
  for (final arabic in [false, true]) {
    for (final dark in [false, true]) {
      for (final email in [false, true]) {
        testWidgets(
            'Verify contact fits keyboard email=$email arabic=$arabic dark=$dark',
            (tester) async {
          tester.view.physicalSize = const Size(320, 700);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          final controller = TextEditingController();
          final focus = FocusNode();
          addTearDown(controller.dispose);
          addTearDown(focus.dispose);
          var busy = false,
              sends = 0,
              terms = 0,
              privacy = 0,
              signIns = 0,
              countries = 0;
          await tester.pumpWidget(MaterialApp(
              locale: Locale(arabic ? 'ar' : 'en'),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              theme: ThemeData(
                  brightness: dark ? Brightness.dark : Brightness.light),
              home: StatefulBuilder(
                  builder: (context, setState) => MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                          textScaler: const TextScaler.linear(2),
                          viewInsets: const EdgeInsets.only(bottom: 240)),
                      child: VerifyContactLayout(
                        email: email,
                        busy: busy,
                        field: VerifyContactField(
                            controller: controller,
                            focusNode: focus,
                            email: email,
                            dialCode: '+965',
                            maxLength: 8,
                            enabled: !busy,
                            onCountry: () => countries++),
                        onSend: () {
                          sends++;
                          setState(() => busy = true);
                        },
                        onSignIn: () => signIns++,
                        onTerms: () => terms++,
                        onPrivacy: () => privacy++,
                      )))));
          await tester.pumpAndSettle();
          final l10n = AppLocalizations.of(
              tester.element(find.byType(VerifyContactLayout)))!;
          final field = find.byType(TextField);
          await tester.ensureVisible(field);
          await tester.pumpAndSettle();
          await tester.enterText(
              field, email ? 'user@example.com' : '123a4567890');
          await tester.pump();
          expect(controller.text, email ? 'user@example.com' : '12345678');
          await tester.pumpAndSettle();
          await tester.ensureVisible(find.byIcon(Icons.close_rounded));
          await tester.pumpAndSettle();
          await tester.tap(find.byIcon(Icons.close_rounded));
          await tester.pump();
          expect(controller.text, isEmpty);
          if (!email) {
            await tester.ensureVisible(find.byType(OutlinedButton));
            await tester.pumpAndSettle();
            await tester.tap(find.byType(OutlinedButton));
            expect(countries, 1);
            expect(tester.widget<TextField>(field).textDirection,
                TextDirection.ltr);
          }
          for (final label in [
            l10n.termsOfService,
            l10n.privacyPolicyText,
            l10n.signIn
          ]) {
            final button = find.widgetWithText(TextButton, label);
            await tester.scrollUntilVisible(button, 150,
                scrollable: find.byType(Scrollable).first);
            await tester.ensureVisible(button);
            await tester.pumpAndSettle();
            await tester.tap(button);
          }
          expect([terms, privacy, signIns], [1, 1, 1]);
          await tester.tap(find.byType(FilledButton));
          await tester.pump();
          expect(sends, 1);
          expect(
              tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
              isNull);
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
}
