import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class NotificationMenuActionWidget extends StatelessWidget {
  final Function onNotification;

  const NotificationMenuActionWidget({super.key, required this.onNotification});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<NotificationMenuAction>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      padding: EdgeInsets.zero,
      onSelected: (NotificationMenuAction action) {
        switch (action) {
          case NotificationMenuAction.delete:
            onNotification();
            break;
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<NotificationMenuAction>(
          value: NotificationMenuAction.delete,
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
      child: Container(
        width: 20.w,
        height: 40.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
        child: const Center(
          child: MWIcon(
            MWIcons.moreHoriz,
          ),
        ),
      ),
    );
  }
}

enum NotificationMenuAction { delete }
