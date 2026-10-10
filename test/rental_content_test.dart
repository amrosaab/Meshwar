import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/features/bookingpage/domain/models/rental_packages_model.dart';
import 'package:meshwar_user/features/bookingpage/presentation/page/booking/widget/rental_ride/rental_package_content.dart';
import 'package:meshwar_user/features/home/presentation/widgets/pickup_confirmation_panel.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

void main() {
  for (final arabic in [false, true]) {
    for (final dark in [false, true]) {
      testWidgets(
          'Rental packages and pickup support large text arabic=$arabic dark=$dark',
          (tester) async {
        tester.view.physicalSize = const Size(280, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        var selected = 0, continues = 0, closes = 0, confirms = 0;
        final description = arabic
            ? 'وصف كامل لحزمة التأجير المتاحة للرحلة'
            : 'A complete description of the available rental package';
        final packages = List.generate(
            2,
            (index) => RentalPackagesData(
                id: index,
                packageName: index == 0 ? 'Rental package' : 'Another package',
                description: '',
                shortDescription: description,
                userWalletBalance: 0,
                currency: 'KWD',
                currencyName: '',
                maxPrice: index == 0 ? 10 : 30,
                minPrice: 10,
                typesWithPrice: null));
        Widget app(Widget child) => MaterialApp(
            locale: Locale(arabic ? 'ar' : 'en'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            theme: ThemeData(
                brightness: dark ? Brightness.dark : Brightness.light),
            home: Builder(
                builder: (context) => MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: const TextScaler.linear(2)),
                    child: child)));
        await tester.pumpWidget(app(StatefulBuilder(
            builder: (context, setState) => Scaffold(
                body: RentalPackageSheet(
                    packages: packages,
                    selectedIndex: selected,
                    onSelect: (index) => setState(() => selected = index),
                    onContinue: () => continues++,
                    onClose: () => closes++)))));
        await tester.pumpAndSettle();
        expect(find.text('KWD 10.0'), findsOneWidget);
        await tester.scrollUntilVisible(find.text('Another package'), 150,
            scrollable: find.byType(Scrollable).first);
        await tester.pumpAndSettle();
        final choice = find.byIcon(Icons.radio_button_unchecked_rounded).last;
        await tester.ensureVisible(choice);
        await tester.pumpAndSettle();
        await tester.tap(choice);
        await tester.pumpAndSettle();
        expect(selected, 1);
        expect(
            tester.widget<Text>(find.text(description).last).maxLines, isNull);
        await tester.tap(find.byType(FilledButton));
        expect(continues, 1);
        await tester.tap(find.byType(IconButton));
        expect(closes, 1);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(app(Scaffold(
            body: const SizedBox.expand(),
            bottomNavigationBar: PickupConfirmationPanel(
                address:
                    'Tahrir Square, Cairo Governorate, Egypt, a detailed pickup location',
                pickup: true,
                bookingName: arabic ? 'نفسي' : 'Myself',
                onBookingType: () {},
                onConfirm: () => confirms++))));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(FilledButton));
        expect(confirms, 1);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
