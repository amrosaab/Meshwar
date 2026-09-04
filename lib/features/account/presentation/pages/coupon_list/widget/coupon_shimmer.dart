import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../common/common.dart';

class CouponShimmer extends StatelessWidget {
  final Size size;

  const CouponShimmer({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final baseColor = AppColors.shimmerBase(context);
    final highlightColor = AppColors.shimmerHighlight(context);

    return SizedBox(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10,
        itemBuilder: (_, index) {
          return Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: size.width * 0.05),
                padding: EdgeInsets.all(size.width * 0.025),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: size.width * 0.0025,
                    color: AppColors.surfaceBorder(context),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Shimmer.fromColors(
                            baseColor: baseColor,
                            highlightColor: highlightColor,
                            child: Container(
                              width: 18,
                              height: 18,
                              color: baseColor,
                            ),
                          ),
                          SizedBox(width: size.width * 0.02),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer.fromColors(
                                baseColor: baseColor,
                                highlightColor: highlightColor,
                                child: Container(
                                  width: size.width * 0.3,
                                  height: 10,
                                  color: baseColor,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Shimmer.fromColors(
                                baseColor: baseColor,
                                highlightColor: highlightColor,
                                child: Container(
                                  width: size.width * 0.25,
                                  height: 10,
                                  color: baseColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Shimmer.fromColors(
                              baseColor: baseColor,
                              highlightColor: highlightColor,
                              child: Container(
                                width: size.width * 0.15,
                                height: 10,
                                color: baseColor,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Shimmer.fromColors(
                              baseColor: baseColor,
                              highlightColor: highlightColor,
                              child: Container(
                                width: size.width * 0.15,
                                height: 10,
                                color: baseColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: size.width * 0.01),
                        Container(
                          height: size.width * 0.1,
                          width: size.width * 0.002,
                          color: baseColor,
                        ),
                        SizedBox(width: size.width * 0.01),
                        Shimmer.fromColors(
                          baseColor: baseColor,
                          highlightColor: highlightColor,
                          child: Container(
                            width: 18,
                            height: 18,
                            color: baseColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}