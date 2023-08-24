import 'package:flutter/material.dart';
import 'package:meowoof/theme/ui_color.dart';

class MWProgressIndicator extends StatelessWidget {
  final Color? color;
  final double size;

  const MWProgressIndicator({super.key, this.color, this.size = 20.0});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: size,
        maxWidth: size,
      ),
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? UIColor.primary),
      ),
    );
  }
}
