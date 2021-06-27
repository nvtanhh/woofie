import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/auth/domain/usecases/register_usecase.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class RegisterWidgetModel extends BaseViewModel {
  final RegisterUsecase _registerUsecase;
  final RxBool _showPassword = RxBool(false);
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final nameEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  User? user;

  RegisterWidgetModel(this._registerUsecase);

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

  String? nameValidate(String? name) {
    if (name?.isNotEmpty == true) {
      return null;
    }
    return LocaleKeys.register_empty.trans();
  }

  void onEyeClick() {
    showPassword = !showPassword;
  }

  void onRegisterClick() {
    if (formKey.currentState?.validate() == true) {
      call(
        () async {
          user = await _registerUsecase.call(emailEditingController.text, passwordEditingController.text, nameEditingController.text);
        },
        onSuccess: () {
          Fluttertoast.showToast(msg: "Đăng ký thành công");
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

  void onGoToLoginClick() {
    Get.back();
  }

  bool get showPassword => _showPassword.value;

  set showPassword(bool value) {
    _showPassword.value = value;
  }
}
