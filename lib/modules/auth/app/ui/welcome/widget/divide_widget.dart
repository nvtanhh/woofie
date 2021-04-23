import 'package:flutter/material.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/theme/ui_color.dart';

class DivideWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 2.0.h,
          color: UIColor.silver_sand,
        ),
        Text(LocaleKeys.welcome_or.trans()),
        Container(
          height: 2.0.h,
          color: UIColor.silver_sand,
        ),
      ],
    );
  }
}
