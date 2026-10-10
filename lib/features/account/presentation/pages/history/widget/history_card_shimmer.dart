import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../common/app_colors.dart';

class HistoryShimmer extends StatelessWidget {
  const HistoryShimmer({super.key, required this.size});
  final Size size;

  @override
  Widget build(BuildContext context) {
    final skeleton = Column(children: [
      for (var index = 0; index < 3; index++)
        Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
              color: AppColors.surface(context),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.surfaceBorder(context))),
          child: Column(children: [
            Row(children: [
              Expanded(child: _bone(height: 12)),
              const SizedBox(width: 48),
              _bone(width: 64, height: 24),
            ]),
            const SizedBox(height: 22),
            for (var stop = 0; stop < 2; stop++) ...[
              Row(children: [
                _bone(width: 32, height: 32, radius: 11),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      _bone(width: 72, height: 10),
                      const SizedBox(height: 8),
                      _bone(height: 14),
                    ])),
              ]),
              const SizedBox(height: 20),
            ],
            Row(children: [
              _bone(width: 42, height: 42, radius: 14),
              const SizedBox(width: 12),
              Expanded(child: _bone(height: 12)),
              const SizedBox(width: 24),
              _bone(width: 80, height: 26, radius: 12),
            ]),
          ]),
        ),
    ]);
    if (MediaQuery.disableAnimationsOf(context)) return skeleton;
    return Shimmer.fromColors(
        baseColor: AppColors.shimmerBase(context),
        highlightColor: AppColors.shimmerHighlight(context),
        child: skeleton);
  }

  Widget _bone({double? width, required double height, double radius = 4}) =>
      Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: AppColors.greyHeader,
              borderRadius: BorderRadius.circular(radius)));
}
