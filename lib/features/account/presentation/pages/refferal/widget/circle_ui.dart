import 'package:flutter/material.dart';

class CircleOne extends StatelessWidget {
  const CircleOne({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isDark ? Colors.white : Colors.black)
                    .withAlpha((0.03 * 255).toInt())),
          ),
        ],
      ),
    );
  }
}

class CircleTwo extends StatelessWidget {
  const CircleTwo({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isDark ? Colors.white : Colors.black)
                      .withAlpha((0.03 * 255).toInt()))),
        ],
      ),
    );
  }
}