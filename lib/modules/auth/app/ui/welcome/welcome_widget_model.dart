import 'package:get/get.dart';
import 'package:meowoof/modules/auth/app/ui/login/login_widget.dart';
import 'package:suga_core/suga_core.dart';

class WelcomeWidgetModel extends BaseViewModel {
  void onLoginClick() {
    Get.to(LoginWidget());
  }

  void onLoginWithFbClick() {}

  void onLoginGoogleClick() {}
}
