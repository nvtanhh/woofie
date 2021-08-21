import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
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
        EasyLocalization.of(context)?.setLocale(const Locale('vi'));
        Get.updateLocale(const Locale('vi'));
        break;
      case 'en':
        EasyLocalization.of(context)?.setLocale(const Locale('en'));
        Get.updateLocale(const Locale('en'));
        break;
    }
  }
}
