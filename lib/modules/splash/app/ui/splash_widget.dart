import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/splash/app/ui/splash_widget_model.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class SplashWidget extends StatefulWidget {
  @override
  _SplashWidgetState createState() => _SplashWidgetState();
}

class _SplashWidgetState extends BaseViewState<SplashWidget, SplashWidgetModel> {
  @override
  void loadArguments() {
    viewModel.checkLogged();
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: UIColor.white,
        body: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: UIColor.primary,
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
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
              ],
            ),
            Positioned(
              bottom: 0,
              child: Assets.resources.icons.icLogoBottom.image(
                height: 180.h,
                width: Get.width,
                fit: BoxFit.fill,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  SplashWidgetModel createViewModel() => injector<SplashWidgetModel>();
}
