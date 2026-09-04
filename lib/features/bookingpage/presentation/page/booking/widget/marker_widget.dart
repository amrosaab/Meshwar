import 'package:flutter/material.dart';
import '../../../../../../common/app_images.dart';
import '../../../../../../core/utils/custom_text.dart';

class MarkerWidget extends StatelessWidget {
  const MarkerWidget({
    super.key,
    required this.text,
    this.count,
    required this.isPickup,
  });
  final String text;
  final String? count;
  final bool isPickup;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        (isPickup)
            ? Image.asset(
                AppImages.pickPin,
                height: 30,
                width: 30,
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    AppImages.dropPin,
                    height: 30,
                    width: 30,
                  ),
                  if (count != null)
                    Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.dark
                            ? Colors.black
                            : Colors.white,
                      ),
                      child: Center(
                        child: MyText(
                            text: count ?? '',
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontWeight: FontWeight.bold)),
                      ),
                    )
                ],
              ),
      ],
    );
  }
}
