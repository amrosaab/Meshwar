import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BottomSheetShimmer extends StatelessWidget {
  const BottomSheetShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Container(
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.width * 0.15),
            // Category Selector Shimmer
            _buildShimmerItem(
              width: size.width * 0.9,
              height: size.width * 0.12,
              borderRadius: 50,
            ),
            SizedBox(height: size.width * 0.05),

            // "Services" title shimmer
            _buildShimmerItem(
              width: size.width * 0.3,
              height: size.width * 0.05,
              borderRadius: 4,
            ),
            SizedBox(height: size.width * 0.03),

            // Services Grid Shimmer (4 items row)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                  4,
                  (index) => _buildShimmerItem(
                        width: size.width * 0.21,
                        height: size.width * 0.25,
                        borderRadius: 16,
                      )),
            ),
            SizedBox(height: size.width * 0.05),

            // Search Bar Shimmer
            _buildShimmerItem(
              width: size.width * 0.9,
              height: size.width * 0.12,
              borderRadius: 12,
            ),
            SizedBox(height: size.width * 0.05),

            // Recent Search Title Shimmer
            _buildShimmerItem(
              width: size.width * 0.4,
              height: size.width * 0.05,
              borderRadius: 4,
            ),
            SizedBox(height: size.width * 0.03),

            // Recent Searches List Shimmer
            Column(
              children: List.generate(
                  3,
                  (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          children: [
                            _buildShimmerItem(
                              width: 20,
                              height: 20,
                              borderRadius: 10,
                            ),
                            SizedBox(width: size.width * 0.03),
                            Expanded(
                              child: _buildShimmerItem(
                                width: double.infinity,
                                height: size.width * 0.04,
                                borderRadius: 4,
                              ),
                            ),
                          ],
                        ),
                      )),
            ),
            SizedBox(height: size.width * 0.1),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerItem({
    required double width,
    required double height,
    required double borderRadius,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
