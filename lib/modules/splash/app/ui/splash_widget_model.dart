import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/unwaited.dart';
import 'package:meowoof/modules/auth/app/ui/welcome/welcome_widget.dart';
import 'package:meowoof/modules/auth/data/storages/user_storage.dart';
import 'package:meowoof/modules/auth/domain/usecases/get_user_with_uuid_usecase.dart';
import 'package:meowoof/modules/social_network/app/home_menu/home_menu.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class SplashWidgetModel extends BaseViewModel {
  final firebase.FirebaseAuth _firebaseAuth;
  final UserStorage _userStorage;
  final GetUserWithUuidUsecase _getUserWithUuidUsecase;
  bool isChecked = false;

  SplashWidgetModel(
    this._firebaseAuth,
    this._userStorage,
    this._getUserWithUuidUsecase,
  );

  Future checkLogged() async {
    if (!isChecked) {
      isChecked = true;
      final user = _userStorage.get();
      await Future.delayed(const Duration(seconds: 1));
      if (_firebaseAuth.currentUser != null && user != null) {
        unawaited(_refreshUser(user));
        await Get.offAll(() => HomeMenuWidget());
      } else {
        await Get.offAll(() => WelcomeWidget());
      }
      return;
    }
  }

  Future<void> _refreshUser(User user) async {
    final refreshedUser = await _getUserWithUuidUsecase.call(user.uuid);
    _userStorage.set(refreshedUser);
  }
}
