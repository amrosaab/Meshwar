import 'package:flutter/material.dart';

import '../../../../common/app_colors.dart';
import '../../../../common/ride_visuals.dart';

abstract final class AccountStyle {
  static Color ink(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFF8F5F7)
          : const Color(0xFF201B25);
  static Color muted(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFBAADB9)
          : const Color(0xFF79717C);
  static TextStyle text(BuildContext context) => Theme.of(context)
      .textTheme
      .bodyMedium!
      .copyWith(fontSize: 14, height: 1.4, color: ink(context));
}

class AccountProfileCard extends StatelessWidget {
  const AccountProfileCard(
      {super.key,
      required this.name,
      required this.phone,
      required this.editLabel,
      required this.onPressed,
      this.imageUrl = ''});
  final String name, phone, editLabel, imageUrl;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(28),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
              gradient: RideVisuals.rose,
              borderRadius: BorderRadius.circular(28)),
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: LayoutBuilder(builder: (context, constraints) {
                final stacked = constraints.maxWidth < 260 ||
                    MediaQuery.textScalerOf(context).scale(14) > 20;
                final portrait = ExcludeSemantics(
                    child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    width: 66,
                    height: 66,
                    color: Colors.white.withValues(alpha: .18),
                    child: imageUrl.isEmpty
                        ? _fallback()
                        : Image.network(imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, error, stackTrace) => _fallback(),
                            loadingBuilder: (_, child, progress) =>
                                progress == null ? child : _fallback()),
                  ),
                ));
                final details = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: AccountStyle.text(context).copyWith(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700)),
                      if (phone.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(phone,
                            textDirection: TextDirection.ltr,
                            style: AccountStyle.text(context)
                                .copyWith(color: Colors.white, fontSize: 13)),
                      ],
                      const SizedBox(height: 14),
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        const ExcludeSemantics(
                            child: Icon(Icons.edit_outlined,
                                size: 15, color: Colors.white)),
                        const SizedBox(width: 6),
                        Flexible(
                            child: Text(editLabel,
                                style: AccountStyle.text(context).copyWith(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600))),
                      ]),
                    ]);
                return stacked
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            portrait,
                            const SizedBox(height: 18),
                            details
                          ])
                    : Row(children: [
                        portrait,
                        const SizedBox(width: 18),
                        Expanded(child: details)
                      ]);
              }),
            ),
          ),
        ),
      );

  Widget _fallback() =>
      const Icon(Icons.person_rounded, size: 36, color: Colors.white);
}

class AccountMenuSection extends StatelessWidget {
  const AccountMenuSection(
      {super.key, required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
              header: true,
              child: Text(title,
                  style: AccountStyle.text(context)
                      .copyWith(fontSize: 18, fontWeight: FontWeight.w700))),
          const SizedBox(height: 14),
          Material(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.bgAsphaltLight
                : Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: AppColors.surfaceBorder(context))),
            clipBehavior: Clip.antiAlias,
            child: Column(children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0)
                  Padding(
                      padding:
                          const EdgeInsetsDirectional.only(start: 74, end: 18),
                      child: Divider(
                          height: 1, color: AppColors.surfaceBorder(context))),
                children[i],
              ],
            ]),
          ),
        ],
      );
}

class AccountMenuTile extends StatelessWidget {
  const AccountMenuTile(
      {super.key,
      required this.label,
      required this.icon,
      required this.gradient,
      required this.onPressed});
  final String label;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(children: [
            ExcludeSemantics(
                child: RideColorBadge(
                    icon: icon,
                    gradient: gradient,
                    size: 40,
                    iconSize: 21,
                    radius: 14)),
            const SizedBox(width: 16),
            Expanded(
                child: Text(label,
                    style: AccountStyle.text(context)
                        .copyWith(fontWeight: FontWeight.w600))),
            const SizedBox(width: 10),
            ExcludeSemantics(
                child: Icon(Icons.chevron_right_rounded,
                    size: 22, color: AccountStyle.muted(context))),
          ]),
        ),
      );
}
