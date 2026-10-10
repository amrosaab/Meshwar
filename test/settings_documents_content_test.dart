import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/features/account/presentation/pages/settings/widget/settings_document_content.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

void main() {
  for (final arabic in [false, true]) {
    for (final dark in [false, true]) {
      testWidgets(
          'FAQ toggles and policy remains readable arabic=$arabic dark=$dark',
          (tester) async {
        tester.view.physicalSize = const Size(280, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        var expanded = false;
        final answer = arabic
            ? 'هذه إجابة مفصلة عن كيفية استخدام التطبيق والحفاظ على معلوماتك الشخصية. ' *
                20
            : 'This is a detailed answer about using the application and protecting your information. ' *
                20;
        final question = arabic
            ? 'كيف يمكنني العثور على المزيد من المعلومات عن الرحلة؟'
            : 'How can I find more information about my journey?';
        await tester.pumpWidget(MaterialApp(
          locale: Locale(arabic ? 'ar' : 'en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme:
              ThemeData(brightness: dark ? Brightness.dark : Brightness.light),
          home: StatefulBuilder(
              builder: (context, setState) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(2)),
                  child: Scaffold(
                      body: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(children: [
                            FaqAnswerCard(
                                question: question,
                                answer: answer,
                                expanded: expanded,
                                onTap: () =>
                                    setState(() => expanded = !expanded)),
                            const SizedBox(height: 16),
                            PolicyDocumentCard(
                                privacy: true,
                                title: arabic
                                    ? 'سياسة الخصوصية'
                                    : 'Privacy Policy',
                                html:
                                    '<h2>Information</h2><p>$answer</p><ul><li>Personal information</li><li>Contact information</li></ul><p>End policy paragraph</p>'),
                          ]))))),
        ));
        await tester.pumpAndSettle();
        await tester.tap(find.text(question));
        await tester.pumpAndSettle();
        expect(expanded, isTrue);
        expect(tester.widget<Text>(find.text(answer)).maxLines, isNull);
        await tester.tap(find.text(question));
        await tester.pumpAndSettle();
        expect(expanded, isFalse);
        expect(find.text(answer), findsNothing);
        final end = find.text('End policy paragraph', findRichText: true);
        await tester.ensureVisible(end.first);
        await tester.pumpAndSettle();
        expect(end, findsAtLeastNWidgets(1));
        expect(tester.takeException(), isNull);
      });
    }
  }
  testWidgets('Empty document retries and placeholder fits narrow screen',
      (tester) async {
    tester.view.physicalSize = const Size(280, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var retries = 0;
    await tester.pumpWidget(MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(
            builder: (context) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(2)),
                child: Scaffold(
                    body: CustomScrollView(slivers: [
                  SliverFillRemaining(
                      hasScrollBody: false,
                      child: SettingsContentNotice(
                          icon: Icons.privacy_tip_outlined,
                          failed: true,
                          onRetry: () => retries++))
                ]))))));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(OutlinedButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(OutlinedButton));
    expect(retries, 1);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SettingsContentPlaceholder())));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
