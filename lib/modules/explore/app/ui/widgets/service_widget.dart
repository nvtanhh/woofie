import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class ServiceWidget extends StatelessWidget {
  final String title;
  final double distance;
  final Widget widget;

  const ServiceWidget({
    Key? key,
    required this.title,
    required this.distance,
    required this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10.w),
      width: 269.w,
      height: 115.h,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), border: Border.all(color: UIColor.text_secondary)),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Row(
          children: [
            widget,
            SizedBox(
              width: 17.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: UITextStyle.text_header_18_w600,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: UIColor.primary,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      "$distance Km",
                      style: UITextStyle.text_header_18_w600,
                    ),
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
