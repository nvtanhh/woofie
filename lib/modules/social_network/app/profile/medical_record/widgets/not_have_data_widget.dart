import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/button.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class NotHaveData extends StatelessWidget {
  final bool isMyPet;
  final Function onAddClick;

  const NotHaveData({
    Key? key,
    required this.isMyPet,
    required this.onAddClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          LocaleKeys.profile_not_have_data.trans(),
          style: UITextStyle.text_secondary_12_w500,
        ),
        SizedBox(
          height: 10.h,
        ),
        if (isMyPet)
          MWButton(
            onPressed: () => onAddClick(),
            minWidth: 50.w,
            child: Text(
              LocaleKeys.profile_add.trans(),
              style: UITextStyle.white_12_w600,
            ),
          )
      ],
    );
  }
}
