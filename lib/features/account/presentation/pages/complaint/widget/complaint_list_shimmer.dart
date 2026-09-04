import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// // Shimmer
class ComplaintShimmer extends StatelessWidget {
  final Size size;

  const ComplaintShimmer({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.03),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: size.width * 0.5,
              height: 20,
              color: Colors.grey[300],
            ),
          ),
          SizedBox(height: size.height * 0.02),
          SizedBox(
            height: size.height * 0.6,
            child: ListView.builder(
              itemCount: 6, // Number of shimmer items
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: size.width * 0.6,
                              height: 20,
                              color: Colors.grey[300],
                            ),
                            Container(
                              width: 15,
                              height: 15,
                              color: Colors.grey[300],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Divider(
                        height: 1,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: size.height * 0.02),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
