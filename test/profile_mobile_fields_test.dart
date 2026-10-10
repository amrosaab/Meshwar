import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:meshwar_user/features/account/presentation/pages/profile/widget/profile_mobile_fields.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

void main() {
  for (final arabic in [false, true]) {
    for (final dark in [false, true]) {
      testWidgets(
          'Mobile editor preserves OTP on country rebuild arabic=$arabic dark=$dark',
          (tester) async {
        tester.view.physicalSize = const Size(280, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final phone = TextEditingController(text: '60000000');
        final otp = PinInputController();
        addTearDown(phone.dispose);
        addTearDown(otp.dispose);
        var countryTaps = 0;
        var dialCode = '+965';
        await tester.pumpWidget(MaterialApp(
          locale: Locale(arabic ? 'ar' : 'en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme:
              ThemeData(brightness: dark ? Brightness.dark : Brightness.light),
          home: StatefulBuilder(builder: (context, setState) {
            final l10n = AppLocalizations.of(context)!;
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(2)),
              child: Scaffold(
                  body: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ProfileMobileFields(
                    phoneController: phone,
                    otpController: otp.textController,
                    mobileLabel: l10n.mobile,
                    otpLabel: l10n.enterOtp,
                    countryLabel: l10n.selectContry,
                    dialCode: dialCode,
                    maxLength: 8,
                    showOtp: true,
                    onCountry: () {
                      countryTaps++;
                      setState(() => dialCode = '+20');
                    }),
              )),
            );
          }),
        ));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final otpInput = find.byWidgetPredicate((widget) =>
            widget is TextField &&
            identical(widget.controller, otp.textController));
        await tester.ensureVisible(otpInput);
        await tester.enterText(otpInput, '123456');
        await tester.pump();
        expect(otp.text, '123456');
        expect(tester.widget<TextField>(otpInput).autofillHints,
            contains(AutofillHints.oneTimeCode));
        await tester.ensureVisible(find.byType(OutlinedButton));
        await tester.tap(find.byType(OutlinedButton));
        await tester.pump();
        expect(countryTaps, 1);
        expect(find.text('+20'), findsOneWidget);
        expect(otp.text, '123456');
        expect(phone.text, '60000000');
        otp.setText('654321');
        await tester.pump();
        expect(find.text('654321'), findsOneWidget);
        otp.clear();
        await tester.pump();
        expect(tester.widget<TextField>(otpInput).controller!.text, isEmpty);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
