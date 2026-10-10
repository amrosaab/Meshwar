import 'package:flutter/material.dart';
import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../widgets/account_content.dart';

class SettingsContent extends StatelessWidget {
  const SettingsContent(
      {super.key,
      required this.dark,
      required this.onTheme,
      required this.onLayout,
      required this.onFaq,
      required this.onPrivacy,
      required this.onDelete,
      required this.version,
      this.showLayout = false});
  final bool dark, showLayout;
  final ValueChanged<bool> onTheme;
  final VoidCallback onLayout, onFaq, onPrivacy, onDelete;
  final String version;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rows = <Widget>[
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: LayoutBuilder(builder: (context, constraints) {
            final title = Row(children: [
              const ExcludeSemantics(
                  child: RideColorBadge(
                      icon: Icons.dark_mode_outlined,
                      gradient: RideVisuals.blue,
                      size: 40,
                      iconSize: 21,
                      radius: 14)),
              const SizedBox(width: 16),
              Expanded(
                  child: Text(l10n.theme,
                      style: AccountStyle.text(context)
                          .copyWith(fontWeight: FontWeight.w600))),
            ]);
            final toggle = Semantics(
                label: l10n.theme,
                child: Switch(
                  value: dark,
                  onChanged: onTheme,
                  activeTrackColor: AppColors.meshwarRed,
                  thumbIcon: WidgetStateProperty.resolveWith((states) => Icon(
                      states.contains(WidgetState.selected)
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      size: 17)),
                ));
            return constraints.maxWidth < 230 ||
                    MediaQuery.textScalerOf(context).scale(14) > 22
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        title,
                        const SizedBox(height: 8),
                        Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: toggle)
                      ])
                : Row(children: [
                    Expanded(child: title),
                    const SizedBox(width: 8),
                    toggle
                  ]);
          })),
      if (showLayout)
        AccountMenuTile(
            label: l10n.chooseLayout,
            icon: Icons.dashboard_customize_outlined,
            gradient: RideVisuals.amber,
            onPressed: onLayout),
      AccountMenuTile(
          label: l10n.faq,
          icon: Icons.help_outline_rounded,
          gradient: RideVisuals.blue,
          onPressed: onFaq),
      AccountMenuTile(
          label: l10n.privacyPolicyAccounts,
          icon: Icons.privacy_tip_outlined,
          gradient: RideVisuals.green,
          onPressed: onPrivacy),
      AccountMenuTile(
          label: l10n.deleteAccount,
          icon: Icons.delete_outline_rounded,
          gradient: RideVisuals.rose,
          onPressed: onDelete),
    ];
    return ListView(padding: const EdgeInsets.all(20), children: [
      Material(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.bgAsphaltLight
              : Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: AppColors.surfaceBorder(context))),
          clipBehavior: Clip.antiAlias,
          child: Column(children: [
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0)
                Padding(
                    padding:
                        const EdgeInsetsDirectional.only(start: 74, end: 18),
                    child: Divider(
                        height: 1, color: AppColors.surfaceBorder(context))),
              rows[i],
            ]
          ])),
      if (version.isNotEmpty)
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: Text('V $version',
                textAlign: TextAlign.center,
                style: AccountStyle.text(context).copyWith(
                    fontSize: 12, color: AccountStyle.muted(context)))),
    ]);
  }
}
