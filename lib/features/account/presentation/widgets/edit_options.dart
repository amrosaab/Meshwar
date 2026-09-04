import 'package:flutter/material.dart';
import '../../../../common/app_colors.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';

class EditOptions extends StatelessWidget {
  final String text;
  final String header;
  final Function()? onTap;
  final Icon? icon;
  final String? imagePath;
  final bool? showUnderLine;
  final bool? showEditIcon;

  const EditOptions(
      {super.key,
      required this.text,
      required this.header,
      required this.onTap,
      this.icon,
      this.imagePath,
      this.showUnderLine,
      this.showEditIcon});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (imagePath != null)
                    Image.asset(
                      imagePath!,
                      height: size.width * 0.06,
                      width: size.width * 0.06,
                      fit: BoxFit.contain,
                      color: AppColors.greyHintColor,
                    ),
                  SizedBox(
                    width: size.width * 0.025,
                  ),
                  SizedBox(
                    width: size.width * 0.55,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          text: header,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  fontSize: 14, color: AppColors.greyHintColor),
                        ),
                        const SizedBox(height: 2),
                        MyText(
                          text: text,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: Theme.of(context).primaryColorDark,
                                  fontSize: 16),
                          maxLines: 5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              (showEditIcon == true)
                  ? MyText(
                      text: AppLocalizations.of(context)!.edit,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: AppColors.primary, fontSize: 14),
                    )
                  : const SizedBox()
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (showUnderLine == true)
          const Divider(
            height: 1,
            color: Color(0xFFD9D9D9),
          ),
        const SizedBox(height: 25),
      ],
    );
  }
}
