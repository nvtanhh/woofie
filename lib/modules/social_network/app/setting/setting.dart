import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(icon: const MWIcon(MWIcons.back), onPressed: () => Get.back()),
              Expanded(
                child: Text(
                  LocaleKeys.setting_setting.trans(),
                  style: UITextStyle.text_header_18_w700,
                ),
              )
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Text(
            LocaleKeys.setting_application.trans(),
            style: UITextStyle.text_header_14_w600,
          ),
          ListTile(
            leading: MWIcon(MWIcons.language),
            title: Text(
              LocaleKeys.setting_application.trans(),
              style: UITextStyle.text_body_14_w500,
            ),
          ),
          ListTile(
            leading: MWIcon(MWIcons.notificaiton),
            title: Text(
              LocaleKeys.setting_notification.trans(),
              style: UITextStyle.text_body_14_w500,
            ),
          ),
          Text(
            LocaleKeys.setting_other_setting.trans(),
            style: UITextStyle.text_header_14_w600,
          ),
        ],
      ),
    );
  }
}
