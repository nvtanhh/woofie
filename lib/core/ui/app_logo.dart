import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/assets.gen.dart';

class MWLogo extends StatelessWidget {
  final double? size;
  final double? borderRadius;

  const MWLogo({super.key, this.size, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'woofieapplogo',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
        child: Assets.resources.images.logo.image(height: size, width: size),
      ),
    );
  }
}
