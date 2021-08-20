import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/confirm_dialog.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class LanguageWidgetModel extends BaseViewModel {
  final RxString _currentLanguage = RxString("");

  @override
  void initState() {
    getLocale();
    super.initState();
  }

  void getLocale() {
    _currentLanguage.value =
        EasyLocalization.of(Get.context!)?.locale.languageCode ?? "vi";
  }

  String get currentLanguage => _currentLanguage.value;

  set currentLanguage(String value) {
    _currentLanguage.value = value;
  }

  void onLangSelected(String? lang, BuildContext context) {
    currentLanguage = lang ?? 'vi';
    switch (lang) {
      case 'vi':
        context.setLocale(context.supportedLocales[0]);
        break;
      case 'en':
        context.setLocale(context.supportedLocales[1]);
        break;
    }
    Get.dialog(
      ConfirmDialog(
        title: LocaleKeys.setting_notification.trans(),
        content: LocaleKeys.setting_restart_app.trans(),
        confirmText: LocaleKeys.setting_now.trans(),
        cancelText: LocaleKeys.setting_later.trans(),
        onConfirm: () => exit(0),
        onCancel: () => Get.back(),
      ),
    );
  }
}
