import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/button_widget.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/auth/app/ui/welcome/welcome_widget_model.dart';
import 'package:meowoof/modules/auth/app/ui/welcome/widget/button_login_with.dart';
import 'package:meowoof/modules/auth/app/ui/welcome/widget/divide_widget.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class WelcomeWidget extends StatefulWidget {
  @override
  _WelcomeWidgetState createState() => _WelcomeWidgetState();
}

class _WelcomeWidgetState extends BaseViewState<WelcomeWidget, WelcomeWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 148.h,
          ),
          Assets.resources.icons.icLogoBackground.image(width: 375.w, height: 245.h),
          Text(
            LocaleKeys.app_name.trans(),
            style: UITextStyle.text_header_24_w700,
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            LocaleKeys.welcome_social_network_for_pet.trans(),
            style: UITextStyle.text_body_14_w600,
          ),
          ButtonWidget(
            height: 50.h,
            width: 315.w,
            title: LocaleKeys.welcome_login.trans(),
            titleStyle: UITextStyle.white_18_w700,
            onPress: () => viewModel.onLoginClick(),
          ),
          DivideWidget(),
          SizedBox(
            height: 24.h,
          ),
          Row(
            children: [
              ButtonLoginWithWidget(
                width: 150.w,
                height: 74.h,
                backgroundColor: UIColor.blue_yonder,
                callBack: viewModel.onLoginWithFbClick,
                target: "Facebook",
              ),
              SizedBox(
                width: 15.w,
              ),
              ButtonLoginWithWidget(
                width: 150.w,
                height: 74.h,
                backgroundColor: UIColor.cinnabar,
                callBack: viewModel.onLoginWithFbClick,
                target: "Google",
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  WelcomeWidgetModel createViewModel() => WelcomeWidgetModel();
}
