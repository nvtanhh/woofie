import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:suga_core/suga_core.dart';

class RegisterWidgetModel extends BaseViewModel {
  RxBool _showPassword = RxBool(false);
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final nameEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String emailValidate(String email) {
    if (EmailValidator.validate(email)) {
      return null;
    }
    return LocaleKeys.login_email_invalid.trans();
  }

  String passwordValidate(String password) {
    if (RegExp(r'^.{8,}$').hasMatch(password)) {
      return null;
    }
    return LocaleKeys.login_password_invalid.trans();
  }

  String nameValidate(String name) {
    if (name.isNotEmpty) {
      return null;
    }
    return LocaleKeys.register_empty.trans();
  }

  void onEyeClick() {
    showPassword = !showPassword;
  }

  void onRegisterClick() {
    if (formKey.currentState.validate()) {
    } else {}
  }

  void onGoToLoginClick() {
    Get.back();
  }

  void onForgotPasswordClick() {}

  bool get showPassword => _showPassword.value;

  set showPassword(bool value) {
    _showPassword.value = value;
  }
}
