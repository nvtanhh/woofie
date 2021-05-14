import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/add_pet/app/ui/add_pet_widget.dart';
import 'package:meowoof/modules/auth/app/ui/register/register_widget.dart';
import 'package:meowoof/modules/auth/data/storages/user_storage.dart';
import 'package:meowoof/modules/auth/domain/usecases/check_user_have_pet_usecase.dart';
import 'package:meowoof/modules/auth/domain/usecases/get_user_usecase.dart';
import 'package:meowoof/modules/auth/domain/usecases/login_email_password_usecase.dart';
import 'package:meowoof/modules/home_menu/app/ui/home_menu.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class LoginWidgetModel extends BaseViewModel {
  final LoginWithEmailPasswordUsecase _loginWithEmailPasswordUsecase;
  final CheckUserHavePetUsecase _checkUserHavePetUsecase;
  final UserStorage _userStorage;
  final GetUserUsecase _getUserUsecase;
  final RxBool _showPassword = RxBool(false);
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  User? user;

  LoginWidgetModel(
    this._loginWithEmailPasswordUsecase,
    this._checkUserHavePetUsecase,
    @Named("current_user_storage") this._userStorage,
    this._getUserUsecase,
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
          final haUser = await _getUserUsecase.call(user.uid);
          _userStorage.set(haUser);
          final status = await _checkUserHavePetUsecase.call(haUser.id);
          if (!status) {
            await Get.offAll(() => AddPetWidget());
          } else {
            await Get.offAll(() => HomeMenuWidget());
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

  void checkUserHavePetForNavigator() {
    bool status = true;
    call(
      () async => status = await _checkUserHavePetUsecase.call(),
      onSuccess: () {
        if (status) {
          Get.offAll(AddPetWidget());
        } else {
          //TODO go Home
        }
      },
    );
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
