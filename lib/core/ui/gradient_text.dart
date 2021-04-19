import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;
  final Gradient gradient;
  final double size;
  final FontWeight weight;

  const GradientText(
    this.text, {
    @required this.gradient,
    this.size,
    this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: size, fontWeight: weight),
      ),
    );
  }
}
