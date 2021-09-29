import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/theme/ui_color.dart';

class IOSIndicatorWidget extends StatelessWidget {
  const IOSIndicatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60.w,
      height: 3.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: UIColor.textBody,
          borderRadius: BorderRadius.circular(100.r),
        ),
      ),
    );
  }
}
