import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:meshwar_user/features/auth/presentation/widgets/otp_content.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

void main() {
  for (final arabic in [false, true]) {
    for (final dark in [false, true]) {
      testWidgets('OTP input and cooldown arabic=$arabic dark=$dark',
          (tester) async {
        tester.view.physicalSize = const Size(320, 700);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final pin = PinInputController();
        addTearDown(pin.dispose);
        var remaining = 9, changes = 0, resends = 0, verifications = 0;
        var busy = false;
        late StateSetter update;
        await tester.pumpWidget(MaterialApp(
          locale: Locale(arabic ? 'ar' : 'en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme:
              ThemeData(brightness: dark ? Brightness.dark : Brightness.light),
          home: StatefulBuilder(builder: (context, setState) {
            update = setState;
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(2),
                  viewInsets: const EdgeInsets.only(bottom: 240)),
              child: OtpVerificationLayout(
                email: false,
                destination: '+965 12345678',
                controller: pin.textController,
                remaining: remaining,
                busy: busy,
                onChanged: (_) {},
                onChange: () => changes++,
                onResend: () => resends++,
                onVerify: () => verifications++,
              ),
            );
          }),
        ));
        await tester.pumpAndSettle();
        final l10n = AppLocalizations.of(
            tester.element(find.byType(OtpVerificationLayout)))!;
        final verify = find.byType(FilledButton);
        final field = find.byType(TextField);
        final change = find.widgetWithText(TextButton, l10n.changeNumber);
        final resend = find.widgetWithText(TextButton, l10n.resendOtp);
        expect(tester.widget<FilledButton>(verify).onPressed, isNull);
        await tester.scrollUntilVisible(change, 150,
            scrollable: find.byType(Scrollable).first);
        await tester.ensureVisible(change);
        await tester.pumpAndSettle();
        await tester.tap(change);
        expect(changes, 1);
        await tester.scrollUntilVisible(field, 150,
            scrollable: find.byType(Scrollable).first);
        await tester.ensureVisible(field);
        await tester.pumpAndSettle();
        expect(tester.widget<TextField>(field).autofillHints,
            contains(AutofillHints.oneTimeCode));
        expect(
            tester.widget<TextField>(field).textDirection, TextDirection.ltr);
        await tester.enterText(field, '12a3');
        await tester.pump();
        expect(pin.text, '123');
        expect(tester.widget<FilledButton>(verify).onPressed, isNull);
        await tester.enterText(field, '12a345678');
        await tester.pumpAndSettle();
        expect(pin.text, '123456');
        expect(tester.widget<FilledButton>(verify).onPressed, isNotNull);
        await tester.tap(verify);
        expect(verifications, 1);
        await tester.scrollUntilVisible(resend, 150,
            scrollable: find.byType(Scrollable).first);
        await tester.ensureVisible(resend);
        await tester.pumpAndSettle();
        expect(find.text('00:09'), findsOneWidget);
        expect(tester.widget<TextButton>(resend).onPressed, isNull);
        update(() => remaining = 0);
        await tester.pump();
        expect(find.text('00:09'), findsNothing);
        await tester.tap(resend);
        expect(resends, 1);
        // Controller changes from an auth failure must also disable Verify.
        pin.clear();
        await tester.pump();
        expect(tester.widget<FilledButton>(verify).onPressed, isNull);
        pin.setText('654321');
        update(() => busy = true);
        await tester.pump();
        expect(tester.widget<FilledButton>(verify).onPressed, isNull);
        expect(tester.widget<TextButton>(resend).onPressed, isNull);
        expect(tester.widget<TextField>(field).enabled, isFalse);
        expect(tester.takeException(), isNull);
      });
    }
  }
  testWidgets('Email destination remains readable and can be changed',
      (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    var changes = 0;
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: OtpVerificationLayout(
        email: true,
        destination: 'user@example.com',
        controller: controller,
        remaining: 60,
        busy: false,
        onChanged: (_) {},
        onChange: () => changes++,
        onResend: () {},
        onVerify: () {},
      ),
    ));
    await tester.pumpAndSettle();
    expect(tester.widget<Text>(find.text('user@example.com')).textDirection,
        TextDirection.ltr);
    expect(find.text('01:00'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Change Email'));
    expect(changes, 1);
    expect(tester.takeException(), isNull);
  });
}
