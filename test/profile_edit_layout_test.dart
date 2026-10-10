import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/features/account/presentation/pages/profile/widget/profile_edit_layout.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

void main() {
  for (final arabic in [false, true]) {
    for (final dark in [false, true]) {
      testWidgets(
          'Name editor stays accessible above keyboard arabic=$arabic dark=$dark',
          (tester) async {
        tester.view.physicalSize = const Size(320, 740);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final controller = TextEditingController(text: 'Existing name');
        addTearDown(controller.dispose);
        var saving = false;
        final savedNames = <String>[];
        await tester.pumpWidget(MaterialApp(
          locale: Locale(arabic ? 'ar' : 'en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme:
              ThemeData(brightness: dark ? Brightness.dark : Brightness.light),
          home: StatefulBuilder(builder: (context, setState) {
            final l10n = AppLocalizations.of(context)!;
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  viewInsets: const EdgeInsets.only(bottom: 280),
                  textScaler: const TextScaler.linear(1.7)),
              child: ProfileEditLayout(
                title: '${l10n.update} ${l10n.name}',
                label: l10n.name,
                description: l10n.enterNameIdOrPassport,
                icon: Icons.person_outline_rounded,
                saveLabel: l10n.update,
                saving: saving,
                onBack: () {},
                onSave: () {
                  savedNames.add(controller.text);
                  setState(() => saving = true);
                },
                field: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(hintText: l10n.enterYourName)),
              ),
            );
          }),
        ));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final input = find.byType(TextFormField);
        await tester.ensureVisible(input);
        await tester.enterText(input, arabic ? 'اسم جديد' : 'New name');
        await tester.pump();
        expect(tester.getBottomRight(find.byType(FilledButton)).dy,
            lessThanOrEqualTo(460));
        await tester.tap(find.byType(FilledButton));
        await tester.pump();
        expect(savedNames, [arabic ? 'اسم جديد' : 'New name']);
        expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
            isNull);
        await tester.tap(find.byType(FilledButton));
        expect(savedNames, hasLength(1));
        expect(tester.takeException(), isNull);
      });
    }
  }
}
