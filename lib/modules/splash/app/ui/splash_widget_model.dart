import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/app/ui/welcome/welcome_widget.dart';
import 'package:meowoof/modules/home_menu/app/ui/home_menu.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class SplashWidgetModel extends BaseViewModel {
  final FirebaseAuth _firebaseAuth;
  bool isChecked = false;

  SplashWidgetModel(this._firebaseAuth);

  Future checkLogged() async {
    if (!isChecked) {
      isChecked = true;
      await Future.delayed(const Duration(seconds: 1));
      if (_firebaseAuth.currentUser != null) {
        await Get.offAll(() => HomeMenuWidget());
      } else {
        await Get.offAll(() => WelcomeWidget());
      }
      return;
    }
  }
}
