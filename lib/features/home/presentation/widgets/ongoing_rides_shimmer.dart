import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../common/common.dart';

// Shimmer
class OngoingRidesShimmer extends StatelessWidget {
  final Size size;
  const OngoingRidesShimmer({super.key, required this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    margin: EdgeInsets.only(bottom: size.width * 0.02),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.greyHeader)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: AppColors.greyHeader,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Container(
                                    height: 10,
                                    color: AppColors.greyHeader,
                                  ),
                                ),
                              ),
                              Container(
                                width: 50,
                                height: 10,
                                color: AppColors.greyHeader,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: AppColors.greyHeader,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Container(
                                    height: 10,
                                    color: AppColors.greyHeader,
                                  ),
                                ),
                              ),
                              Container(
                                width: 50,
                                height: 10,
                                color: AppColors.greyHeader,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.width * 0.03),
                        Container(
                          padding: EdgeInsets.all(size.width * 0.025),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 10,
                                    color: AppColors.greyHeader,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: AppColors.greyHeader,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      SizedBox(width: size.width * 0.025),
                                      Container(
                                        width: 100,
                                        height: 10,
                                        color: AppColors.greyHeader,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 10,
                                    color: AppColors.greyHeader,
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    width: 80,
                                    height: 10,
                                    color: AppColors.greyHeader,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
