import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/features/auth/presentation/widgets/register_content.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

void main() {
  for (final arabic in [false, true]) {
    for (final emailVerified in [false, true]) {
      testWidgets('Registration validation arabic=$arabic email=$emailVerified',
          (tester) async {
        tester.view.physicalSize = const Size(320, 700);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final name = TextEditingController();
        final phone =
            TextEditingController(text: emailVerified ? '' : '12345678');
        final email = TextEditingController(
            text: emailVerified ? 'user@example.com' : '');
        final password = TextEditingController();
        for (final controller in [name, phone, email, password]) {
          addTearDown(controller.dispose);
        }
        final form = GlobalKey<FormState>();
        var gender = '', busy = false, visible = false;
        var submits = 0, countries = 0, backs = 0;
        await tester.pumpWidget(MaterialApp(
          locale: Locale(arabic ? 'ar' : 'en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: ThemeData(
              brightness: arabic ? Brightness.dark : Brightness.light),
          home: StatefulBuilder(
              builder: (context, setState) => MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                        textScaler: const TextScaler.linear(2),
                        viewInsets: const EdgeInsets.only(bottom: 240)),
                    child: RegistrationLayout(
                      formKey: form,
                      nameController: name,
                      phoneController: phone,
                      emailController: email,
                      passwordController: password,
                      emailVerified: emailVerified,
                      dialCode: '+965',
                      flagUrl: '',
                      gender: gender,
                      genders: const ['male', 'female', 'others'],
                      showPassword: visible,
                      busy: busy,
                      onBack: () => backs++,
                      onCountry: () => countries++,
                      onGender: (value) => setState(() => gender = value),
                      onTogglePassword: () =>
                          setState(() => visible = !visible),
                      onRegister: () {
                        if (form.currentState!.validate()) {
                          submits++;
                          setState(() => busy = true);
                        }
                      },
                    ),
                  )),
        ));
        await tester.pumpAndSettle();
        final l10n = AppLocalizations.of(
            tester.element(find.byType(RegistrationLayout)))!;
        Finder field(TextEditingController controller) =>
            find.byWidgetPredicate((widget) =>
                widget is TextFormField && widget.controller == controller);
        Future<void> input(
            TextEditingController controller, String text) async {
          await tester.ensureVisible(field(controller));
          await tester.pumpAndSettle();
          await tester.enterText(field(controller), text);
          await tester.pumpAndSettle();
        }

        // Validation includes offscreen fields, rather than only visible ones.
        await tester.tap(find.byType(FilledButton));
        await tester.pumpAndSettle();
        expect(submits, 0);
        expect(find.text(l10n.enterUserName), findsOneWidget);
        expect(find.text(l10n.enterPassword), findsOneWidget);
        expect(find.text(l10n.requiredField), findsOneWidget);
        expect(
            tester.widget<TextFormField>(field(phone)).enabled, emailVerified);
        expect(
            tester.widget<TextFormField>(field(email)).enabled, !emailVerified);
        await tester.ensureVisible(find.byType(OutlinedButton));
        await tester.pumpAndSettle();
        if (emailVerified) {
          await tester.tap(find.byType(OutlinedButton));
          expect(countries, 1);
          await input(phone, '12a345678');
          expect(phone.text, '12345678');
        } else {
          expect(
              tester
                  .widget<OutlinedButton>(find.byType(OutlinedButton))
                  .onPressed,
              isNull);
          await input(email, 'invalid-email');
          expect(form.currentState!.validate(), isFalse);
          await tester.pumpAndSettle();
          expect(find.text(l10n.validEmail), findsOneWidget);
          email.clear();
        }
        await input(name, 'Example Rider');
        final dropdown = find.byType(DropdownButtonFormField<String>);
        await tester.ensureVisible(dropdown);
        await tester.pumpAndSettle();
        await tester.tap(dropdown);
        await tester.pumpAndSettle();
        await tester.tap(find.text(l10n.preferNotSay).last);
        await tester.pumpAndSettle();
        expect(gender, 'others');
        await input(password, 'short');
        expect(form.currentState!.validate(), isFalse);
        await tester.pumpAndSettle();
        expect(find.text(l10n.minPassRequired), findsOneWidget);
        await input(password, 'example123');
        await tester.ensureVisible(find.byIcon(Icons.visibility_off_outlined));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.visibility_off_outlined));
        await tester.pumpAndSettle();
        expect(
            tester
                .widget<TextField>(find.descendant(
                    of: field(password), matching: find.byType(TextField)))
                .obscureText,
            isFalse);
        expect(form.currentState!.validate(), isTrue);
        await tester.tap(find.byType(FilledButton));
        await tester.pump();
        expect(submits, 1);
        expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
            isNull);
        expect(tester.widget<TextFormField>(field(name)).enabled, isFalse);
        expect(backs, 0);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
