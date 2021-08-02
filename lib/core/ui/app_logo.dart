import 'package:flutter/material.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MWLogo extends StatelessWidget {
  final double? size;
  final double? borderRadius;

  const MWLogo({Key? key, this.size, this.borderRadius}) : super(key: key);

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
