import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/features/account/application/acc_bloc.dart';
import 'package:meshwar_user/features/account/presentation/pages/wallet/widget/transfer_money_content.dart';
import 'package:meshwar_user/features/account/presentation/pages/wallet/widget/wallet_transfer_money_widget.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

void main() {
  testWidgets(
      'Transfer modal follows active RTL even with stale bloc direction',
      (tester) async {
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final bloc = AccBloc();
    addTearDown(() async {
      await bloc.close();
      bloc.transferAmount.dispose();
      bloc.transferPhonenumber.dispose();
    });
    for (final arabic in [true, false]) {
      bloc.textDirection = arabic ? 'ltr' : 'rtl';
      bloc.dropdownValue = 'user';
      await tester.pumpWidget(MaterialApp(
        locale: Locale(arabic ? 'ar' : 'en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: BlocProvider<AccBloc>.value(
          value: bloc,
          child: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (_) => WalletTransferMoneyWidget(cont: context),
                ),
                child: const Text('Open transfer'),
              ),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open transfer'));
      await tester.pumpAndSettle();
      final context = tester.element(find.byType(TransferMoneySheet));
      expect(Directionality.of(context),
          arabic ? TextDirection.rtl : TextDirection.ltr);
      final badge = tester.getCenter(find.byIcon(Icons.swap_horiz_rounded));
      final close = tester.getCenter(find.byIcon(Icons.close_rounded));
      expect(badge.dx > close.dx, arabic);
      final dropdown = find.byType(DropdownButtonFormField<String>);
      final selected = find.descendant(
          of: dropdown,
          matching: find.text(AppLocalizations.of(context)!.user));
      final arrow = find.descendant(
          of: dropdown, matching: find.byIcon(Icons.arrow_drop_down));
      expect(
          tester.getCenter(selected).dx > tester.getCenter(arrow).dx, arabic);
      for (final field
          in tester.widgetList<TextField>(find.byType(TextField))) {
        expect(field.textDirection, TextDirection.ltr);
        expect(field.textAlign, arabic ? TextAlign.right : TextAlign.left);
      }
      final phoneIcon =
          tester.getCenter(find.byIcon(Icons.phone_iphone_rounded));
      final phoneLabel = tester.getCenter(
          find.text(AppLocalizations.of(context)!.enterMobileNumber));
      expect(phoneIcon.dx > phoneLabel.dx, arabic);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();
      expect(find.byType(TransferMoneySheet), findsNothing);
    }
  });

  for (final arabic in [false, true]) {
    for (final dark in [false, true]) {
      testWidgets('Transfer form keyboard arabic=$arabic dark=$dark',
          (tester) async {
        tester.view.physicalSize = const Size(320, 700);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final amount = TextEditingController();
        final phone = TextEditingController();
        addTearDown(amount.dispose);
        addTearDown(phone.dispose);
        var role = 'user', busy = false;
        var transfers = 0, closes = 0;
        await tester.pumpWidget(MaterialApp(
          locale: Locale(arabic ? 'ar' : 'en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme:
              ThemeData(brightness: dark ? Brightness.dark : Brightness.light),
          home: StatefulBuilder(
            builder: (context, setState) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                    textScaler: const TextScaler.linear(2),
                    viewInsets: const EdgeInsets.only(bottom: 240)),
                child: Scaffold(
                    body: Align(
                        alignment: Alignment.bottomCenter,
                        child: TransferMoneySheet(
                            amountController: amount,
                            phoneController: phone,
                            currency: 'KD',
                            role: role,
                            busy: busy,
                            onRole: (value) => setState(() => role = value),
                            onClose: () => closes++,
                            onTransfer: () {
                              transfers++;
                              setState(() => busy = true);
                            })))),
          ),
        ));
        await tester.pumpAndSettle();
        final l10n = AppLocalizations.of(
            tester.element(find.byType(TransferMoneySheet)))!;
        final transfer = find.byType(FilledButton);
        await tester.tap(transfer);
        await tester.pumpAndSettle();
        expect(transfers, 0);
        expect(find.text(l10n.enterMobileNumber), findsNWidgets(2));
        Finder field(TextEditingController controller) =>
            find.byWidgetPredicate((widget) =>
                widget is TextFormField && widget.controller == controller);
        Future<void> input(
            TextEditingController controller, String value) async {
          await tester.ensureVisible(field(controller));
          await tester.pumpAndSettle();
          await tester.enterText(field(controller), value);
          await tester.pumpAndSettle();
        }

        final dropdown = find.byType(DropdownButtonFormField<String>);
        await tester.ensureVisible(dropdown);
        await tester.pumpAndSettle();
        await tester.tap(dropdown);
        await tester.pumpAndSettle();
        await tester.tap(find.text(l10n.driver).last);
        await tester.pumpAndSettle();
        expect(role, 'driver');
        final selectedLabel =
            find.descendant(of: dropdown, matching: find.text(l10n.driver));
        expect(selectedLabel, findsOneWidget);
        // The selected label must have enough height, rather than inheriting
        // the menu item's padding inside a dense collapsed field.
        expect(tester.getSize(selectedLabel).height, greaterThanOrEqualTo(32));

        await input(phone, '+96512345678');
        expect(
            tester
                .widget<TextField>(find.descendant(
                    of: field(phone), matching: find.byType(TextField)))
                .textDirection,
            TextDirection.ltr);
        await input(amount, '0.000');
        await tester.tap(transfer);
        await tester.pumpAndSettle();
        expect(transfers, 0);
        await input(amount, '1..2');
        await tester.tap(transfer);
        await tester.pumpAndSettle();
        expect(transfers, 0);
        await input(amount, '12.345');
        await tester.tap(transfer);
        await tester.pump();
        expect(transfers, 1);
        expect(tester.widget<FilledButton>(transfer).onPressed, isNull);
        expect(tester.widget<TextFormField>(field(phone)).enabled, isFalse);
        expect(closes, 0);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
