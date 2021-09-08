import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/ui/button.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class ConfirmDialog extends StatelessWidget {
  final String? title;
  final String content;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final String? cancelText;
  final String? confirmText;

  const ConfirmDialog({
    Key? key,
    required this.content,
    this.title,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.confirmText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      actionsPadding: EdgeInsets.only(bottom: 8.h),
      title: title != null
          ? Text(
              title!,
              style: UITextStyle.text_header_16_w500,
            )
          : const SizedBox(),
      content: Text(
        content,
        style: UITextStyle.body_14_medium,
      ),
      actions: <Widget>[
        GestureDetector(
          onTap: () {
            if (onCancel != null) onCancel!();
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: EdgeInsets.all(8.0.h),
            child: Text(
              cancelText ?? 'Cancel',
              style: UITextStyle.text_body_14_w500,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.w, right: 8.w),
          child: MWButton(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            onPressed: () {
              if (onConfirm != null) onConfirm!();
              Navigator.of(context).pop();
            },
            minWidth: 0,
            borderRadius: BorderRadius.circular(10.r),
            child: Text(
              confirmText ?? 'Confirm',
              style: UITextStyle.white_14_w500,
            ),
          ),
        )
      ],
    );
  }
}
