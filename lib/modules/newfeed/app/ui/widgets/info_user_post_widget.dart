import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class InfoUserPostWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.w,
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: UIColor.primary,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Column(
              children: [
                TextSpan(
                  text: "",
                  children: []
                ),
                Text(
                  "",
                  style: UITextStyle.text_secondary_12_w500,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert_sharp,
              size: 24.w,
            ),
            onPressed: () => null,
          ),
        ],
      ),
    );
  }
}
