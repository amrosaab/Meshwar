import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/common/ride_visuals.dart';
import 'package:meshwar_user/features/account/presentation/pages/fav_location/widget/favorite_location_card.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

void main() {
  for (final arabic in [false, true]) {
    for (final dark in [false, true]) {
      testWidgets(
          'Favorite actions and long addresses arabic=$arabic dark=$dark',
          (tester) async {
        tester.view.physicalSize = const Size(320, 740);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        var adds = 0;
        var deletes = 0;
        final address = arabic
            ? 'عنوان طويل للمنزل في مدينة الكويت، شارع الخليج، مبنى ١٢٣'
            : 'A long saved address in Kuwait City, Gulf Road, Building 123';
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
                  .copyWith(textScaler: const TextScaler.linear(1.8)),
              child: Scaffold(
                  body: ListView(padding: const EdgeInsets.all(20), children: [
                FavoriteLocationCard(
                    title: l10n.home,
                    address: l10n.tapAddAddress,
                    icon: Icons.home_rounded,
                    gradient: RideVisuals.blue,
                    actionLabel: l10n.tapAddAddress,
                    onAction: () => adds++),
                const SizedBox(height: 14),
                FavoriteLocationCard(
                    title: l10n.work,
                    address: address,
                    icon: Icons.work_rounded,
                    gradient: RideVisuals.amber,
                    actionLabel: l10n.delete,
                    saved: true,
                    onAction: () => deletes++),
              ])),
            );
          }),
        ));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(find.byIcon(Icons.add_rounded));
        await tester.pump();
        expect(adds, 1);
        await tester.ensureVisible(find.text(address));
        await tester.tap(find.text(address));
        await tester.pump();
        expect(deletes, 0);
        final delete = find.byIcon(Icons.delete_outline_rounded);
        await tester.ensureVisible(delete);
        await tester.tap(delete);
        await tester.pump();
        expect(deletes, 1);
        expect(tester.widget<Text>(find.text(address)).maxLines, isNull);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
