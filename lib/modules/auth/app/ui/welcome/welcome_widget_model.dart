import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/add_pet/app/ui/add_pet_widget.dart';
import 'package:meowoof/modules/auth/app/ui/login/login_widget.dart';
import 'package:meowoof/modules/auth/domain/usecases/check_user_have_pet_usecase.dart';
import 'package:meowoof/modules/auth/domain/usecases/login_with_facebook_usecase.dart';
import 'package:meowoof/modules/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class WelcomeWidgetModel extends BaseViewModel {
  final LoginWithGoogleUsecase _loginWithGoogleUsecase;
  final LoginWithFacebookUsecase _loginWithFacebookUsecase;
  final CheckUserHavePetUsecase _checkUserHavePetUsecase;
  User user;

  WelcomeWidgetModel(this._loginWithGoogleUsecase, this._loginWithFacebookUsecase, this._checkUserHavePetUsecase);

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
        // Get.offAll(() => AddPetWidget());
      },
    );
  }

  void checkUserHavePetForNavigator() {
    bool status;
    call(
      () async => status = await _checkUserHavePetUsecase.call(),
      onSuccess: () {
        if (!status) {
          Get.offAll(AddPetWidget());
        } else {
          //TODO go Home
        }
      },
    );
  }
}
