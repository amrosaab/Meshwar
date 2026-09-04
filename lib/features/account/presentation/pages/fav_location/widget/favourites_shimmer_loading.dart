import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../common/common.dart';

// Shimmer
class FavouriteShimmerLoading extends StatelessWidget {
  final Size size;

  const FavouriteShimmerLoading({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final baseColor = AppColors.shimmerBase(context);
    final highlightColor = AppColors.shimmerHighlight(context);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: size.width * 0.06,
              height: size.width * 0.06,
              color: baseColor,
            ),
            SizedBox(width: size.width * 0.02),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12.0,
                    width: size.width * 0.3,
                    color: baseColor,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 12.0,
                    width: size.width * 0.5,
                    color: baseColor,
                  ),
                ],
              ),
            ),
            SizedBox(width: size.width * 0.015),
            Container(
              height: size.width * 0.07,
              width: size.width * 0.07,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: baseColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}