import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/common/ride_visuals.dart';
import 'package:meshwar_user/features/account/presentation/pages/profile/widget/profile_info_content.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

void main() {
  for (final arabic in [false, true]) {
    for (final dark in [false, true]) {
      testWidgets(
          'Personal information wraps large text arabic=$arabic dark=$dark',
          (tester) async {
        tester.view.physicalSize = const Size(280, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        var photos = 0;
        var mobileEdits = 0;
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
                  .copyWith(textScaler: const TextScaler.linear(2)),
              child: Scaffold(
                  body: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  ProfilePhotoCard(
                      name:
                          arabic ? 'اسم مستخدم طويل' : 'A longer profile name',
                      title: l10n.profilePhoto,
                      editLabel: l10n.changeProfilePhoto,
                      caption: l10n.addProfilePhoto,
                      onEdit: () => photos++),
                  const SizedBox(height: 24),
                  ProfileFieldsCard(children: [
                    ProfileInfoField(
                        label: l10n.name,
                        value: 'A longer profile name',
                        editLabel: l10n.edit,
                        icon: Icons.person_outline_rounded,
                        gradient: RideVisuals.blue,
                        onEdit: () {}),
                    ProfileInfoField(
                        label: l10n.mobile,
                        value: '+96500000000',
                        editLabel: l10n.edit,
                        icon: Icons.phone_outlined,
                        gradient: RideVisuals.green,
                        ltrValue: true,
                        onEdit: () => mobileEdits++),
                    ProfileInfoField(
                        label: l10n.email,
                        value: 'a.long.email.address@example.com',
                        editLabel: l10n.edit,
                        icon: Icons.mail_outline_rounded,
                        gradient: RideVisuals.amber,
                        ltrValue: true,
                        onEdit: () {}),
                  ]),
                ]),
              )),
            );
          }),
        ));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.ensureVisible(find.byType(FilledButton));
        await tester.tap(find.byType(FilledButton));
        expect(photos, 1);
        final mobile = find.widgetWithText(ProfileInfoField, '+96500000000');
        await tester.ensureVisible(mobile);
        await tester.tap(mobile);
        expect(mobileEdits, 1);
        final email = find.text('a.long.email.address@example.com');
        await tester.ensureVisible(email);
        expect(tester.takeException(), isNull);
        expect((tester.widget<Text>(email)).textDirection, TextDirection.ltr);
      });
    }
  }
}
