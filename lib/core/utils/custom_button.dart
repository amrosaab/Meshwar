import 'package:flutter/material.dart';
import '../../../../common/common.dart';
import 'custom_loader.dart';
import 'custom_text.dart';

class CustomButton extends StatefulWidget {
  final String buttonName;
  final double? height;
  final double? width;
  final double? borderRadius;
  final Color? buttonColor;
  final Color? textColor;
  final double? textSize;
  final Function()? onTap;
  final bool? isLoader;
  final bool? isBorder;
  final Border? border;
  final Widget? leading;

  /// Optional widget pinned to the trailing edge (e.g. a price chip) —
  /// when set, the button switches from centered content to a
  /// space-between layout with buttonName/leading on the left and this
  /// on the right. Leaving it null keeps every existing call site's
  /// centered layout unchanged.
  final Widget? trailing;
  final bool? isLoaderShowWithText;

  /// Cuts the top-left/bottom-right corners at 45° instead of rounding —
  /// the "punk" hero-CTA treatment. Off by default so existing buttons
  /// keep their current shape; opt in per-button for primary actions.
  final bool angular;

  /// Overrides the default [AppColors.beaconGradient] fill — for small
  /// buttons where the default's diagonal direction barely shows across
  /// so little width, a horizontal gradient reads as a clearer red-to-light
  /// capsule. Ignored when [buttonColor] or outline mode is set.
  final Gradient? gradient;

  const CustomButton(
      {super.key,
      required this.buttonName,
      this.height,
      this.width,
      this.isLoaderShowWithText = false,
      this.borderRadius,
      this.buttonColor,
      this.textColor,
      this.textSize,
      this.border,
      this.onTap,
      this.isLoader = false,
      this.isBorder,
      this.leading,
      this.trailing,
      this.angular = false,
      this.gradient});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _pressed = false;

  bool get _isLoader => widget.isLoader ?? false;
  bool get _isBorder => widget.isBorder ?? false;
  bool get _canTap => !_isLoader && widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Outline mode (isBorder / border supplied) renders as a quiet glass
    // pill instead of the filled beacon gradient — used for secondary
    // actions like "Cancel" / "No" in the dialogs.
    final bool outline = _isBorder || widget.border != null;
    final double h = widget.height ?? size.width * 0.1;
    final double w = widget.width ?? size.width * 0.5;
    final double cut = widget.angular ? (h * 0.32).clamp(8, 16) : 0;

    final decoration = BoxDecoration(
      borderRadius: widget.angular
          ? null
          : BorderRadius.circular(widget.borderRadius ?? 14),
      gradient: (!outline && widget.buttonColor == null)
          ? (widget.gradient ?? AppColors.beaconGradient)
          : null,
      color: outline
          ? (widget.buttonColor ?? Colors.transparent)
          : widget.buttonColor,
      border: widget.angular
          ? null
          : (widget.border ??
              (outline
                  ? Border.all(color: AppColors.meshwarRed.withOpacity(0.5))
                  : null)),
    );

    final buttonText = Text(
      widget.buttonName.toUpperCase(),
      textAlign: TextAlign.center,
      style: AppTextStyle.normalStyle().copyWith(
        color: widget.textColor ??
            (outline ? AppColors.meshwarRed : AppColors.buttonTextColor),
        fontSize: widget.textSize ?? 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
      ),
      maxLines: 2,
    );

    final content = Padding(
      padding: widget.trailing != null
          ? const EdgeInsets.symmetric(horizontal: 20)
          : EdgeInsets.zero,
      child: Center(
        child: (!_isLoader)
            ? (widget.leading == null && widget.trailing == null)
                ? buttonText
                : Row(
                mainAxisAlignment: widget.trailing != null
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                mainAxisSize: widget.trailing != null
                    ? MainAxisSize.max
                    : MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.leading != null) ...[
                        widget.leading!,
                        const SizedBox(width: 6),
                      ],
                      buttonText,
                    ],
                  ),
                  if (widget.trailing != null) widget.trailing!,
                ],
              )
            : (!(widget.isLoaderShowWithText ?? false))
                ? SizedBox(
                    height: size.width * 0.05,
                    width: size.width * 0.05,
                    child: Loader(
                      color: widget.textColor ?? AppColors.buttonTextColor,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        text: widget.buttonName.toUpperCase(),
                        textStyle: AppTextStyle.normalStyle().copyWith(
                            color:
                                widget.textColor ?? AppColors.buttonTextColor,
                            letterSpacing: 0.6),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: size.width * 0.04,
                        width: size.width * 0.04,
                        child: Loader(
                          color: widget.textColor ?? AppColors.buttonTextColor,
                        ),
                      )
                    ],
                  ),
      ),
    );

    Widget box =
        Container(height: h, width: w, decoration: decoration, child: content);

    if (widget.angular) {
      box = CustomPaint(
        foregroundPainter: (!_canTap || outline)
            ? null
            : _AngularGlowBorder(
                cut: cut, color: AppColors.meshwarRed.withOpacity(0.7)),
        child: ClipPath(
          clipper: _AngularButtonClipper(cut: cut),
          child: Container(
              height: h, width: w, decoration: decoration, child: content),
        ),
      );
    }

    return GestureDetector(
      onTapDown: _canTap ? (_) => setState(() => _pressed = true) : null,
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: _canTap ? widget.onTap : null,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: Container(
          decoration: (!_canTap || outline || widget.angular)
              ? null
              : BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(widget.borderRadius ?? 14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.meshwarRed.withOpacity(0.38),
                      blurRadius: 22,
                      spreadRadius: -4,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
          child: box,
        ),
      ),
    );
  }
}

class _AngularButtonClipper extends CustomClipper<Path> {
  final double cut;
  const _AngularButtonClipper({required this.cut});

  @override
  Path getClip(Size size) {
    final c = cut.clamp(0, size.height / 2).toDouble();
    return Path()
      ..moveTo(c, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - c)
      ..lineTo(size.width - c, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, c)
      ..close();
  }

  @override
  bool shouldReclip(covariant _AngularButtonClipper oldClipper) =>
      oldClipper.cut != cut;
}

class _AngularGlowBorder extends CustomPainter {
  final double cut;
  final Color color;
  const _AngularGlowBorder({required this.cut, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final c = cut.clamp(0, size.height / 2).toDouble();
    final path = Path()
      ..moveTo(c, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - c)
      ..lineTo(size.width - c, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, c)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
  }

  @override
  bool shouldRepaint(covariant _AngularGlowBorder oldDelegate) =>
      oldDelegate.cut != cut || oldDelegate.color != color;
}
