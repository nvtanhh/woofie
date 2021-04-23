import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/ui/button_widget.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
class ButtonLoginWithWidget extends StatelessWidget {
  final Function callBack;
  final String target;
  final double width;
  final double height;
  final Color backgroundColor;

  const ButtonLoginWithWidget({Key key, this.callBack, this.target, this.width, this.height, this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      onPress: callBack,
      width: width,
      height: height,
      backgroundColor: backgroundColor,
      borderRadius: 10.0.r,
      contentWidget: Column(
        children: [
          Text(
            LocaleKeys.welcome_login_with.trans(),
            style: UITextStyle.white_12_w500,
          ),
          Text(
            target,
            style: UITextStyle.white_18_w700,
          ),
        ],
      ),
    );
  }
}
