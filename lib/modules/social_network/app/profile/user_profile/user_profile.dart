import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/extensions/string_ext.dart ';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/core/ui/button_widget.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/profile/user_profile/user_profile_model.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class UserProfile extends StatefulWidget {
  final User? user;

  const UserProfile({Key? key, this.user}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends BaseViewState<UserProfile, UserProfileModel> {
  @override
  void loadArguments() {
    viewModel.user = widget.user;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonWidget(
                    onPress: () => null,
                    backgroundColor: UIColor.white,
                    width: 40.w,
                    height: 40.h,
                    borderRadius: 10.r,
                    contentWidget: IconButton(
                      icon: const MWIcon(MWIcons.moreHoriz),
                      onPressed: () => null,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              MWAvatar(
                avatarUrl: viewModel.user?.avatarUrl,
                customSize: 80.w,
                borderRadius: 15.r,
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                viewModel.user?.name ?? "Unknown",
                style: UITextStyle.text_header_24_w600,
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                viewModel.user?.bio ?? "Unknown",
                style: UITextStyle.text_body_14_w500,
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: ButtonWidget(
                      onPress: () => null,
                      height: 40.h,
                      title: LocaleKeys.profile_edit_profile.trans(),
                      borderRadius: 10.r,
                    ),
                  ),
                  if (widget.user != null)
                    Container(
                      margin: EdgeInsets.only(left: 20.w),
                      child: ButtonWidget(
                        onPress: () => null,
                        backgroundColor: UIColor.holder,
                        width: 40.w,
                        height: 40.h,
                        borderRadius: 10.r,
                        contentWidget: IconButton(
                          icon: const MWIcon(MWIcons.moreHoriz),
                          onPressed: () => null,
                        ),
                      ),
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  UserProfileModel createViewModel() => injector<UserProfileModel>();
}
