import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget neededDocumentsShimmer(Size size, BuildContext context) {
  return Column(
    children: [
      SizedBox(
        width: size.width * 0.9,
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 16,
            width: double.infinity,
            color: Colors.grey,
          ),
        ),
      ),
      SizedBox(height: size.width * 0.05),
      Column(
        children: List.generate(
            3, (index) => shimmerDocumentPlaceholder(size, context)),
      ),
      SizedBox(height: size.width * 0.05),
      // Shimmer effect for the Submit button
      Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: size.width * 0.9,
          height: size.width * 0.12,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(7),
          ),
        ),
      ),
    ],
  );
}

Widget shimmerDocumentPlaceholder(Size size, BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(bottom: size.width * 0.05),
    child: SizedBox(
      width: size.width * 0.9,
      child: Column(
        children: [
          Row(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: size.width * 0.04,
                  width: size.width * 0.04,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.025),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 16,
                  width: size.width * 0.6,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: size.width * 0.05),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: size.width * 0.07),
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: size.width * 0.14,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.05),
            ],
          ),
        ],
      ),
    ),
  );
}
