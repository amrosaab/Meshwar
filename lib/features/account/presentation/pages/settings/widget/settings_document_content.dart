import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../widgets/account_content.dart';

class SettingsSurface extends StatelessWidget {
  const SettingsSurface({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Material(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.bgAsphaltLight
            : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: AppColors.surfaceBorder(context))),
        clipBehavior: Clip.antiAlias,
        child: child,
      );
}

class FaqAnswerCard extends StatelessWidget {
  const FaqAnswerCard(
      {super.key,
      required this.question,
      required this.answer,
      required this.expanded,
      required this.onTap});
  final String question, answer;
  final bool expanded;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => SettingsSurface(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Semantics(
            button: true,
            expanded: expanded,
            child: InkWell(
                onTap: onTap,
                child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ExcludeSemantics(
                              child: RideColorBadge(
                                  icon: Icons.help_outline_rounded,
                                  gradient: RideVisuals.blue,
                                  size: 36,
                                  iconSize: 20,
                                  radius: 12)),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Text(question,
                                  style: AccountStyle.text(context).copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700))),
                          const SizedBox(width: 8),
                          ExcludeSemantics(
                              child: AnimatedRotation(
                                  turns: expanded ? .5 : 0,
                                  duration:
                                      MediaQuery.disableAnimationsOf(context)
                                          ? Duration.zero
                                          : const Duration(milliseconds: 180),
                                  child: Icon(Icons.keyboard_arrow_down_rounded,
                                      color: AccountStyle.muted(context),
                                      size: 24))),
                        ])))),
        AnimatedSize(
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: expanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Divider(
                              height: 1,
                              color: AppColors.surfaceBorder(context)),
                          const SizedBox(height: 16),
                          Text(answer,
                              style: AccountStyle.text(context).copyWith(
                                  color: AccountStyle.muted(context),
                                  height: 1.6)),
                        ]))
                : const SizedBox(width: double.infinity)),
      ]));
}

class PolicyDocumentCard extends StatelessWidget {
  const PolicyDocumentCard(
      {super.key,
      required this.html,
      required this.title,
      required this.privacy});
  final String html, title;
  final bool privacy;
  @override
  Widget build(BuildContext context) => SettingsSurface(
      child: Padding(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ExcludeSemantics(
                  child: RideColorBadge(
                      icon: privacy
                          ? Icons.privacy_tip_outlined
                          : Icons.description_outlined,
                      gradient: privacy ? RideVisuals.green : RideVisuals.blue,
                      size: 44,
                      iconSize: 24,
                      radius: 15)),
              const SizedBox(width: 14),
              Expanded(
                  child: Semantics(
                      header: true,
                      child: Text(title,
                          style: AccountStyle.text(context).copyWith(
                              fontSize: 22, fontWeight: FontWeight.w700)))),
            ]),
            const SizedBox(height: 20),
            Divider(height: 1, color: AppColors.surfaceBorder(context)),
            const SizedBox(height: 16),
            Html(data: html, style: {
              'body': Style(
                  fontSize: FontSize(14),
                  lineHeight: const LineHeight(1.6),
                  color: AccountStyle.ink(context),
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero),
              'p': Style(margin: Margins.only(bottom: 16)),
              'h1': Style(
                  fontSize: FontSize(22),
                  fontWeight: FontWeight.w700,
                  color: AccountStyle.ink(context)),
              'h2': Style(
                  fontSize: FontSize(20),
                  fontWeight: FontWeight.w700,
                  color: AccountStyle.ink(context)),
              'h3': Style(
                  fontSize: FontSize(18),
                  fontWeight: FontWeight.w700,
                  color: AccountStyle.ink(context)),
              'li': Style(margin: Margins.only(bottom: 10)),
              'a': Style(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFFFF82A6)
                      : AppColors.meshwarRed),
            }),
          ])));
}

class SettingsContentNotice extends StatelessWidget {
  const SettingsContentNotice(
      {super.key,
      required this.icon,
      required this.onRetry,
      this.failed = false});
  final IconData icon;
  final VoidCallback onRetry;
  final bool failed;
  @override
  Widget build(BuildContext context) => Center(
      child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ExcludeSemantics(
                child: RideColorBadge(
                    icon: icon,
                    gradient: RideVisuals.blue,
                    size: 76,
                    iconSize: 36,
                    radius: 28)),
            const SizedBox(height: 24),
            Text(
                failed
                    ? AppLocalizations.of(context)!.tryAgain
                    : AppLocalizations.of(context)!.noDataAvailable,
                textAlign: TextAlign.center,
                style: AccountStyle.text(context)
                    .copyWith(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            OutlinedButton(
                onPressed: onRetry,
                style: OutlinedButton.styleFrom(
                    foregroundColor: AccountStyle.ink(context),
                    minimumSize: const Size(100, 48),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14)),
                child: Text(AppLocalizations.of(context)!.tryAgain,
                    textAlign: TextAlign.center)),
          ])));
}

class SettingsContentPlaceholder extends StatelessWidget {
  const SettingsContentPlaceholder({super.key});
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
      child: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: 3,
          separatorBuilder: (_, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) => SettingsSurface(
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FractionallySizedBox(
                            widthFactor: .7,
                            child: Container(
                                height: 20,
                                decoration: BoxDecoration(
                                    color: AppColors.shimmerBase(context),
                                    borderRadius: BorderRadius.circular(8)))),
                        const SizedBox(height: 18),
                        Container(
                            height: 12,
                            decoration: BoxDecoration(
                                color: AppColors.shimmerBase(context),
                                borderRadius: BorderRadius.circular(8))),
                        const SizedBox(height: 10),
                        Container(
                            height: 12,
                            decoration: BoxDecoration(
                                color: AppColors.shimmerBase(context),
                                borderRadius: BorderRadius.circular(8))),
                      ])))));
}
