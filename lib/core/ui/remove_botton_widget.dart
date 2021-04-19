import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/theme/ui_color.dart';

class RemoveButtonWidget extends StatelessWidget {
  final Function() onClicked;
  final EdgeInsets padding;

  const RemoveButtonWidget({Key key, this.onClicked, this.padding = const EdgeInsets.all(8)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClicked,
      child: Padding(
        padding: padding,
        child: Container(
          height: 20.0.h,
          width: 20.0.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0.w),
            color: UIColor.red,
          ),
          child: Icon(
            Icons.close,
            color: UIColor.white,
            size: 12.0.w,
          ),
        ),
      ),
    );
  }
}
