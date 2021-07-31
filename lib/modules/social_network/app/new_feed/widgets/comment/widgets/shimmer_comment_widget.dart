import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCommentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: UIColor.white,
      highlightColor: UIColor.silverSand,
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: UIColor.white),
              margin: EdgeInsets.only(right: 10.w),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50.w,
                  height: 10.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: UIColor.white),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  width: (Get.width * 0.7).w,
                  height: 60.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      color: UIColor.white),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    Container(
                      width: 50.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: UIColor.white),
                    ),
                    SizedBox(
                      width: 26.w,
                    ),
                    Container(
                      width: 20.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: UIColor.white,
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
