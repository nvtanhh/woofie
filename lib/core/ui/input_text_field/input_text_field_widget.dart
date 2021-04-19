import 'package:flutter/material.dart';
import 'package:meowoof/core/ui/input_text_field/input_text_field_widget_model.dart';
import 'package:suga_core/suga_core.dart';

class InputTextFieldWidget extends StatefulWidget {
  final double width;
  final Color borderColor;
  final double borderRadius;
  final String hintText;
  final TextStyle hintStyle;
  final bool isObscure;
  final Widget suffixIcon;
  final Widget prefixIcon;
  final TextInputType textInputType;
  final TextAlign align;
  final EdgeInsets contentPadding;
  final TextStyle contentStyle;
  final int maxLength;
  final String text;
  final Function(String) onTextChanged;
  final bool isClearMode;
  final TextEditingController controller;

  const InputTextFieldWidget({
    this.width,
    this.borderColor,
    this.borderRadius,
    this.hintText,
    this.hintStyle,
    this.isObscure,
    this.suffixIcon,
    this.prefixIcon,
    this.textInputType,
    this.align,
    this.contentPadding,
    this.contentStyle,
    this.maxLength,
    this.text,
    this.onTextChanged,
    this.isClearMode = false,
    this.controller,
  });

  @override
  _InputTextFieldWidgetState createState() => _InputTextFieldWidgetState();
}

class _InputTextFieldWidgetState extends BaseViewState<InputTextFieldWidget, InputTextFieldWidgetModel> {
  @override
  void loadArguments() {
    viewModel.width = widget.width;
    viewModel.borderColor = widget.borderColor;
    viewModel.borderRadius = widget.borderRadius;
    viewModel.hintText = widget.hintText;
    viewModel.hintStyle = widget.hintStyle;
    viewModel.isObscure = widget.isObscure;
    viewModel.onTextChanged = widget.onTextChanged;
    viewModel.suffixIcon = widget.suffixIcon;
    viewModel.prefixIcon = widget.prefixIcon;
    viewModel.textInputType = widget.textInputType;
    viewModel.align = widget.align;
    viewModel.text = widget.text;
    viewModel.isClearMode = widget.isClearMode;
    viewModel.contentPadding = widget.contentPadding;
    viewModel.contentStyle = widget.contentStyle;
    viewModel.maxLength = widget.maxLength;
    viewModel.controller = widget.controller ?? TextEditingController();
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    viewModel.updateTextField();
    return SizedBox(
      width: viewModel.width,
      child: TextField(
        controller: viewModel.controller,
        keyboardType: viewModel.textInputType,
        maxLines: viewModel.isObscure ? 1 : null,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: viewModel.borderColor),
            borderRadius: BorderRadius.circular(viewModel.borderRadius),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: viewModel.borderColor),
            borderRadius: BorderRadius.circular(viewModel.borderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: viewModel.borderColor),
            borderRadius: BorderRadius.circular(viewModel.borderRadius),
          ),
          hintText: viewModel.hintText,
          hintStyle: viewModel.hintStyle,
          contentPadding: viewModel.contentPadding,
          suffixIcon: viewModel.getSuffixIcon(),
          prefixIcon: viewModel.prefixIcon,
        ),
        obscureText: viewModel.isObscure,
        onChanged: viewModel.onTextChanged,
        textAlign: viewModel.align,
        style: viewModel.contentStyle,
        maxLength: viewModel.maxLength,
      ),
    );
  }

  @override
  InputTextFieldWidgetModel createViewModel() => InputTextFieldWidgetModel();
}
