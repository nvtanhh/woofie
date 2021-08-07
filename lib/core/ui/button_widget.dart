import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class ButtonWidget extends StatefulWidget {
  final Function() onPress;
  final String? title;
  final Color? backgroundColor;
  final double? borderRadius;
  final double? height;
  final double? width;
  final TextStyle? titleStyle;
  final Widget? contentWidget;
  final Color? borderColor;
  final Widget? loadingWidget;
  final EdgeInsets? contentPadding;

  const ButtonWidget({
    required this.onPress,
    this.title,
    this.backgroundColor,
    this.borderRadius,
    this.height,
    this.width,
    this.titleStyle,
    this.contentWidget,
    this.borderColor,
    this.loadingWidget,
    this.contentPadding,
  });

  @override
  _ButtonWidgetState createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? widget.loadingWidget ?? Container()
        : Container(
            height: widget.height ?? 50.0.w,
            width: widget.width ?? 320.0.w,
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? UIColor.primary,
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 5.0.w),
              border: widget.borderColor != null
                  ? Border.all(color: widget.borderColor!)
                  : null,
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: widget.contentPadding ?? EdgeInsets.zero,
              ),
              onPressed: () async {
                if (widget.onPress is Future Function()) {
                  setState(() {
                    isLoading = true;
                  });
                  await widget.onPress();
                  if (mounted) {
                    setState(() {
                      isLoading = false;
                    });
                  }
                } else if (widget.onPress is Function()) {
                  widget.onPress();
                }
              },
              child: widget.contentWidget ??
                  Center(
                    child: Text(
                      widget.title ?? "",
                      style: widget.titleStyle ?? UITextStyle.white_18_w600,
                    ),
                  ),
            ),
          );
  }
}
