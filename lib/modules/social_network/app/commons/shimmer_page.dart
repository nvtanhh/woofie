import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: UIColor.white,
      highlightColor: UIColor.silverSand,
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: UIColor.white),
          margin: EdgeInsets.only(right: 10.w),
        ),
      ),
    );
  }
}
