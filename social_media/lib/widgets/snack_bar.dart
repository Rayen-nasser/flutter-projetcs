import 'package:flutter/material.dart';

class GradientSnackBar extends StatelessWidget {
  final String message;
  final Color? textColor;
  final List<Color> gradientColors;

  GradientSnackBar({
    required this.message,
    this.textColor,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        message,
        style: TextStyle(color: textColor ?? Colors.white),
      ),
    );
  }
}
