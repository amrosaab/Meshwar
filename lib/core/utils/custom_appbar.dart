import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/liquid_glass_container.dart';
import 'custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackTap;
  final Color? backgroundColor;
  final Color? textColor;
  final bool centerTitle;
  final bool? automaticallyImplyLeading;
  final Widget? titleIcon;
  final double? titleFontSize;
  /// When false, skips LiquidGlassContainer entirely — a plain flat
  /// Container with [backgroundColor] (or scaffoldBackgroundColor if
  /// null), no blur, no highlight. For screens that genuinely want a
  /// solid opaque bar rather than glass tinted toward white.
  final bool useGlass;
  /// The bottom hairline divider. On by default (existing behavior);
  /// turn off for screens where it reads as an unwanted seam, e.g. one
  /// sitting directly above a gradient body it should blend into.
  final bool showBottomBorder;
  /// Trailing widgets, same as AppBar.actions — for screens that need a
  /// button/icon on the right side alongside the title (e.g. a Help
  /// link), not just a back button on the left.
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackTap,
    this.backgroundColor,
    this.textColor,
    this.centerTitle = true,
    this.automaticallyImplyLeading,
    this.titleIcon,
    this.titleFontSize,
    this.useGlass = true,
    this.showBottomBorder = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedTextColor =
        textColor ?? Theme.of(context).textTheme.titleLarge!.color;

    // NOTE: preserves the original behavior exactly — the back button only
    // renders when automaticallyImplyLeading is explicitly passed as true.
    // (Left as-is so screens that rely on the default "no back button"
    // don't unexpectedly grow one.)
    final showLeading = automaticallyImplyLeading != null && automaticallyImplyLeading!;

    final appBarContent = AppBar(
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
      leading: showLeading ? _GlassBackButton(onTap: onBackTap) : const SizedBox(),
      actions: actions,
    );

    final borderDecoration = showBottomBorder
        ? BoxDecoration(
      border: Border(
        bottom: BorderSide(color: AppColors.surfaceBorder(context), width: 1),
      ),
    )
        : const BoxDecoration();

    if (!useGlass) {
      // Plain flat bar — no blur, no highlight, genuinely opaque.
      return Container(
        color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        child: Container(
          decoration: borderDecoration,
          child: appBarContent,
        ),
      );
    }

    final statusBarHeight = MediaQuery.of(context).padding.top;

    // Scaffold only ever reserves kToolbarHeight for this widget — the
    // status bar strip above it is painted by whatever's behind the
    // Scaffold, a completely different color source than this bar's own
    // glass fill. On a transparent Scaffold (e.g. HistoryPage) that shows
    // up as a visible seam right at the notch. Painting a second,
    // identical glass strip that overflows upward into that zone closes
    // the gap without changing this widget's actual layout footprint.
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (statusBarHeight > 0)
          Positioned(
            top: -statusBarHeight,
            left: 0,
            right: 0,
            height: statusBarHeight,
            child: LiquidGlassContainer(
              showBorder: false,
              borderRadius: 0,
              tintColor: backgroundColor,
              blurSigma: 14,
              child: const SizedBox.expand(),
            ),
          ),
        LiquidGlassContainer(
          // No rim border here — this bar spans full width against the
          // screen edge, so a border.all would look wrong on the
          // top/left/right sides. Kept only the original bottom
          // hairline, added separately below.
          showBorder: false,
          borderRadius: 0,
          // Explicit backgroundColor callers (e.g. HistoryPage passing
          // Colors.transparent to let CustomBackground show through
          // cleanly) still work exactly as before — LiquidGlassContainer's
          // tintColor override preserves that, it doesn't force the
          // default blue.
          tintColor: backgroundColor,
          blurSigma: 14,
          child: Container(
            decoration: borderDecoration,
            child: appBarContent,
          ),
        ),
      ],
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
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceBorder(context)),
          ),
          child: Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: Theme.of(context).primaryColorDark),
        ),
      ),
    );
  }
}