import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/common/ride_visuals.dart';
import 'package:meshwar_user/features/account/presentation/pages/wallet/widget/wallet_content.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

void main() {
  for (final arabic in [false, true]) {
    for (final dark in [false, true]) {
      testWidgets('Wallet supports narrow large text arabic=$arabic dark=$dark',
          (tester) async {
        tester.view.physicalSize = const Size(280, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        var taps = 0;
        await tester.pumpWidget(MaterialApp(
            locale: Locale(arabic ? 'ar' : 'en'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            theme: ThemeData(
                brightness: dark ? Brightness.dark : Brightness.light),
            home: Builder(builder: (context) {
              final l10n = AppLocalizations.of(context)!;
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(2)),
                child: Scaffold(
                    body: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    WalletBalanceCard(
                        label: l10n.walletBalance, balance: 'KWD 1234.567'),
                    const SizedBox(height: 20),
                    WalletActionCard(
                        label: l10n.addMoney,
                        icon: Icons.add_rounded,
                        gradient: RideVisuals.blue,
                        onPressed: () => taps++),
                    const SizedBox(height: 20),
                    WalletTransactionTile(
                        remarks: arabic
                            ? 'تم إيداع الأموال بواسطة المسؤول'
                            : 'Money Deposited By Admin',
                        date: '04 Oct 2026, 02:01 PM',
                        amount: 'KWD 1234.567',
                        isDebit: false),
                    const WalletTransactionTile(
                        remarks: 'Withdrawn From Wallet',
                        date: '04 Oct 2026, 02:02 PM',
                        amount: '- KWD 10.000',
                        isDebit: true),
                    WalletSavedCard(
                        brand: 'Mastercard',
                        lastNumber: '0042',
                        onPressed: () => taps++),
                    WalletEmptyTransactions(
                        title: l10n.paymenyHistoryEmpty,
                        message: l10n.paymenyHistoryEmptyText),
                  ]),
                )),
              );
            })));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('- KWD 10.000'), findsOneWidget);
        expect(find.text('•••• 0042'), findsOneWidget);
        await tester.ensureVisible(find.byType(WalletActionCard));
        await tester.tap(find.byType(WalletActionCard));
        expect(taps, 1);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets(
      'Unknown balance has no fabricated zero and disabled action cannot run',
      (tester) async {
    var taps = 0;
    Widget page({String? balance, bool enabled = false}) => MaterialApp(
            home: Scaffold(
                body: Column(children: [
          WalletBalanceCard(label: 'Wallet Balance', balance: balance),
          WalletActionCard(
              label: 'Add Money',
              icon: Icons.add_rounded,
              gradient: RideVisuals.blue,
              onPressed: enabled ? () => taps++ : null),
        ])));
    await tester.pumpWidget(page());
    expect(find.text('—'), findsOneWidget);
    expect(find.text('0.00'), findsNothing);
    await tester.tap(find.byType(WalletActionCard));
    expect(taps, 0);
    await tester.pumpWidget(page(balance: '£ 30.00', enabled: true));
    expect(find.text('£ 30.00'), findsOneWidget);
    await tester.tap(find.byType(WalletActionCard));
    expect(taps, 1);
    expect(tester.takeException(), isNull);
  });
}
