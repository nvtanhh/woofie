import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/setting/setting_model.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends BaseViewState<Setting, SettingModel> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                      icon: const MWIcon(MWIcons.back),
                      onPressed: () => Get.back(),),
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
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 10),
                child: Text(
                  LocaleKeys.setting_application.trans(),
                  style: UITextStyle.text_header_14_w600,
                ),
              ),
              ListTile(
                onTap: () => viewModel.language(),
                leading: const MWIcon(MWIcons.language),
                title: Obx(
                  () => Text(
                    LocaleKeys.setting_language.trans(args: [
                      viewModel.defineLanguage(viewModel.currentLanguage)
                    ],),
                    style: UITextStyle.text_body_14_w500,
                  ),
                ),
              ),
              // ListTile(
              //   onTap: () => viewModel.notification(),
              //   leading: const MWIcon(MWIcons.notificaiton),
              //   title: Text(
              //     LocaleKeys.setting_notification.trans(),
              //     style: UITextStyle.text_body_14_w500,
              //   ),
              // ),
              ListTile(
                onTap: () => viewModel.message(),
                leading: MWIcon(
                  MWIcons.message,
                ),
                title: Text(
                  LocaleKeys.setting_message.trans(),
                  style: UITextStyle.text_body_14_w500,
                ),
              ),
              // SizedBox(height: 10.h),
              // Padding(
              //   padding: const EdgeInsets.only(left: 16, bottom: 10),
              //   child: Text(
              //     LocaleKeys.setting_other_setting.trans(),
              //     style: UITextStyle.text_header_14_w600,
              //   ),
              // ),
              // ListTile(
              //   leading: const MWIcon(MWIcons.feedback),
              //   title: Text(
              //     LocaleKeys.setting_rate_feedback.trans(),
              //     style: UITextStyle.text_body_14_w500,
              //   ),
              // ),
            ],
          ),
          ListTile(
            onTap: () => viewModel.logOut(),
            leading: const MWIcon(MWIcons.logout),
            title: Text(
              LocaleKeys.setting_logout.trans(),
              style: UITextStyle.text_body_14_w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  SettingModel createViewModel() => injector<SettingModel>();
}
