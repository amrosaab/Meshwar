import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../common/app_colors.dart';

class CouponShimmer extends StatelessWidget {
  const CouponShimmer({super.key, required this.size});
  final Size size;
  @override
  Widget build(BuildContext context) {
    final base = AppColors.shimmerBase(context);
    final cards = Column(
        children: List.generate(
            3,
            (index) => Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: AppColors.surfaceStrong(context),
                    borderRadius: BorderRadius.circular(24),
                    border:
                        Border.all(color: AppColors.surfaceBorder(context))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 120, height: 20, color: base),
                      const SizedBox(height: 18),
                      Container(width: 180, height: 18, color: base),
                      const SizedBox(height: 18),
                      Container(height: 12, color: base),
                      const SizedBox(height: 8),
                      Container(height: 12, color: base),
                      const SizedBox(height: 20),
                      Container(
                          height: 48,
                          decoration: BoxDecoration(
                              color: base,
                              borderRadius: BorderRadius.circular(24))),
                    ]))));
    return MediaQuery.disableAnimationsOf(context)
        ? cards
        : Shimmer.fromColors(
            baseColor: base,
            highlightColor: AppColors.shimmerHighlight(context),
            child: cards);
  }
}
