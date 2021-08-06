import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/auth/app/ui/welcome/welcome_widget.dart';
import 'package:meowoof/modules/auth/domain/usecases/logout_usecase.dart';
import 'package:meowoof/modules/social_network/app/setting/widgets/laguague/laguage.dart';
import 'package:meowoof/modules/social_network/app/setting/widgets/message/message_page.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class SettingModel extends BaseViewModel {
  final LogoutUsecase _logoutUsecase;
  final RxString _currentLanguage = RxString("");

  SettingModel(this._logoutUsecase);

  @override
  void initState() {
    getLocale();
    super.initState();
  }

  void logOut() {
    call(
      () async => _logoutUsecase.call(),
      onSuccess: () {
        Get.offAll(() => WelcomeWidget());
      },
    );
  }

  void getLocale() {
    _currentLanguage.value = EasyLocalization.of(Get.context!)?.locale.languageCode ?? "vi";
  }

  Future language() async {
    final languageUpdate = await Get.to(() => LanguageWidget());
    if (languageUpdate != null) {
      currentLanguage = languageUpdate as String;
    }
  }

  void notification() {}

  String get currentLanguage => _currentLanguage.value;

  set currentLanguage(String value) {
    _currentLanguage.value = value;
  }

  String defineLanguage(String string) {
    switch (string) {
      case 'vi':
        return LocaleKeys.setting_vietnamese.trans();
      case 'en':
        return LocaleKeys.setting_english.trans();
      default:
        return LocaleKeys.setting_vietnamese.trans();
    }
  }

  void message() {
    Get.to(() => MessagePage());
  }
}
