import 'package:flutter/material.dart';

class CustomCliper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height + 5);
    path.lineTo(
      size.width - size.width * 0.025,
      size.height - size.height * 0.3,
    );
    path.quadraticBezierTo(
      size.width,
      size.height - size.height * 0.31,
      size.width - 1,
      size.height - size.height * 0.33,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
