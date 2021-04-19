import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/core/extensions/double_ext.dart';
class UITextStyle {
  UITextStyle._();

  static TextStyle mediumBlack_12_w400 = TextStyle(color: UIColor.mediumBlack, fontSize: 12.0.textSize(), fontWeight: FontWeight.w400);
  static TextStyle red_12_w400 = TextStyle(color: UIColor.red, fontSize: 12.0.textSize(), fontWeight: FontWeight.w400);
  static TextStyle mediumDarkBlue_12_w400 = TextStyle(color: UIColor.mediumDarkBlue, fontSize: 12.0.textSize(), fontWeight: FontWeight.w400);
  static TextStyle mediumDarkBlue_12_w400_underline =
      TextStyle(color: UIColor.mediumDarkBlue, fontSize: 12.0.textSize(), fontWeight: FontWeight.w400, decoration: TextDecoration.underline);
  static TextStyle mediumDarkCyan_12_w400 = TextStyle(color: UIColor.mediumDarkCyan, fontSize: 12.0.textSize(), fontWeight: FontWeight.w400);
  static TextStyle lightDarkBluePlaceHolder_12_w400 =
      TextStyle(color: UIColor.lightDarkBluePlaceHolder, fontSize: 12.0.textSize(), fontWeight: FontWeight.w400);
  static TextStyle mediumDarkCyan_12_bold = TextStyle(color: UIColor.mediumDarkCyan, fontSize: 12.0.textSize(), fontWeight: FontWeight.bold);

