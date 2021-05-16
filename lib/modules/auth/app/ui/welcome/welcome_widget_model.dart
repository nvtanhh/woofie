import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/add_pet/app/ui/add_pet_widget.dart';
import 'package:meowoof/modules/auth/app/ui/login/login_widget.dart';
import 'package:meowoof/modules/auth/data/storages/user_storage.dart';
import 'package:meowoof/modules/auth/domain/models/user.dart' as hasura_user;
import 'package:meowoof/modules/auth/domain/usecases/check_user_have_pet_usecase.dart';
import 'package:meowoof/modules/auth/domain/usecases/get_user_usecase.dart';
import 'package:meowoof/modules/auth/domain/usecases/login_with_facebook_usecase.dart';
import 'package:meowoof/modules/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:meowoof/modules/home_menu/app/ui/home_menu.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class WelcomeWidgetModel extends BaseViewModel {
  final LoginWithGoogleUsecase _loginWithGoogleUsecase;
  final LoginWithFacebookUsecase _loginWithFacebookUsecase;
  final CheckUserHavePetUsecase _checkUserHavePetUsecase;
  User? user;
  final GetUserUsecase _getUserUsecase;
  final UserStorage _userStorage;
  final FirebaseAuth _firebaseAuth;

  WelcomeWidgetModel(
    this._loginWithGoogleUsecase,
    this._loginWithFacebookUsecase,
    this._checkUserHavePetUsecase,
    this._getUserUsecase,
    @Named("current_user_storage") this._userStorage,
    this._firebaseAuth,
  );

  void onLoginClick() {
    Get.to(() => LoginWidget());
  }

  Future onLoginWithFbClick() async {
    await call(
      () async => user = await _loginWithFacebookUsecase.call(),
      onSuccess: () {
        checkUserHavePetForNavigator();
      },
    );
  }

  Future onLoginGoogleClick() async {
    await call(
      () async => user = await _loginWithGoogleUsecase.call(),
      onSuccess: () {
        checkUserHavePetForNavigator();
      },
    );
  }

  Future checkUserHavePetForNavigator() async {
    bool status = false;
    await call(() async {
      await Future.delayed(const Duration(seconds: 2));
      final hasura_user.User? haUser = await _getUserUsecase.call(user!.uid);
      if (haUser != null) {
        status = await _checkUserHavePetUsecase.call(haUser.id!);
        _userStorage.set(haUser);
      } else {
        return;
      }
    }, onSuccess: () {
      if (!status) {
        Get.offAll(() => AddPetWidget());
      } else {
        Get.offAll(() => HomeMenuWidget());
      }
    }, onFailure: (err) {
      _firebaseAuth.currentUser?.getIdToken(true);
      checkUserHavePetForNavigator();
    });
  }
}
