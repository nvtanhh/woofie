import 'package:flutter/material.dart';
import 'package:meowoof/core/ui/button_widget.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class ButtonLoginWithWidget extends StatelessWidget {
  final Function callBack;
  final String target;
  final double width;
  final double height;

  const ButtonLoginWithWidget({Key key, this.callBack, this.target, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      onPress: callBack,
      width: width,
      height: height,
      contentWidget: Column(
        children: [
          Text(
            LocaleKeys.start_login_with.trans(),
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
