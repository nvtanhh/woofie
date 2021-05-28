import 'package:meowoof/core/ui/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meowoof/theme/ui_color.dart';

enum ToastType { info, warning, success, error }

class ToastService {
  static const Duration toastDuration = Duration(seconds: 1);
  static Color colorError = UIColor.accent;
  static Color colorSuccess = UIColor.accent2;
  static Color colorInfo = UIColor.primary;
  static Color colorWarning = UIColor.waring_color;

  void warning({
    required String message,
    required BuildContext context,
    GlobalKey<ScaffoldState>? scaffoldKey,
    VoidCallback? onDismissed,
    Duration? duration,
  }) {
    toast(message: message, type: ToastType.warning, context: context, duration: duration, onDismissed: onDismissed, scaffoldKey: scaffoldKey);
  }

  void success({
    Widget? child,
    required String message,
    required BuildContext context,
    GlobalKey<ScaffoldState>? scaffoldKey,
    VoidCallback? onDismissed,
    Duration? duration,
  }) {
    toast(
        message: message,
        type: ToastType.success,
        context: context,
        child: child,
        duration: duration,
        onDismissed: onDismissed,
        scaffoldKey: scaffoldKey);
  }

  void error({
    required String message,
    required BuildContext context,
    GlobalKey<ScaffoldState>? scaffoldKey,
    VoidCallback? onDismissed,
    Duration? duration,
  }) {
    toast(message: message, type: ToastType.error, context: context, onDismissed: onDismissed, duration: duration, scaffoldKey: scaffoldKey);
  }

  void info({
    Widget? child,
    required String message,
    required BuildContext context,
    GlobalKey<ScaffoldState>? scaffoldKey,
    VoidCallback? onDismissed,
    Duration? duration,
  }) {
    toast(
        child: child,
        message: message,
        type: ToastType.info,
        context: context,
        duration: duration,
        scaffoldKey: scaffoldKey,
        onDismissed: onDismissed);
  }

  void toast({
    Widget? child,
    required String message,
    required ToastType type,
    required BuildContext context,
    GlobalKey<ScaffoldState>? scaffoldKey,
    VoidCallback? onDismissed,
    Duration? duration,
  }) {
    MFToast.of(context).showToast(child: child, color: _getToastColor(type), message: message, duration: duration, onDismissed: onDismissed);
  }

  Color _getToastColor(ToastType type) {
    var color = colorSuccess;

    switch (type) {
      case ToastType.error:
        color = colorError;
        break;
      case ToastType.info:
        color = colorInfo;
        break;
      case ToastType.success:
        color = colorSuccess;
        break;
      case ToastType.warning:
        color = colorWarning;
        break;
    }

    return color;
  }
}
