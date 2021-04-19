import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputTextFieldWidgetModel extends BaseViewModel {
  double _width;
  Color _borderColor;
  double _borderRadius;
  String _hintText;
  TextStyle _hintStyle;
  bool _isObscure;
  Widget _suffixIcon;
  Widget _prefixIcon;
  TextInputType _textInputType;
  TextAlign _align;
  String text;
  Function(String) onTextChanged;
  bool isClearMode;
  EdgeInsets _contentPadding;
  TextStyle _contentStyle;
  int _maxLength;

  double get width => _width ?? 320.0.w;

  set width(double value) => _width = value;

  Color get borderColor => _borderColor ?? UIColor.lightBlueBorder;

  set borderColor(Color value) => _borderColor = value;

  double get borderRadius => _borderRadius ?? 5.0.w;

  set borderRadius(double value) => _borderRadius = value;

  String get hintText => _hintText ?? "";

  set hintText(String value) => _hintText = value;

  TextStyle get hintStyle => _hintStyle ?? UITextStyle.lightDarkBluePlaceHolder_16_w400;

  set hintStyle(TextStyle value) => _hintStyle = value;

  bool get isObscure => _isObscure ?? false;

  set isObscure(bool value) => _isObscure = value;

  Widget get suffixIcon => _suffixIcon; // ignore: unnecessary_getters_setters
  set suffixIcon(Widget value) => _suffixIcon = value; // ignore: unnecessary_getters_setters
  Widget get prefixIcon => _prefixIcon; // ignore: unnecessary_getters_setters
  set prefixIcon(Widget value) => _prefixIcon = value; // ignore: unnecessary_getters_setters
  TextInputType get textInputType => _textInputType ?? TextInputType.text;

  set textInputType(TextInputType value) => _textInputType = value;

  TextAlign get align => _align ?? TextAlign.start;

  set align(TextAlign value) => _align = value;

  EdgeInsets get contentPadding => _contentPadding ?? EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 16.0.h);

  set contentPadding(EdgeInsets value) => _contentPadding = value;

  TextStyle get contentStyle => _contentStyle ?? UITextStyle.mediumBlack_16_w400;

  set contentStyle(TextStyle style) => _contentStyle = style;

  int get maxLength => _maxLength; // ignore: unnecessary_getters_setters
  set maxLength(int value) => _maxLength = value; // ignore: unnecessary_getters_setters

  TextEditingController controller;

  RxBool showClearButtonObx = false.obs;

  bool get shouldShowClearButton => showClearButtonObx.value;

  @override
  void initState() {
    super.initState();
    controller.addListener(onCheckShowClearButton);
  }

  void onCheckShowClearButton() {
    showClearButtonObx.value = isClearMode && controller.text.isNotEmpty;
  }

  void updateTextField() {
    controller.text = text;
    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
  }

  void onClearButtonClicked() {
    controller.text = "";
  }

  Widget getSuffixIcon() {
    if (isClearMode ?? false) {
      return Obx(
        () => shouldShowClearButton
            ? IconButton(
                icon: Icon(Icons.close, color: UIColor.lightDarkBluePlaceHolder, size: 18.0.w),
                onPressed: onClearButtonClicked,
              )
            : suffixIcon ?? const SizedBox(),
      );
    }
    return suffixIcon;
  }
}
