import 'package:flutter/material.dart';

class VehicleMarkerWidget extends StatelessWidget {
  final String imagePath;
  final double size;

  const VehicleMarkerWidget({
    super.key,
    required this.imagePath,
    this.size = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.5,
      height: size * 1.5,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Uber-style realistic soft shadow
          Container(
            width: size * 0.9,
            height: size * 0.9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
          ),
          // The Car Image - clean and standing out
          Image.asset(
            imagePath,
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
