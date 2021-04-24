import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:suga_core/suga_core.dart';

class LoginWidgetModel extends BaseViewModel {
  RxBool _showPassword = RxBool(false);
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  void onEyeClick() {
    showPassword = !showPassword;
  }

  void onLoginClick() {}
  void onForgotPasswordClick() {}
  bool get showPassword => _showPassword.value;

  set showPassword(bool value) {
    _showPassword.value = value;
  }

  void onRegisterClick() {

  }
}
