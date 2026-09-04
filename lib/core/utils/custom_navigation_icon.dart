import 'package:flutter/material.dart';
import '../../common/app_colors.dart';

class NavigationIconWidget extends StatefulWidget {
  final Widget icon;
  final bool? isShadowWidget;
  final void Function()? onTap;
  final double? height;
  final double? width;
  const NavigationIconWidget({
    super.key,
    required this.icon,
    this.isShadowWidget = false,
    this.onTap,
    this.height,
    this.width,
  });

  @override
  State<NavigationIconWidget> createState() => _NavigationIconWidgetState();
}

class _NavigationIconWidgetState extends State<NavigationIconWidget> {
  bool _isTappedOnce = false;

  void handleTap() {
    if (_isTappedOnce) {
      return;
    } else {
      setState(() {
        _isTappedOnce = true;
      });
      widget.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: widget.onTap,
      onTapCancel: () {},
      onDoubleTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: widget.height ?? size.width * 0.1,
        width: widget.width ?? size.width * 0.1,
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          border: Border.all(color: AppColors.surfaceBorder(context), width: 1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: (widget.isShadowWidget ?? false)
              ? [
            BoxShadow(
              color: AppColors.meshwarRed.withOpacity(0.35),
              blurRadius: 14,
              spreadRadius: -2,
            ),
          ]
              : null,
        ),
        child: Center(child: widget.icon),
      ),
    );
  }
}