import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/core/ui/button.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/profile/edit_user_profile/edit_user_profile_model.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class EditUserProfileWidget extends StatefulWidget {
  final User user;

  const EditUserProfileWidget({Key? key, required this.user}) : super(key: key);

  @override
  _EditUserProfileWidgetState createState() => _EditUserProfileWidgetState();
}

class _EditUserProfileWidgetState
    extends BaseViewState<EditUserProfileWidget, EditUserProfileWidgetModel> {
  @override
  void loadArguments() {
    viewModel.user = widget.user;
    super.loadArguments();
  }

  UnderlineInputBorder underlineInputBorder = UnderlineInputBorder(
    borderRadius: BorderRadius.circular(20.r),
    borderSide: const BorderSide(color: UIColor.primary),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            LocaleKeys.profile_user_information.trans(),
            style: UITextStyle.text_header_18_w600,
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
              child: MWButton(
                onPressed: () => viewModel.onSaveClick(),
                minWidth: 40.w,
                borderRadius: BorderRadius.circular(10.r),
                child: Text(
                  LocaleKeys.profile_save.trans(),
                  style: UITextStyle.white_12_w600,
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              InkWell(
                onTap: () => viewModel.onUpdateAvatarClick(),
                child: SizedBox(
                  height: 110.h,
                  width: 110.h,
                  child: Stack(
                    children: [
                      Obx(() {
                        if (viewModel.avatarFile == null) {
                          return MWAvatar(
                            avatarUrl: viewModel.user.avatarUrl ?? "",
                            customSize: 92.h,
                            borderRadius: 15.r,
                          );
                        } else {
                          return MWAvatar(
                            avatarFile: viewModel.avatarFile,
                            customSize: 92.h,
                            borderRadius: 15.r,
                          );
                        }
                      }),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 30.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                              color: UIColor.accent,
                              borderRadius: BorderRadius.circular(5.r)),
                          // padding: EdgeInsets.all(5.w),
                          child: const MWIcon(
                            MWIcons.camera,
                            color: UIColor.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              TextField(
                controller: viewModel.nameEditingController,
                style: UITextStyle.text_header_24_w600,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: MWIcon(
                    MWIcons.edit,
                    color: UIColor.primary,
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              TextField(
                controller: viewModel.introduceEditingController,
                style: UITextStyle.text_body_18_w500,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 15.w),
                  enabledBorder: underlineInputBorder,
                  focusedBorder: underlineInputBorder,
                  labelText: LocaleKeys.profile_introduce.trans(),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              TextField(
                style: UITextStyle.text_body_18_w500,
                controller: viewModel.emailEditingController,
                enabled: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 15.w),
                  labelText: LocaleKeys.profile_email.trans(),
                  border: underlineInputBorder,
                  hintText: viewModel.user.email,
                  disabledBorder: underlineInputBorder,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              TextField(
                controller: viewModel.addressEditingController,
                style: UITextStyle.text_body_18_w500,
                maxLines: 3,
                focusNode: viewModel.focusNode,
                showCursor: true,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: LocaleKeys.profile_address.trans(),
                  enabledBorder: underlineInputBorder,
                  focusedBorder: underlineInputBorder,
                  contentPadding: EdgeInsets.only(left: 15.w),
                  suffixIcon: MWButton(
                    onPressed: () => viewModel.getCurrentAddress(),
                    minWidth: 50.w,
                    padding: EdgeInsets.all(10.w),
                    color: UIColor.gray25,
                    child: const MWIcon(
                      MWIcons.location,
                      color: UIColor.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  EditUserProfileWidgetModel createViewModel() =>
      injector<EditUserProfileWidgetModel>();
}
