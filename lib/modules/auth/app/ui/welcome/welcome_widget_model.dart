import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/modules/auth/app/ui/login/login_widget.dart';
import 'package:meowoof/modules/auth/domain/usecases/check_user_have_pet_usecase.dart';
import 'package:meowoof/modules/auth/domain/usecases/get_user_with_uuid_usecase.dart';
import 'package:meowoof/modules/auth/domain/usecases/login_with_facebook_usecase.dart';
import 'package:meowoof/modules/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:meowoof/modules/auth/domain/usecases/save_user_to_local_usecase.dart';
import 'package:meowoof/modules/social_network/app/add_pet/add_pet_widget.dart';
import 'package:meowoof/modules/social_network/app/home_menu/home_menu.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart' as hasura_user;
import 'package:meowoof/modules/social_network/domain/usecases/notification/update_token_notify_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class WelcomeWidgetModel extends BaseViewModel {
  final LoginWithGoogleUsecase _loginWithGoogleUsecase;
  final LoginWithFacebookUsecase _loginWithFacebookUsecase;
  final CheckUserHavePetUsecase _checkUserHavePetUsecase;
  User? user;
  final GetUserWithUuidUsecase _getUserUsecase;
  final FirebaseAuth _firebaseAuth;
  final SaveUserToLocalUsecase _saveUserToLocalUsecase;
  final UpdateTokenNotifyUsecase _updateTokenNotifyUsecase;
  final ToastService _toastService;

  WelcomeWidgetModel(
    this._loginWithGoogleUsecase,
    this._loginWithFacebookUsecase,
    this._checkUserHavePetUsecase,
    this._getUserUsecase,
    this._firebaseAuth,
    this._saveUserToLocalUsecase,
    this._updateTokenNotifyUsecase,
    this._toastService,
  );

  void onLoginClick() {
    Get.to(() => LoginWidget());
  }

  Future onLoginWithFbClick() async {
    await call(() async => user = await _loginWithFacebookUsecase.call(), onSuccess: () {
      checkUserHavePetForNavigator();
    }, onFailure: (err) {
      printError(
        info: err.toString(),
      );
    });
  }

  Future onLoginGoogleClick() async {
    await call(() async {
      user = await _loginWithGoogleUsecase.call();
      await Future.delayed(
        const Duration(
          seconds: 3,
        ),
      );
    }, onSuccess: () {
      checkUserHavePetForNavigator();
    }, onFailure: (err) {
      _toastService.error(message: "Login fail", context: Get.context!);
      printError(
        info: err.toString(),
      );
    });
  }

  Future updateTokenNotify(String userUUID) async {
    try {
      await _updateTokenNotifyUsecase.run(userUUID);
    } catch (e) {
      printInfo(info: e.toString());
    }
  }

  Future checkUserHavePetForNavigator() async {
    bool status = false;
    await call(
      () async {
        final hasura_user.User? haUser = await _getUserUsecase.call(user!.uid);
        if (haUser != null) {
          await _saveUserToLocalUsecase.call(haUser);
          status = await _checkUserHavePetUsecase.call(haUser.uuid!);
          await updateTokenNotify(haUser.uuid!);
        } else {
          return;
        }
      },
      onSuccess: () {
        if (!status) {
          Get.offAll(() => const AddPetWidget());
        } else {
          Get.offAll(() => HomeMenuWidget());
        }
      },
      onFailure: (err) {
        _firebaseAuth.currentUser?.getIdToken(true);
        checkUserHavePetForNavigator();
      },
    );
  }
}
