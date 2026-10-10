import 'package:flutter/material.dart';

import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';

abstract final class HistoryDetailStyle {
  static Color ink(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFF8F5F7)
          : const Color(0xFF201B25);
  static Color muted(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFBAADB9)
          : const Color(0xFF79717C);
  static Color border(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF382B3B)
          : const Color(0xFFECE9EE);
  static TextStyle text(BuildContext context) => Theme.of(context)
      .textTheme
      .bodyMedium!
      .copyWith(fontSize: 14, height: 1.5, color: ink(context));
}

class HistoryDetailCard extends StatelessWidget {
  const HistoryDetailCard({
    super.key,
    required this.child,
    this.title,
    this.icon = Icons.receipt_long_rounded,
    this.gradient = RideVisuals.blue,
  });
  final Widget child;
  final String? title;
  final IconData icon;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            gradient: RideVisuals.wash(context, gradient.colors.last),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: HistoryDetailStyle.border(context))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null) ...[
                Row(children: [
                  ExcludeSemantics(
                      child: RideColorBadge(
                          icon: icon,
                          gradient: gradient,
                          size: 34,
                          iconSize: 18,
                          radius: 12)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Semantics(
                          header: true,
                          child: Text(title!,
                              style: HistoryDetailStyle.text(context).copyWith(
                                  fontSize: 18,
                                  height: 1.3,
                                  fontWeight: FontWeight.w700)))),
                ]),
                const SizedBox(height: 20),
              ],
              child,
            ]),
      );
}

class HistoryDetailRow extends StatelessWidget {
  const HistoryDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.emphasized = false,
  });
  final String label, value;
  final Color? valueColor;
  final bool emphasized;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final base = HistoryDetailStyle.text(context);
          final stacked = constraints.maxWidth < 270 ||
              MediaQuery.textScalerOf(context).scale(14) > 20;
          final name = Text(label,
              style: base.copyWith(color: HistoryDetailStyle.muted(context)));
          final amount = Text(value,
              textAlign: stacked ? TextAlign.start : TextAlign.end,
              style: base.copyWith(
                  color: valueColor ?? HistoryDetailStyle.ink(context),
                  fontWeight: emphasized ? FontWeight.w700 : FontWeight.w600,
                  fontSize: emphasized ? 20 : 14));
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: stacked
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [name, const SizedBox(height: 3), amount])
                : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(flex: 3, child: name),
                    const SizedBox(width: 16),
                    Expanded(flex: 2, child: amount),
                  ]),
          );
        },
      );
}

class HistoryDetailButton extends StatelessWidget {
  const HistoryDetailButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.icon,
  });
  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
              backgroundColor: AppColors.meshwarRed,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(58),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ExcludeSemantics(child: Icon(icon, size: 20)),
            const SizedBox(width: 10),
            Flexible(
                child: Text(label.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: HistoryDetailStyle.text(context).copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: .4))),
          ]),
        ),
      );
}
