import 'dart:ui';
import 'package:flutter/material.dart';

import '../core/utils/custom_text.dart';
import 'app_colors.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackTap;
  final Color? backgroundColor;
  final Color? textColor;
  final bool centerTitle;
  final bool? automaticallyImplyLeading;
  final Widget? titleIcon;
  final double? titleFontSize;

  const CustomHeader({
    super.key,
    required this.title,
    this.onBackTap,
    this.backgroundColor,
    this.textColor,
    this.centerTitle = true,
    this.automaticallyImplyLeading,
    this.titleIcon,
    this.titleFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedTextColor =
        textColor ?? Theme.of(context).textTheme.titleLarge!.color;

    // Preserves the original's exact condition: a back button only shows
    // when explicitly requested AND there's actually somewhere to pop to.
    final showLeading =
        automaticallyImplyLeading == true && Navigator.canPop(context);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          decoration: BoxDecoration(
            color: (backgroundColor ?? Theme.of(context).scaffoldBackgroundColor)
                .withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.55 : 0.85),
            border: Border(
              bottom: BorderSide(color: AppColors.surfaceBorder(context), width: 1),
            ),
          ),
          child: AppBar(
            automaticallyImplyLeading: automaticallyImplyLeading ?? true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: const Border(),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (titleIcon != null) ...[
                  titleIcon!,
                  const SizedBox(width: 8),
                ],
                MyText(
                  text: title,
                  textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: resolvedTextColor,
                    fontSize: titleFontSize ??
                        Theme.of(context).textTheme.titleLarge!.fontSize,
                  ),
                ),
              ],
            ),
            centerTitle: centerTitle,
            leading: showLeading ? _GlassBackButton(onTap: onBackTap) : null,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _GlassBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  const _GlassBackButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap ?? () => Navigator.of(context).pop(),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.meshwarRed.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceBorder(context)),
          ),
          child: Icon(Icons.arrow_back,
              size: 18, color: Theme.of(context).primaryColorDark),
        ),
      ),
    );
  }
}