import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/add_pet/app/ui/add_pet_widget.dart';
import 'package:meowoof/modules/auth/app/ui/welcome/welcome_widget.dart';
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
        await Get.offAll(() => AddPetWidget());
      } else {
        await Get.offAll(() => WelcomeWidget());
      }
      return;
    }
  }
}
