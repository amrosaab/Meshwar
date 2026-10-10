import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/features/account/domain/models/walletpage_model.dart';
import 'package:meshwar_user/features/account/presentation/pages/wallet/widget/add_money_content.dart';
import 'package:meshwar_user/features/account/presentation/pages/wallet/widget/wallet_payment_content.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

void main() {
  for (final arabic in [false, true]) {
    testWidgets('Amount keypad supports decimals arabic=$arabic',
        (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      double? amount;
      var nexts = 0;
      await tester.pumpWidget(MaterialApp(
        locale: Locale(arabic ? 'ar' : 'en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        theme:
            ThemeData(brightness: arabic ? Brightness.dark : Brightness.light),
        home: Builder(
            builder: (context) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(2)),
                child: AddMoneyContent(
                    controller: controller,
                    currency: 'KD',
                    balance: '12.345',
                    onChanged: (value) => amount = value,
                    onNext: () => nexts++))),
      ));
      await tester.pumpAndSettle();
      final next = find.byType(FilledButton);
      expect(tester.widget<FilledButton>(next).onPressed, isNull);
      Future<void> key(String label) async {
        final target = label == 'delete'
            ? find.byIcon(Icons.backspace_outlined)
            : find.widgetWithText(OutlinedButton, label);
        await tester.scrollUntilVisible(target, 120,
            scrollable: find.byType(Scrollable).first);
        await tester.ensureVisible(target);
        await tester.pumpAndSettle();
        await tester.tap(target);
        await tester.pump();
      }

      await key('.');
      expect(controller.text, '0.');
      expect(tester.widget<FilledButton>(next).onPressed, isNull);
      await key('.');
      expect(controller.text, '0.');
      for (final digit in ['1', '2', '3']) {
        await key(digit);
      }
      expect(controller.text, '0.123');
      expect(amount, .123);
      expect(tester.widget<FilledButton>(next).onPressed, isNotNull);
      await tester.tap(next);
      expect(nexts, 1);
      for (var i = 0; i < 5; i++) {
        await key('delete');
      }
      expect(controller.text, isEmpty);
      expect(tester.widget<FilledButton>(next).onPressed, isNull);
      await key('0');
      await key('5');
      expect(controller.text, '5');
      controller.text = '12345678901234567890.123';
      await tester.pump();
      await tester.scrollUntilVisible(
          find.text('KD 12345678901234567890.123'), -120,
          scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
    testWidgets('Payment methods retain original indices arabic=$arabic',
        (tester) async {
      tester.view.physicalSize = const Size(320, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final gateways = [
        PaymentGateway(
            gateway: 'Disabled method',
            enabled: false,
            image: '',
            url: '',
            isCard: false),
        PaymentGateway(
            gateway: 'Online payment with a long method name',
            enabled: true,
            image: '',
            url: '',
            isCard: false),
        PaymentGateway(
            gateway: 'Saved card •••• 1234',
            enabled: true,
            image: 'visa',
            url: '',
            isCard: true),
      ];
      var selected = 0, pays = 0;
      await tester.pumpWidget(MaterialApp(
        locale: Locale(arabic ? 'ar' : 'en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        theme:
            ThemeData(brightness: arabic ? Brightness.dark : Brightness.light),
        home: StatefulBuilder(
            builder: (context, setState) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(2)),
                child: Scaffold(
                    body: Align(
                        alignment: Alignment.bottomCenter,
                        child: WalletPaymentMethodSheet(
                            gateways: gateways,
                            selected: selected,
                            currency: 'KD',
                            amount: '10.123',
                            cardImage: (_) => const Icon(Icons.credit_card),
                            onSelect: (index) =>
                                setState(() => selected = index),
                            onPay: () => pays++))))),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Disabled method'), findsNothing);
      expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
          isNull);
      await tester.ensureVisible(find.text('Saved card •••• 1234'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Saved card •••• 1234'));
      await tester.pump();
      expect(selected, 2);
      await tester.tap(find.byType(FilledButton));
      expect(pays, 1);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('No enabled payment method cannot be submitted', (tester) async {
    await tester.pumpWidget(MaterialApp(
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Scaffold(
          body: WalletPaymentMethodSheet(
              gateways: const [],
              selected: 99,
              currency: 'KD',
              amount: '10',
              cardImage: (_) => const SizedBox(),
              onSelect: (_) {},
              onPay: () => fail('Empty payment selection submitted'))),
    ));
    await tester.pumpAndSettle();
    expect(find.text('No data available.'), findsOneWidget);
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull);
    expect(tester.takeException(), isNull);
  });
}
