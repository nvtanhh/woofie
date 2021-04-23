import 'package:flutter/material.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/core/ui/button_widget.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/auth/app/ui/start/start_widget_model.dart';
import 'package:meowoof/modules/auth/app/ui/start/widget/divide_widget.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/extensions/string_ext.dart';

class StartWidget extends StatefulWidget {
  @override
  _StartWidgetState createState() => _StartWidgetState();
}

class _StartWidgetState extends BaseViewState<StartWidget, StartWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 148.0.h,
          ),
          Assets.resources.icons.icLogoBackground.image(width: 375.w, height: 245.h),
          Text(
            LocaleKeys.app_name.trans(),
            style: UITextStyle.text_header_24_w700,
          ),
          SizedBox(
            height: 5.0.h,
          ),
          Text(
            LocaleKeys.start_social_network_for_pet.trans(),
            style: UITextStyle.text_body_14_w600,
          ),
          ButtonWidget(
            height: 50.0.h,
            width: 315.0.w,
            title: LocaleKeys.login.trans(),
            titleStyle: UITextStyle.white_18_w700,
          ),
          DivideWidget(),
          SizedBox(
            height: 24.0.h,
          ),
          Row(
            children: [],
          )
        ],
      ),
    );
  }

  @override
  StartWidgetModel createViewModel() => StartWidgetModel();
}
