import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class DivideWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 2.0.h,
            color: UIColor.silverSand,
            margin: EdgeInsets.only(right: 10.w),
          ),
        ),
        Text(
          LocaleKeys.welcome_or.trans(),
          style: UITextStyle.text_body_14_w600,
        ),
        Expanded(
          child: Container(
            height: 2.0.h,
            color: UIColor.silverSand,
            margin: EdgeInsets.only(left: 10.w),
          ),
        ),
      ],
    );
  }
}