  static TextStyle mediumDarkBlue_14_w400 = TextStyle(color: UIColor.mediumDarkBlue, fontSize: 14.0.textSize(), fontWeight: FontWeight.w400);
  static TextStyle lightDarkBluePlaceHolder_14_w400 =
      TextStyle(color: UIColor.lightDarkBluePlaceHolder, fontSize: 14.0.textSize(), fontWeight: FontWeight.w400);
  static TextStyle skyBlue_14_w400 = TextStyle(color: UIColor.skyBlue, fontSize: 14.0.textSize(), fontWeight: FontWeight.w400);
  static TextStyle white_14_w700 = TextStyle(color: UIColor.white, fontSize: 14.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle lightDarkBluePlaceHolder_14_w700_underline = TextStyle(
      color: UIColor.lightDarkBluePlaceHolder, fontSize: 14.0.textSize(), fontWeight: FontWeight.w700, decoration: TextDecoration.underline);
  static TextStyle mediumDarkBlue_14 = TextStyle(color: UIColor.mediumDarkBlue, fontSize: 14.0.textSize(), fontWeight: FontWeight.normal);
  static TextStyle mediumDarkBlue_14_bold = TextStyle(color: UIColor.mediumDarkBlue, fontSize: 14.0.textSize(), fontWeight: FontWeight.bold);
  static TextStyle lightDarkBluePlaceHolder_14_w700_linethrough = TextStyle(
      color: UIColor.lightDarkBluePlaceHolder, fontSize: 14.0.textSize(), fontWeight: FontWeight.w700, decoration: TextDecoration.lineThrough);

  static TextStyle lightBlueBorder_16_w400 = TextStyle(color: UIColor.lightBlueBorder, fontSize: 16.0.textSize(), fontWeight: FontWeight.w400);
  static TextStyle mediumBlack_16_w400 = TextStyle(color: UIColor.mediumBlack, fontSize: 16.0.textSize(), fontWeight: FontWeight.w400);
  static TextStyle mediumDarkCyan_16_w400 = TextStyle(color: UIColor.mediumDarkCyan, fontSize: 16.0.textSize(), fontWeight: FontWeight.w400);
  static TextStyle lightDarkBluePlaceHolder_16_w400 =
      TextStyle(color: UIColor.lightDarkBluePlaceHolder, fontSize: 16.0.textSize(), fontWeight: FontWeight.w400);
  static TextStyle mediumDarkBlue_16_w400 = TextStyle(color: UIColor.mediumDarkBlue, fontSize: 16.0.textSize(), fontWeight: FontWeight.w400);
  static TextStyle white_16_w400 = TextStyle(color: UIColor.white, fontSize: 16.0.textSize(), fontWeight: FontWeight.w400);
  static TextStyle mediumDarkBlue_16_w700 = TextStyle(color: UIColor.mediumDarkBlue, fontSize: 16.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle white_16_w700 = TextStyle(color: UIColor.white, fontSize: 16.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle skyBlue_16_w700 = TextStyle(color: UIColor.skyBlue, fontSize: 16.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle skyBlue_16_w400 = TextStyle(color: UIColor.skyBlue, fontSize: 16.0.textSize(), fontWeight: FontWeight.w400);
  static TextStyle gray_16_w700 = TextStyle(color: UIColor.gray, fontSize: 16.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle red_16_w700 = TextStyle(color: UIColor.red, fontSize: 16.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle pink_16_w700 = TextStyle(color: UIColor.pink, fontSize: 16.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle mediumBlack_16_w700 = TextStyle(color: UIColor.mediumBlack, fontSize: 16.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle lightBlueBorder_16_w700 = TextStyle(color: UIColor.lightBlueBorder, fontSize: 16.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle lightDarkBluePlaceHolder_16_w700_underline = TextStyle(
      color: UIColor.lightDarkBluePlaceHolder, fontSize: 16.0.textSize(), fontWeight: FontWeight.w700, decoration: TextDecoration.underline);
  static TextStyle mediumDarkCyan_16_bold = TextStyle(color: UIColor.mediumDarkCyan, fontSize: 16.0.textSize(), fontWeight: FontWeight.bold);
  static TextStyle orange_16_w700 = TextStyle(color: UIColor.orange, fontSize: 16.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle lightDarkBlueBorderline_16_w700 =
      TextStyle(color: UIColor.lightDarkBlueBorderline, fontSize: 16.0.textSize(), fontWeight: FontWeight.w700);

  static TextStyle lightDarkBluePlaceHolder_18_w400 =
      TextStyle(color: UIColor.lightDarkBluePlaceHolder, fontSize: 18.0.textSize(), fontWeight: FontWeight.w400);
  static TextStyle cyanBlue_18_w700 = TextStyle(color: UIColor.cyanBlue, fontSize: 18.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle mediumDarkBlue_18_bold = TextStyle(color: UIColor.mediumDarkBlue, fontSize: 18.0.textSize(), fontWeight: FontWeight.bold);

  static TextStyle skyBlue_20_w700 = TextStyle(color: UIColor.skyBlue, fontSize: 20.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle red_20_w700 = TextStyle(color: UIColor.red, fontSize: 20.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle mediumDarkBlue_20_w700 = TextStyle(color: UIColor.mediumDarkBlue, fontSize: 20.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle mediumDarkBlue_20_w400 = TextStyle(color: UIColor.mediumDarkBlue, fontSize: 20.0.textSize(), fontWeight: FontWeight.w400);
  static TextStyle danger_20_w700 = TextStyle(color: UIColor.danger, fontSize: 20.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle white_20_w700 = TextStyle(color: UIColor.white, fontSize: 20.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle white_28_w700 = TextStyle(color: UIColor.white, fontSize: 28.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle orange_20_w700 = TextStyle(color: UIColor.orange, fontSize: 20.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle mediumDarkCyan_20_w700 = TextStyle(color: UIColor.mediumDarkCyan, fontSize: 20.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle lightShadeGray_20_w700 = TextStyle(color: UIColor.lightShadeGray, fontSize: 20.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle lightBlueBorder_20_w700 = TextStyle(color: UIColor.lightBlueBorder, fontSize: 20.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle mediumDarkBlue_20_bold = TextStyle(color: UIColor.mediumDarkBlue, fontSize: 20.0.textSize(), fontWeight: FontWeight.bold);
  static TextStyle lightDarkBlueBorderline_20_bold =
      TextStyle(color: UIColor.lightDarkBlueBorderline, fontSize: 20.0.textSize(), fontWeight: FontWeight.bold);
  static TextStyle pink_20_w700 = TextStyle(color: UIColor.pink, fontSize: 20.0.textSize(), fontWeight: FontWeight.w700);

  static TextStyle mediumDarkBlue_28_w700 = TextStyle(color: UIColor.mediumDarkBlue, fontSize: 28.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle skyBlue_28_w700 = TextStyle(color: UIColor.skyBlue, fontSize: 28.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle mediumDarkCyan_28_bold = TextStyle(color: UIColor.mediumDarkCyan, fontSize: 28.0.textSize(), fontWeight: FontWeight.bold);

  static TextStyle bigDarkCyan_50_bold = TextStyle(color: UIColor.mediumDarkCyan, fontSize: 50.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle mediumDarkCyan_33_w700 = TextStyle(color: UIColor.mediumDarkCyan, fontSize: 33.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle lightDarkBluePlaceHolder_20_w400 =
      TextStyle(color: UIColor.lightDarkBluePlaceHolder, fontSize: 20.0.textSize(), fontWeight: FontWeight.w400);
  static TextStyle lightDarkBluePlaceHolder_20_w700 =
      TextStyle(color: UIColor.lightDarkBluePlaceHolder, fontSize: 20.0.textSize(), fontWeight: FontWeight.w700);
  static TextStyle cyanBlue_20_w700 = TextStyle(color: UIColor.cyanBlue, fontSize: 20.0.textSize(), fontWeight: FontWeight.w700);
}
