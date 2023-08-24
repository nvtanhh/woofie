import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class CardDetailWidget extends StatelessWidget {
  final String title;
  final String value;

  const CardDetailWidget({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      width: 107.w,
      height: 70.h,
      decoration: BoxDecoration(
        color: UIColor.aliceBlue3,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: UITextStyle.text_body_16_w500,
          ),
          SizedBox(
            height: 10.h,
          ),
          Flexible(
            child: Text(
              value,
              style: UITextStyle.text_header_14_w600,
              maxLines: 1,
              overflow: TextOverflow.clip,
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }
}
