import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/helpers/unwaited.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/auth/app/ui/register/register_widget.dart';
import 'package:meowoof/modules/auth/domain/usecases/get_user_with_uuid_usecase.dart';
import 'package:meowoof/modules/auth/domain/usecases/login_email_password_usecase.dart';
import 'package:meowoof/modules/auth/domain/usecases/save_user_to_local_usecase.dart';
import 'package:meowoof/modules/social_network/app/add_pet/add_pet_widget.dart';
import 'package:meowoof/modules/social_network/app/home_menu/home_menu.dart';
import 'package:meowoof/modules/social_network/domain/usecases/notification/update_token_notify_usecase.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:suga_core/suga_core.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@injectable
class LoginWidgetModel extends BaseViewModel {
  final LoginWithEmailPasswordUsecase _loginWithEmailPasswordUsecase;
  final GetUserWithUuidUsecase _getUserWithUuidUsecase;
  final SaveUserToLocalUsecase _saveUserToLocalUsecase;
  final RxBool _showPassword = RxBool(false);
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  firebase.User? firebaseUser;
  final UpdateTokenNotifyUsecase _updateTokenNotifyUsecase;
  final LoggedInUser _loggedInUser;

  User? _user;

  LoginWidgetModel(
    this._loginWithEmailPasswordUsecase,
    this._getUserWithUuidUsecase,
    this._saveUserToLocalUsecase,
    this._loggedInUser,
    this._updateTokenNotifyUsecase,
  );

  void onEyeClick() {
    showPassword = !showPassword;
  }

  String? emailValidate(String? email) {
    if (EmailValidator.validate(email ?? "")) {
      return null;
    }
    return LocaleKeys.login_email_invalid.trans();
  }

  String? passwordValidate(String? password) {
    if (RegExp(r'^.{8,}$').hasMatch(password ?? "")) {
      return null;
    }
    return LocaleKeys.login_password_invalid.trans();
  }

  Future login() async {
    firebaseUser = await _loginWithEmailPasswordUsecase.call(
      emailEditingController.text,
      passwordEditingController.text,
    );
  }

  void onLoginClick() {
    if (formKey.currentState?.validate() == true) {
      call(
        () async {
          await login();
          if (firebaseUser != null) {
            _user = await _getUserWithUuidUsecase.call(firebaseUser!.uid);
          }
        },
        onSuccess: () async {
          if (_user != null) {
            unawaited(_loggedInUser.setLoggedUser(_user!));
            unawaited(updateTokenNotify(_user!.uuid!));
            if (!_user!.isHavePets) {
              await Get.offAll(() => const AddPetWidget());
            } else {
              await Get.offAll(() => HomeMenuWidget());
            }
          } else {
            Get.snackbar(
              "Error",
              "User not found!",
              duration: const Duration(seconds: 4),
              backgroundColor: UIColor.primary,
              colorText: UIColor.white,
            );
          }
        },
        onFailure: (error) {
          Get.snackbar(
            "Error",
            (error as firebase.FirebaseAuthException).message ?? error.code,
            duration: const Duration(seconds: 4),
            backgroundColor: UIColor.danger,
            colorText: UIColor.white,
          );
        },
      );
    }
  }

  Future updateTokenNotify(String userUUID) async {
    try {
      await _updateTokenNotifyUsecase.run(userUUID);
    } catch (e) {
      printInfo(info: e.toString());
    }
  }

  void onForgotPasswordClick() {}

  bool get showPassword => _showPassword.value;

  set showPassword(bool value) {
    _showPassword.value = value;
  }

  void onRegisterClick() {
    Get.to(() => RegisterWidget());
  }
}
