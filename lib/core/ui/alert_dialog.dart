import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SGAlertDialog extends StatelessWidget {
  final Widget body;
  final bool transparentMode;

  const SGAlertDialog({this.body, this.transparentMode = false});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: transparentMode
          ? body
          : Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    5.0.w,
                  ),
                ),
                child: body,
              ),
            ),
    );
  }
}
