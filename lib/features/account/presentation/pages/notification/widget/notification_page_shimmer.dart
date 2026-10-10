import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../common/app_colors.dart';

class NotificationShimmer extends StatelessWidget {
  const NotificationShimmer({super.key, required this.size});
  final Size size;
  @override
  Widget build(BuildContext context) {
    final base = AppColors.shimmerBase(context);
    final placeholders = Column(
        children: List.generate(
            3,
            (index) => Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                    color: AppColors.surfaceStrong(context),
                    border: Border.all(color: AppColors.surfaceBorder(context)),
                    borderRadius: BorderRadius.circular(24)),
                child: Row(children: [
                  Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                          color: base,
                          borderRadius: BorderRadius.circular(15))),
                  const SizedBox(width: 14),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        FractionallySizedBox(
                            widthFactor: .6,
                            child: Container(height: 14, color: base)),
                        const SizedBox(height: 10),
                        Container(height: 12, color: base),
                        const SizedBox(height: 8),
                        FractionallySizedBox(
                            widthFactor: .35,
                            child: Container(height: 10, color: base)),
                      ])),
                ]))));
    return MediaQuery.disableAnimationsOf(context)
        ? placeholders
        : Shimmer.fromColors(
            baseColor: base,
            highlightColor: AppColors.shimmerHighlight(context),
            child: placeholders);
  }
}
