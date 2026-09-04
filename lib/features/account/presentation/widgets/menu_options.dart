// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization.dart';
import '../../../../common/app_images.dart';
import '../../../../common/local_data.dart';
import '../../../../core/utils/custom_text.dart';
import '../../application/acc_bloc.dart';

class MenuOptions extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  final bool? showTheme;
  final bool? showroute;
  final bool? showrouteValue;
  final String? imagePath;
  final Color? textColor;
  final Color? iconColor; //  Optional icon color
  final Color? imageColor;
  final Color? iconbackground;

  const MenuOptions(
      {super.key,
      this.icon,
      required this.label,
      this.subtitle,
      required this.onTap,
      this.showTheme = false,
      this.showroute = false,
      this.showrouteValue = false,
      this.imagePath,
      this.textColor,
      this.iconColor,
      this.imageColor,
      this.iconbackground});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// LEFT ICON BOX
            Container(
              height: size.width * 0.11,
              width: size.width * 0.11,
              decoration: BoxDecoration(
                color: iconbackground ?? theme.primaryColor.withOpacity(.12),
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: icon != null
                  ? Icon(
                      icon,
                      size: 20,
                      color: iconColor ?? theme.hintColor,
                    )
                  : Image.asset(
                      imagePath!,
                      height: size.width * 0.06,
                      width: size.width * 0.06,
                      color: imageColor ?? theme.hintColor,
                      fit: BoxFit.contain,
                    ),
            ),

            SizedBox(width: size.width * 0.04),

            /// TITLE + SUBTITLE
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: label,
                    textStyle: theme.textTheme.bodyMedium!.copyWith(
                      color: textColor ?? theme.colorScheme.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: MyText(
                        text: subtitle!,
                        textStyle: theme.textTheme.bodySmall!.copyWith(
                          color: theme.hintColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            /// RIGHT SIDE ACTIONS
            if (showTheme!)
              Transform.scale(
                scale: 0.85,
                child: Switch(
                  value: context.read<AccBloc>().isDarkTheme,
                  activeColor: theme.primaryColorDark,
                  activeTrackColor: theme.primaryColor,
                  inactiveTrackColor: theme.colorScheme.surface,
                  activeThumbImage: const AssetImage(AppImages.sun),
                  inactiveThumbImage: const AssetImage(AppImages.moon),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (value) async {
                    context.read<AccBloc>().isDarkTheme = value;

                    final locale =
                        await AppSharedPreference.getSelectedLanguageCode();

                    if (!context.mounted) return;

                    context.read<LocalizationBloc>().add(
                          LocalizationInitialEvent(
                            isDark: value,
                            locale: Locale(locale),
                          ),
                        );
                  },
                ),
              ),

            if (showroute!)
              Transform.scale(
                scale: 0.85,
                child: Switch(
                  value: showrouteValue!,
                  activeColor: theme.primaryColorDark,
                  activeTrackColor: theme.primaryColor,
                  inactiveTrackColor: theme.colorScheme.surface,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: null,
                ),
              ),

            if (!showTheme! && !showroute!)
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: theme.disabledColor.withOpacity(0.5),
                  size: 22,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
