import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPage extends StatelessWidget {
  final double? width;
  final double? height;

  const ShimmerPage({
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? Get.width,
      height: height ?? Get.height,
      child: Shimmer.fromColors(
        baseColor: UIColor.white,
        highlightColor: UIColor.silverSand,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: UIColor.white,
          ),
        ),
      ),
    );
  }
}
