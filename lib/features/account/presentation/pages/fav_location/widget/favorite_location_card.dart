import 'package:flutter/material.dart';

import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../widgets/account_content.dart';

class FavoriteLocationCard extends StatelessWidget {
  const FavoriteLocationCard(
      {super.key,
      required this.title,
      required this.address,
      required this.icon,
      required this.gradient,
      required this.actionLabel,
      required this.onAction,
      this.saved = false});

  final String title, address, actionLabel;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onAction;
  final bool saved;

  @override
  Widget build(BuildContext context) => Material(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.bgAsphaltLight
            : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: AppColors.surfaceBorder(context))),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: saved ? null : onAction,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ExcludeSemantics(
                  child: RideColorBadge(
                      icon: icon,
                      gradient: gradient,
                      size: 48,
                      iconSize: 25,
                      radius: 16)),
              const SizedBox(width: 14),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(title,
                        style: AccountStyle.text(context).copyWith(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 5),
                    Text(address,
                        style: AccountStyle.text(context)
                            .copyWith(color: AccountStyle.muted(context))),
                  ])),
              const SizedBox(width: 8),
              IconButton(
                  tooltip: actionLabel,
                  onPressed: onAction,
                  style: IconButton.styleFrom(
                      backgroundColor:
                          AppColors.meshwarRed.withValues(alpha: .08),
                      foregroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFFFF82A6)
                              : AppColors.meshwarRed,
                      minimumSize: const Size(44, 44)),
                  icon: Icon(
                      saved ? Icons.delete_outline_rounded : Icons.add_rounded,
                      size: 22)),
            ]),
          ),
        ),
      );
}
