import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/button_widget.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/auth/app/ui/login/login_widget_model.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends BaseViewState<LoginWidget, LoginWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 94.h,
                    ),
                    Container(
                      width: 65.w,
                      height: 65.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: UIColor.primary,
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Text(
                      LocaleKeys.app_name.trans(),
                      style: UITextStyle.text_header_18_w700,
                    ),
                    Text(
                      LocaleKeys.welcome_social_network_for_pet.trans(),
                      style: UITextStyle.text_body_12_w600,
                    ),
                    SizedBox(
                      height: 87.h,
                    ),
                    Row(
                      children: [
                        Text(
                          LocaleKeys.welcome_Login.trans(),
                          style: UITextStyle.text_header_18_w600,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Form(
                      key: viewModel.formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: viewModel.emailEditingController,
                            validator: (email) =>
                                viewModel.emailValidate(email),
                            decoration: InputDecoration(
                                hintText: LocaleKeys.login_email.trans(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: const BorderSide(
                                    color: UIColor.silverSand,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: const BorderSide(
                                    color: UIColor.silverSand,
                                  ),
                                ),
                                prefixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 18.0.w,
                                    ),
                                    const Icon(
                                      Icons.email_outlined,
                                      color: UIColor.textHeader,
                                    ),
                                    SizedBox(
                                      width: 12.0.w,
                                    ),
                                    Container(
                                      height: 30.h,
                                      width: 1.0.w,
                                      color: UIColor.textSecondary,
                                    ),
                                    SizedBox(
                                      width: 12.0.w,
                                    ),
                                  ],
                                )),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Obx(
                            () => TextFormField(
                              controller: viewModel.passwordEditingController,
                              validator: (password) =>
                                  viewModel.passwordValidate(password),
                              decoration: InputDecoration(
                                hintText: LocaleKeys.login_password.trans(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: const BorderSide(
                                    color: UIColor.silverSand,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: const BorderSide(
                                    color: UIColor.silverSand,
                                  ),
                                ),
                                prefixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 18.0.w,
                                    ),
                                    const Icon(
                                      Icons.lock_open_outlined,
                                      color: UIColor.textHeader,
                                    ),
                                    SizedBox(
                                      width: 12.0.w,
                                    ),
                                    Container(
                                      height: 30.h,
                                      width: 1.0.w,
                                      color: UIColor.textSecondary,
                                    ),
                                    SizedBox(
                                      width: 12.0.w,
                                    ),
                                  ],
                                ),
                                suffixIcon: InkWell(
                                  onTap: viewModel.onEyeClick,
                                  child: Obx(
                                    () => Icon(
                                      !viewModel.showPassword
                                          ? Icons.visibility_off_rounded
                                          : Icons.visibility_rounded,
                                    ),
                                  ),
                                ),
                              ),
                              obscureText: !viewModel.showPassword,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: viewModel.onForgotPasswordClick,
                          child: Text(
                            LocaleKeys.login_forgot_password.trans(),
                            style: UITextStyle.text_body_14_w600,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 17.h,
                    ),
                    ButtonWidget(
                      height: 50.h,
                      width: 315.w,
                      borderRadius: 10.r,
                      title: LocaleKeys.welcome_LOGIN.trans(),
                      titleStyle: UITextStyle.white_18_w700,
                      onPress: () => viewModel.onLoginClick(),
                    ),
                    SizedBox(
                      height: 26.h,
                    ),
                    InkWell(
                      onTap: viewModel.onRegisterClick,
                      child: Text.rich(
                        TextSpan(
                          text: LocaleKeys.login_no_account.trans(),
                          children: <InlineSpan>[
                            TextSpan(
                              text: LocaleKeys.login_register_now.trans(),
                              style: UITextStyle.primary_14_w600,
                            ),
                          ],
                          style: UITextStyle.text_body_14_w600,
                        ),
                      ),
                    )
                  ],
                ),
                Assets.resources.icons.icLogoBottom.image(
                  height: 180.h,
                  width: Get.width,
                  fit: BoxFit.fill,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  LoginWidgetModel createViewModel() => injector<LoginWidgetModel>();
}
