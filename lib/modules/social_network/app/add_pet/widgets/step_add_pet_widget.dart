import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/theme/ui_color.dart';

class StepAddPetWidget extends StatelessWidget {
  final int currentStep;

  const StepAddPetWidget({
    Key? key,
    required this.currentStep,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36.w,
            height: 3.h,
            margin: EdgeInsets.only(right: 5.0.w),
            color: currentStep >= 1 ? UIColor.accent2 : UIColor.textSecondary,
          ),
          Container(
            width: 36.w,
            height: 3.h,
            margin: EdgeInsets.only(right: 5.0.w),
            color: currentStep >= 2 ? UIColor.accent2 : UIColor.textSecondary,
          ),
          Container(
            width: 36.w,
            height: 3.h,
            color: currentStep >= 3 ? UIColor.accent2 : UIColor.textSecondary,
          ),
        ],
      ),
    );
  }
}
