import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String? text;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  const MyText({
    super.key,
    required this.text,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text == null ? '' : text.toString(),
      style: (textStyle != null) ? textStyle : Theme.of(context).textTheme.bodyMedium,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
    );
  }
}