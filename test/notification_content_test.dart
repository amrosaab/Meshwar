import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/features/account/presentation/pages/notification/widget/notification_content.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

void main() {
  for (final arabic in [false, true]) {
    for (final dark in [false, true]) {
      testWidgets('Notification text and actions arabic=$arabic dark=$dark',
          (tester) async {
        tester.view.physicalSize = const Size(320, 740);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        var deletes = 0;
        final title = arabic
            ? 'إشعار طويل عن تفاصيل الرحلة القادمة'
            : 'A longer notification title about your upcoming ride';
        final body = arabic
            ? 'هذه رسالة طويلة لاختبار عرض الإشعار بالكامل عند تكبير حجم الخط.'
            : 'This longer message should remain fully readable when the system text size is increased.';
        await tester.pumpWidget(MaterialApp(
          locale: Locale(arabic ? 'ar' : 'en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme:
              ThemeData(brightness: dark ? Brightness.dark : Brightness.light),
          home: Builder(
              builder: (context) => MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: const TextScaler.linear(1.8)),
                    child: Scaffold(
                        body: ListView(
                            padding: const EdgeInsets.all(20),
                            children: [
                          NotificationContent(
                              title: title,
                              body: body,
                              date: '',
                              deleteLabel: AppLocalizations.of(context)!
                                  .deleteNotification,
                              onDelete: () => deletes++),
                          NotificationEmptyContent(
                              label:
                                  AppLocalizations.of(context)!.noNotification),
                        ])),
                  )),
        ));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text(title), findsOneWidget);
        expect(tester.widget<Text>(find.text(body)).maxLines, isNull);
        await tester.tap(find.byType(IconButton));
        await tester.pump();
        expect(deletes, 1);
        await tester.scrollUntilVisible(
            find.byType(NotificationEmptyContent), 300);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
