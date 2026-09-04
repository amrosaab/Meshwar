import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../common/common.dart';

class ShimmerWalletHistory extends StatelessWidget {
  final Size size;

  const ShimmerWalletHistory({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final baseColor = AppColors.shimmerBase(context);
    final highlightColor = AppColors.shimmerHighlight(context);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: size.width,
        height: size.width * 0.175,
        margin: EdgeInsets.only(bottom: size.width * 0.030),
        padding: EdgeInsets.all(size.width * 0.025),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 0.5, color: AppColors.surfaceBorder(context)),
        ),
        child: Row(
          children: [
            Container(
              height: size.width * 0.15,
              width: size.width * 0.125,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(width: size.width * 0.025),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 0.5,
                    height: 16,
                    color: baseColor,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: size.width * 0.35,
                    height: 14,
                    color: baseColor,
                  ),
                ],
              ),
            ),
            SizedBox(width: size.width * 0.025),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.12,
                  height: 16,
                  color: baseColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}