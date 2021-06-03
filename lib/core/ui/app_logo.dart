import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/theme/ui_color.dart';

class MWLogo extends StatelessWidget {
  const MWLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UIColor.primary,
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }
}
