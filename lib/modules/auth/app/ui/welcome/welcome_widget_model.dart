import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/app/ui/login/login_widget.dart';
import 'package:meowoof/modules/auth/domain/usecases/login_with_facebook_usecase.dart';
import 'package:meowoof/modules/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class WelcomeWidgetModel extends BaseViewModel {
  final LoginWithGoogleUsecase _loginWithGoogleUsecase;
  final LoginWithFacebookUsecase _loginWithFacebookUsecase;
  User user;

  WelcomeWidgetModel(this._loginWithGoogleUsecase, this._loginWithFacebookUsecase);

  void onLoginClick() {
    Get.to(() => LoginWidget());
  }

  Future onLoginWithFbClick() async {
    await call(
      () async => user = await _loginWithFacebookUsecase.call(),
      onSuccess: () {

      },
    );
  }

  Future onLoginGoogleClick() async {
    await call(
      () async => user = await _loginWithGoogleUsecase.call(),
      onSuccess: () {

      },
    );
  }
}
