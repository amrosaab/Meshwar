import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../common/app_colors.dart';
import 'wallet_content.dart';

class ShimmerWalletHistory extends StatelessWidget {
  const ShimmerWalletHistory({super.key, required this.size});
  final Size size;

  @override
  Widget build(BuildContext context) {
    final base = AppColors.shimmerBase(context);
    Widget bar(double width, double height) => Container(
        width: width,
        height: height,
        decoration:
            BoxDecoration(color: base, borderRadius: BorderRadius.circular(6)));
    final content = Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: WalletStyle.card(context, AppColors.blue),
      child: Row(children: [
        Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
                color: base, borderRadius: BorderRadius.circular(14))),
        const SizedBox(width: 12),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          FractionallySizedBox(
              widthFactor: .85, child: bar(double.infinity, 14)),
          const SizedBox(height: 8),
          FractionallySizedBox(
              widthFactor: .5, child: bar(double.infinity, 10)),
        ])),
        const SizedBox(width: 12),
        bar(45, 14),
      ]),
    );
    if (MediaQuery.disableAnimationsOf(context)) return content;
    return Shimmer.fromColors(
        baseColor: base,
        highlightColor: AppColors.shimmerHighlight(context),
        child: content);
  }
}
