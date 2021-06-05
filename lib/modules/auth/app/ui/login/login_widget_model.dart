import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/auth/app/ui/register/register_widget.dart';
import 'package:meowoof/modules/auth/domain/usecases/check_user_have_pet_usecase.dart';
import 'package:meowoof/modules/auth/domain/usecases/get_user_usecase.dart';
import 'package:meowoof/modules/auth/domain/usecases/login_email_password_usecase.dart';
import 'package:meowoof/modules/auth/domain/usecases/save_user_to_local_usecase.dart';
import 'package:meowoof/modules/social_network/app/add_pet/add_pet_widget.dart';
import 'package:meowoof/modules/social_network/app/home_menu/home_menu.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:suga_core/suga_core.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart' as hasura_user;
@injectable
class LoginWidgetModel extends BaseViewModel {
  final LoginWithEmailPasswordUsecase _loginWithEmailPasswordUsecase;
  final CheckUserHavePetUsecase _checkUserHavePetUsecase;
  final GetUserUsecase _getUserUsecase;
  final SaveUserToLocalUsecase _saveUserToLocalUsecase;
  final RxBool _showPassword = RxBool(false);
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  User? user;

  LoginWidgetModel(
    this._loginWithEmailPasswordUsecase,
    this._checkUserHavePetUsecase,
    this._getUserUsecase, this._saveUserToLocalUsecase,
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
    user = await _loginWithEmailPasswordUsecase.call(
      emailEditingController.text,
      passwordEditingController.text,
    );
  }

  void onLoginClick() {
    if (formKey.currentState?.validate() == true) {
      call(
        () async {
          await login();
          if (user != null) {
            final hasura_user.User? haUser = await _getUserUsecase.call(user!.uid);
            if (haUser != null) {
              await _saveUserToLocalUsecase.call(haUser);
              final status = await _checkUserHavePetUsecase.call(haUser.id);
              if (!status) {
                await Get.offAll(() => AddPetWidget());
              } else {
                await Get.offAll(() => HomeMenuWidget());
              }
            }else{
              Get.snackbar(
                "Error",
                "User not found!",
                duration: const Duration(seconds: 4),
                backgroundColor: UIColor.primary,
                colorText: UIColor.white,
              );
            }
          }
        },
        onFailure: (err) {
          Get.snackbar(
            "Error",
            (err as FirebaseAuthException).code,
            duration: const Duration(seconds: 4),
            backgroundColor: UIColor.primary,
            colorText: UIColor.white,
          );
        },
      );
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
