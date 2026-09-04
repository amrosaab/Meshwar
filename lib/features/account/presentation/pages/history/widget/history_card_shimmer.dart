import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../common/common.dart';

/// Loading skeleton for the trip history list. Shape mirrors the real
/// history row (avatar + name/time, second avatar + name/status, then a
/// vehicle thumbnail + fare block) so the sweep predicts the content
/// that's about to load rather than just being a generic grey stack.
class HistoryShimmer extends StatelessWidget {
  final Size size;
  const HistoryShimmer({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final baseColor = AppColors.shimmerBase(context);
    final highlightColor = AppColors.shimmerHighlight(context);

    return Container(
      margin: const EdgeInsets.all(15),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: size.width * 0.03),
            child: Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.surfaceBorder(context)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _bone(width: 30, height: 30, circle: true),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: _bone(height: 10),
                            ),
                          ),
                          _bone(width: 50, height: 10),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _bone(width: 30, height: 30, circle: true),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: _bone(height: 10),
                            ),
                          ),
                          _bone(width: 50, height: 10),
                        ],
                      ),
                    ),
                    SizedBox(height: size.width * 0.03),
                    Padding(
                      padding: EdgeInsets.all(size.width * 0.025),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _bone(width: 100, height: 10),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _bone(width: 50, height: 50, radius: 10),
                                  SizedBox(width: size.width * 0.025),
                                  _bone(width: 100, height: 10),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _bone(width: 80, height: 10),
                              const SizedBox(height: 8),
                              _bone(width: 80, height: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// A single skeleton "bone" — circle avatar or rounded bar, filled with
  /// the same grey the Shimmer overlay sweeps across.
  Widget _bone({
    double? width,
    required double height,
    bool circle = false,
    double radius = 4,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.greyHeader,
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : BorderRadius.circular(radius),
      ),
    );
  }
}