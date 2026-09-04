import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../common/common.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onChange;
  final VoidCallback? onTap;
  final Function(String)? onSubmitted;
  final String? hintText;
  final int? maxLine;
  final String? counterText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FloatingLabelBehavior? labelBehavior;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final String? labelText;
  final EdgeInsets? contentPadding;
  final bool? filled;
  final TextStyle? labelStyle;
  final Widget? prefixIcon;
  final Color? fillColor;
  final bool? readOnly;
  final Widget? suffixIcon;
  final TextStyle? hintTextStyle;
  final Widget? suffix;
  final int? maxLength;
  final TextStyle? style;
  final TextStyle? errorStyle;
  final TextInputAction? textInputAction;
  final Color? cursorColor;
  final BoxConstraints? suffixConstraints;
  final BoxConstraints? prefixConstraints;
  final bool? dense;
  final bool obscureText;
  final FocusNode? focusNode;
  final String? Function(String? string)? validator;
  final TextAlign textAlign;
  final bool? enabled;
  final InputBorder? disabledBorder;
  final double borderRadius;
  final bool? autofocus;
  const CustomTextField(
      {super.key,
        this.cursorColor,
        required this.controller,
        this.readOnly = false,
        this.obscureText = false,
        this.onChange,
        this.onTap,
        this.hintText,
        this.maxLine = 1,
        this.keyboardType = TextInputType.text,
        this.inputFormatters = const [],
        this.focusedBorder,
        this.enabledBorder,
        this.contentPadding,
        this.labelBehavior,
        this.labelText,
        this.filled = false,
        this.fillColor,
        this.labelStyle,
        this.prefixIcon,
        this.suffixIcon,
        this.hintTextStyle,
        this.suffix,
        this.maxLength,
        this.style,
        this.textInputAction,
        this.onSubmitted,
        this.suffixConstraints,
        this.dense,
        this.prefixConstraints,
        this.validator,
        this.errorStyle,
        this.focusNode,
        this.textAlign = TextAlign.start,
        this.enabled,
        this.borderRadius = 14,
        this.autofocus = false,
        this.counterText,
        this.disabledBorder});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();
  bool _focused = false;
  bool _ownsFocusNode = false;

  @override
  void initState() {
    super.initState();
    _ownsFocusNode = widget.focusNode == null;
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() => setState(() => _focused = _focusNode.hasFocus);

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.white : AppColors.black;

    final defaultBorder = OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.surfaceBorder(context), width: 1),
      borderRadius: BorderRadius.circular(widget.borderRadius),
    );
    final defaultFocusedBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.meshwarRed, width: 1.4),
      borderRadius: BorderRadius.circular(widget.borderRadius),
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: _focused
            ? [
          BoxShadow(
            color: AppColors.meshwarRed.withOpacity(0.22),
            blurRadius: 16,
            spreadRadius: -2,
          ),
        ]
            : const [],
      ),
      child: TextFormField(
        enabled: widget.enabled,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: widget.obscureText,
        cursorColor: widget.cursorColor ?? AppColors.meshwarRed,
        readOnly: widget.readOnly!,
        focusNode: _focusNode,
        onChanged: widget.onChange,
        onTap: widget.onTap,
        validator: widget.validator,
        onFieldSubmitted: widget.onSubmitted,
        textAlign: widget.textAlign,
        style: widget.style ?? AppTextStyle.body(size: 15, weight: FontWeight.w600, color: textColor),
        maxLength: widget.maxLength,
        autofocus: widget.autofocus!,
        decoration: InputDecoration(
          isDense: widget.dense ?? true,
          counterText: widget.counterText,
          suffix: widget.suffix,
          suffixIcon: widget.suffixIcon,
          contentPadding: widget.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          hintText: widget.hintText,
          hintStyle: widget.hintTextStyle ??
              AppTextStyle.body(size: 14, weight: FontWeight.w500, color: AppColors.darkGrey),
          filled: widget.filled ?? true,
          fillColor: widget.fillColor ?? AppColors.surface(context),
          errorStyle: widget.errorStyle ??
              AppTextStyle.body(size: 11.5, weight: FontWeight.w600, color: AppColors.red),
          labelText: widget.labelText,
          labelStyle: widget.labelStyle ??
              AppTextStyle.body(size: 14, weight: FontWeight.w600, color: AppColors.darkGrey),
          floatingLabelBehavior: widget.labelBehavior ?? FloatingLabelBehavior.always,
          suffixIconConstraints: widget.suffixConstraints,
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.red, width: 1.4),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.red, width: 1.2),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          focusedBorder: widget.focusedBorder ?? defaultFocusedBorder,
          enabledBorder: widget.enabledBorder ?? defaultBorder,
          disabledBorder: widget.disabledBorder ?? defaultBorder,
          prefixIconConstraints: widget.prefixConstraints,
          prefixIcon: widget.prefixIcon,
        ),
        inputFormatters: widget.inputFormatters,
        maxLines: widget.maxLine == 0 ? null : widget.maxLine,
        textInputAction: widget.textInputAction ?? TextInputAction.done,
        controller: widget.controller,
        keyboardType: widget.keyboardType ?? TextInputType.multiline,
      ),
    );
  }
}