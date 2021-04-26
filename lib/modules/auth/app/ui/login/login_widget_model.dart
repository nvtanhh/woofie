import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/auth/app/ui/register/register_widget.dart';
import 'package:suga_core/suga_core.dart';
import 'package:meowoof/core/extensions/string_ext.dart';

class LoginWidgetModel extends BaseViewModel {
  RxBool _showPassword = RxBool(false);
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  void onEyeClick() {
    showPassword = !showPassword;
  }

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

  void onLoginClick() {
    if (formKey.currentState.validate()) {
    } else {}
  }

  void onForgotPasswordClick() {}

  bool get showPassword => _showPassword.value;

  set showPassword(bool value) {
    _showPassword.value = value;
  }

  void onRegisterClick() {
    Get.to(()=>RegisterWidget());
  }
}
