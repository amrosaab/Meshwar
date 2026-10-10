import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../common/common.dart';

class SosShimmerLoading extends StatelessWidget {
  final Size size;

  const SosShimmerLoading({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final baseColor = AppColors.shimmerBase(context);
    final highlightColor = AppColors.shimmerHighlight(context);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: size.width,
        margin: const EdgeInsets.only(right: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border:
              Border.all(width: 0.5, color: AppColors.surfaceBorder(context)),
        ),
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.025),
          child: Row(
            children: [
              Container(
                height: size.width * 0.13,
                width: size.width * 0.13,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: baseColor,
                ),
              ),
              SizedBox(width: size.width * 0.025),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 15,
                      width: size.width * 0.4,
                      color: baseColor,
                    ),
                    SizedBox(height: size.width * 0.02),
                    Container(
                      height: 15,
                      width: size.width * 0.3,
                      color: baseColor,
                    ),
                  ],
                ),
              ),
              SizedBox(width: size.width * 0.025),
              Container(
                height: 24,
                width: 24,
                color: baseColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
