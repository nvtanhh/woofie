import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class MedicalActionsTrailing extends StatelessWidget {
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final Widget? child;

  const MedicalActionsTrailing(
      {Key? key, required this.onDelete, required this.onEdit, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MedicalTrailingAction>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      padding: EdgeInsets.zero,
      onSelected: (MedicalTrailingAction action) {
        switch (action) {
          case MedicalTrailingAction.edit:
            if (onEdit != null) onEdit!();
            break;
          case MedicalTrailingAction.delete:
            if (onDelete != null) onDelete!();
            break;
          default:
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<MedicalTrailingAction>(
          value: MedicalTrailingAction.edit,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const MWIcon(
                MWIcons.edit,
                customSize: 20,
              ),
              SizedBox(width: 10.w),
              Text(
                LocaleKeys.profile_edit.trans(),
                style: UITextStyle.body_14_medium,
              ),
            ],
          ),
        ),
        PopupMenuItem<MedicalTrailingAction>(
          value: MedicalTrailingAction.delete,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const MWIcon(
                MWIcons.delete,
                customSize: 20,
              ),
              SizedBox(width: 10.w),
              Text(
                LocaleKeys.profile_delete.trans(),
                style: UITextStyle.body_14_medium,
              ),
            ],
          ),
        ),
      ],
      child: child ??
          Container(
            width: 20.w,
            alignment: Alignment.topRight,
            padding: EdgeInsets.only(top: 5.h),
            child: const MWIcon(
              MWIcons.moreHoriz,
              color: UIColor.textHeader,
            ),
          ),
    );
  }
}

enum MedicalTrailingAction { delete, edit }
