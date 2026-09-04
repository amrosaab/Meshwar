import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/app_colors.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';


class ImagePickerDialog extends StatelessWidget {
  final double size;
  final Function(ImageSource source) onImageSelected;

  const ImagePickerDialog({
    super.key,
    required this.size,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: size * 0.6,
        width: size,
        padding: EdgeInsets.all(size * 0.05),
        child: Column(
          children: [
            MyText(
              text: AppLocalizations.of(context)!.pickImaeFrom,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 18,
                    color: AppColors.hintColorGrey,
                  ),
            ),
            SizedBox(height: size * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Camera selection
                InkWell(
                  onTap: () {
                    onImageSelected(ImageSource.camera);
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Container(
                    height: size * 0.3,
                    width: size * 0.3,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context)
                              .primaryColorDark
                              .withAlpha((0.5 * 255).toInt())),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.camera,
                          size: size * 0.1,
                          color: Theme.of(context)
                              .primaryColorDark
                              .withAlpha((0.5 * 255).toInt()),
                        ),
                        MyText(
                          text: 'Camera',
                          textStyle:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: 15,
                                    color: Theme.of(context)
                                        .primaryColorDark
                                        .withAlpha((0.5 * 255).toInt()),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Gallery selection
                InkWell(
                  onTap: () {
                    onImageSelected(ImageSource.gallery);
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Container(
                    height: size * 0.3,
                    width: size * 0.3,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context)
                              .primaryColorDark
                              .withAlpha((0.5 * 255).toInt())),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.folder,
                          size: size * 0.1,
                          color: Theme.of(context)
                              .primaryColorDark
                              .withAlpha((0.5 * 255).toInt()),
                        ),
                        MyText(
                          text: AppLocalizations.of(context)!.galleryText,
                          textStyle:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: 15,
                                    color: Theme.of(context)
                                        .primaryColorDark
                                        .withAlpha((0.5 * 255).toInt()),
                                  ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showImagePickerDialog(
    BuildContext context, double size, Function(ImageSource) onImageSelected) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return ImagePickerDialog(
        size: size,
        onImageSelected: onImageSelected,
      );
    },
  );
}
