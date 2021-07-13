import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/app/ui/welcome/welcome_widget.dart';
import 'package:meowoof/modules/auth/data/storages/user_storage.dart';
import 'package:meowoof/modules/social_network/app/home_menu/home_menu.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class SplashWidgetModel extends BaseViewModel {
  final FirebaseAuth _firebaseAuth;
  final UserStorage _userStorage;
  bool isChecked = false;

  SplashWidgetModel(this._firebaseAuth, this._userStorage);

  Future checkLogged() async {
    if (!isChecked) {
      isChecked = true;
      final user = _userStorage.get();
      await Future.delayed(const Duration(seconds: 1));
      if (_firebaseAuth.currentUser != null && user != null) {
        await Get.offAll(() => HomeMenuWidget());
      } else {
        await Get.offAll(() => WelcomeWidget());
      }
      return;
    }
  }
}
