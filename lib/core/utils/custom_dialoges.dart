import 'dart:ui';
import 'package:flutter/material.dart';

import '../../common/common.dart';
import 'custom_button.dart';
import 'custom_text.dart';

class CustomSingleButtonDialoge extends StatelessWidget {
  final String title;
  final String content;
  final String btnName;
  final Color? btnNameColor;
  final Color? btnColor;
  final Function()? onTap;

  const CustomSingleButtonDialoge(
      {super.key,
        required this.title,
        required this.content,
        required this.btnName,
        this.btnNameColor,
        this.btnColor,
        this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return _GlassDialogShell(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              text: title,
              textStyle: AppTextStyle.display(
                size: 18,
                weight: FontWeight.w700,
                color: Theme.of(context).brightness == Brightness.dark ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 12),
            MyText(
              text: content,
              maxLines: 4,
              textStyle: AppTextStyle.body(size: 14, weight: FontWeight.w500, color: AppColors.darkGrey),
            ),
            const SizedBox(height: 22),
            CustomButton(
              buttonName: btnName,
              borderRadius: 14,
              width: size.width,
              height: size.width * 0.12,
              buttonColor: btnColor,
              textColor: btnNameColor ?? AppColors.white,
              onTap: onTap ?? () {},
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDoubleButtonDialoge extends StatelessWidget {
  final String title;
  final String content;
  final String yesBtnName;
  final String noBtnName;
  final Color? yesBtnTextColor;
  final Color? noBtnTextColor;
  final Color? yesBtnColor;
  final Color? noBtnColor;
  final Function()? yesBtnFunc;
  final Function()? noBtnFunc;

  const CustomDoubleButtonDialoge({
    super.key,
    required this.title,
    required this.content,
    required this.yesBtnName,
    required this.noBtnName,
    this.yesBtnTextColor,
    this.noBtnTextColor,
    this.yesBtnColor,
    this.noBtnColor,
    this.yesBtnFunc,
    this.noBtnFunc,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return _GlassDialogShell(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            size.width * 0.06, 24, size.width * 0.06, size.width * 0.05),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              text: title,
              textStyle: AppTextStyle.display(
                size: 18,
                weight: FontWeight.w700,
                color: Theme.of(context).brightness == Brightness.dark ? AppColors.white : AppColors.black,
              ),
            ),
            SizedBox(height: size.width * 0.03),
            MyText(
              text: content,
              textStyle: AppTextStyle.body(size: 14, weight: FontWeight.w500, color: AppColors.darkGrey),
              maxLines: 4,
            ),
            SizedBox(height: size.width * 0.07),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  buttonName: noBtnName,
                  borderRadius: 14,
                  width: size.width * 0.3,
                  height: size.width * 0.12,
                  isBorder: true,
                  buttonColor: noBtnColor ?? Colors.transparent,
                  textColor: noBtnTextColor ?? AppColors.meshwarRed,
                  onTap: noBtnFunc ??
                          () {
                        Navigator.pop(context);
                      },
                ),
                CustomButton(
                  buttonName: yesBtnName,
                  borderRadius: 14,
                  width: size.width * 0.3,
                  height: size.width * 0.12,
                  buttonColor: yesBtnColor,
                  textColor: yesBtnTextColor ?? AppColors.white,
                  onTap: yesBtnFunc ?? () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Shared frosted-glass card shell — the single Dialog surface both dialog
/// types render into, so this is one clean glass panel, not nested chrome.
class _GlassDialogShell extends StatelessWidget {
  final Widget child;
  const _GlassDialogShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceStrong(context),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.surfaceBorder(context)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.meshwarRed.withOpacity(0.15),
                  blurRadius: 30,
                  spreadRadius: -8,
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}