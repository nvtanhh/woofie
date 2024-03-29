import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/theme/ui_color.dart';

class MWButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPressed;
  final bool isDisabled;
  final bool isLoading;
  final MWButtonSize size;
  final double? minWidth;
  final EdgeInsets? padding;
  final ShapeBorder? shape;
  final double? minHeight;
  final List<BoxShadow>? boxShadow;
  final TextStyle? textStyle;
  final Color color;
  final Color textColor;
  final bool outline;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;

  const MWButton(
      {required this.child,
      required this.onPressed,
      this.minHeight,
      this.minWidth,
      this.size = MWButtonSize.medium,
      this.shape,
      this.boxShadow,
      this.isDisabled = false,
      this.isLoading = false,
      this.padding,
      this.textStyle,
      this.color = UIColor.primary,
      this.textColor = UIColor.textBody,
      this.onLongPressed,
      this.outline = false,
      this.borderRadius,
      this.borderColor,
      this.borderWidth,});

  @override
  Widget build(BuildContext context) {
    final buttonPadding = _getButtonPaddingForSize(size);
    final buttonMinWidth = minWidth ?? _getButtonMinWidthForSize(size);
    final buttonMinHeight = minHeight ?? 10;
    final finalOnPressed = isLoading || isDisabled ? () {} : onPressed;
    final finalOnLongPressed = isLoading || isDisabled ? () {} : onLongPressed;

    final buttonChild = isLoading ? _getLoadingIndicator(textColor) : child;

    TextStyle defaultTextStyle =
        _getButtonTextStyleForSize(size: size, color: textColor);

    if (textStyle != null) {
      defaultTextStyle = defaultTextStyle.merge(textStyle);
    }

    Color finalBackgroundColor = color;

    if (isDisabled) {
      finalBackgroundColor = UIColor.disableBg;
      defaultTextStyle.apply(color: UIColor.textBody);
    }

    return GestureDetector(
      onTap: finalOnPressed,
      onLongPress: finalOnLongPressed,
      child: Container(
        constraints: BoxConstraints(
          minWidth: buttonMinWidth,
          minHeight: buttonMinHeight,
        ),
        decoration: BoxDecoration(
            border: outline
                ? Border.all(
                    width: borderWidth ?? 1, color: borderColor ?? textColor,)
                : const Border(),
            boxShadow: boxShadow ?? [],
            color: finalBackgroundColor,
            borderRadius: borderRadius ?? BorderRadius.circular(50.0),),
        child: Material(
          color: Colors.transparent,
          textStyle: defaultTextStyle,
          child: Padding(
            padding: buttonPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[buttonChild],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _getButtonTextStyleForSize(
      {MWButtonSize? size, required Color color,}) {
    TextStyle textStyle = TextStyle(color: color);

    switch (size) {
      case MWButtonSize.large:
        textStyle = textStyle.copyWith(fontSize: 18.sp);
        break;
      case MWButtonSize.medium:
      case MWButtonSize.small:
      default:
    }

    return textStyle;
  }

  Widget _getLoadingIndicator(Color color) {
    return SizedBox(
      height: 16.h,
      width: 16.w,
      child: CircularProgressIndicator(
          strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(color),),
    );
  }

  double _getButtonMinWidthForSize(MWButtonSize size) {
    double buttonMinWidth;

    switch (size) {
      case MWButtonSize.large:
        buttonMinWidth = 140.w;
        break;
      case MWButtonSize.medium:
        buttonMinWidth = 100.w;
        break;
      case MWButtonSize.small:
        buttonMinWidth = 70.w;
        break;
      default:
        buttonMinWidth = 20.w;
    }
    return buttonMinWidth;
  }

  EdgeInsets _getButtonPaddingForSize(MWButtonSize size) {
    if (padding != null) return padding!;

    EdgeInsets buttonPadding;

    switch (size) {
      case MWButtonSize.large:
        buttonPadding = EdgeInsets.symmetric(
          vertical: 10.w,
          horizontal: 10.h,
        );
        break;
      case MWButtonSize.medium:
        buttonPadding = EdgeInsets.symmetric(vertical: 10.h, horizontal: 18.w);
        break;
      case MWButtonSize.small:
        buttonPadding = EdgeInsets.symmetric(vertical: 4.w, horizontal: 10.h);
        break;
      default:
        buttonPadding = const EdgeInsets.all(0);
    }
    return buttonPadding;
  }
}

enum MWButtonSize { small, medium, large }
