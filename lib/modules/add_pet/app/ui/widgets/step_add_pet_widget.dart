import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/theme/ui_color.dart';

class StepAddPetWidget extends StatelessWidget {
  final int currentStep = 1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 3.h,
            margin: EdgeInsets.only(right: 5.0.w),
            color: currentStep >= 1 ? UIColor.accent2 : UIColor.text_secondary,
          ),
          Container(
            width: 36.w,
            height: 3.h,
            margin: EdgeInsets.only(right: 5.0.w),
            color: currentStep >= 2 ? UIColor.accent2 : UIColor.text_secondary,
          ),
          Container(
            width: 36.w,
            height: 3.h,
            color: currentStep >= 3 ? UIColor.accent2 : UIColor.text_secondary,
          ),
        ],
      ),
    );
  }
}
