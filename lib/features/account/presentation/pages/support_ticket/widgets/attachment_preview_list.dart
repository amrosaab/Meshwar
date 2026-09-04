import 'package:flutter/material.dart';

import '../../../../../../common/app_images.dart';

class AttachmentPreviewList extends StatelessWidget {
  final List<dynamic> imageUrls;
  final double heightFactor;
  final double widthFactor;

  const AttachmentPreviewList({
    super.key,
    required this.imageUrls,
    this.heightFactor = 0.2,
    this.widthFactor = 0.19,
  });
  bool _isPdf(String url) => url.toLowerCase().endsWith('.pdf');
  bool _isDoc(String url) => url.toLowerCase().endsWith('.doc');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.width * heightFactor,
      width: size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Container(
            height: size.width * widthFactor,
            width: size.width * widthFactor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: _isPdf(imageUrls[index])
                    ? const AssetImage(AppImages.pdfImage)
                    : _isDoc(imageUrls[index])
                        ? const AssetImage(AppImages.docImage)
                        : NetworkImage(imageUrls[index]),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
