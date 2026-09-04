import 'package:flutter/material.dart';
import '../../common/app_colors.dart';

class CustomContainer extends StatelessWidget {
  final Widget? child;
  final double? height;
  final double? width;
  final bool? isShadow;
  final Color? color;
  final double? borderRadius;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;
  const CustomContainer(
      {super.key,
        this.child,
        this.height,
        this.width,
        this.isShadow = true,
        this.color,
        this.borderRadius,
        this.border,
        this.padding});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: height,
      width: width ?? size.width,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.surface(context),
        borderRadius: BorderRadius.circular(borderRadius ?? 14),
        border: border ?? Border.all(color: AppColors.surfaceBorder(context)),
        boxShadow: (isShadow != null && isShadow!) ? AppColors.surfaceShadow(context) : null,
      ),
      child: child,
    );
  }
}