import 'package:flutter/material.dart';

class KeyboardHelper {
  static void hideKeyboard() {
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
  }
}
