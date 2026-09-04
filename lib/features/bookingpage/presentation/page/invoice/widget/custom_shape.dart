import 'package:flutter/material.dart';

class ShapePainterBottom extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.35);
    path.quadraticBezierTo(size.width * 0.985, size.height * 0.25,
        size.width * 0.8, size.height * 0.225);
    path.lineTo(size.width * 0.15, size.height * 0.13);
    path.quadraticBezierTo(size.width * 0, size.height * 0.1, 0, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class ShapePainterCenter extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height * 0.125);
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(0, size.height, 20, size.height);
    path.lineTo(size.width - 20, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 20);
    path.lineTo(size.width * 0.99, size.height * 0.335);
    path.quadraticBezierTo(size.width * 0.965, size.height * 0.25,
        size.width * 0.8, size.height * 0.23);
    path.lineTo(10, size.height * 0.123);
    path.quadraticBezierTo(size.width * 0.0, size.height * 0.12,
        size.width * 0.0, size.height * 0.14);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
