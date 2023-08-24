import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/services/dialog_service.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/core/ui/button_widget.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/profile/edit_user_profile/edit_user_profile.dart';
import 'package:meowoof/modules/social_network/app/profile/user_profile/widgets/pets_widget.dart';
import 'package:meowoof/modules/social_network/app/profile/user_profile/widgets/user_menu_action_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class InfoUserWidget extends StatelessWidget {
  final User user;
  final Function(Pet)? onFollowPet;
  final bool isMe;

  final Function(User)? onUserBlock;
  final Function(User)? onUserReport;
  final Function(User) onWantsToContact;

  const InfoUserWidget({
    super.key,
    required this.user,
    required this.onFollowPet,
    required this.isMe,
    required this.onWantsToContact,
    this.onUserReport,
    this.onUserBlock,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Obx(
                () => MWAvatar(
                  avatarUrl: user.updateSubjectValue.avatarUrl,
                  customSize: 80.w,
                  borderRadius: 15.r,
                  onPressed: () =>
                      injector<DialogService>().showZoomablePhotoBoxView(
                    imageUrl: user.updateSubjectValue.avatarUrl ?? "",
                    context: context,
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Obx(
                () => Text(
                  user.updateSubjectValue.name ?? "",
                  style: UITextStyle.text_header_24_w600,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Obx(
                () => Text(
                  user.updateSubjectValue.bio ?? "",
                  style: UITextStyle.text_body_14_w500,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: ButtonWidget(
                      onPress: () =>
                          isMe ? goToEditUserProfile() : onWantsToContact(user),
                      height: 40.h,
                      title: isMe
                          ? LocaleKeys.profile_edit_profile.trans()
                          : LocaleKeys.profile_contact.trans(),
                      borderRadius: 10.r,
                    ),
                  ),
                  if (!isMe)
                    UserMenuActionWidget(
                      user: user,
                      onUserReport: onUserReport!,
                      onUserBlock: onUserBlock!,
                    )
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
        PetsWidget(
          user: user,
          onFollow: isMe ? null : onFollowPet,
          isMyPets: isMe,
        ),
        SizedBox(
          height: 15.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.profile_post.trans(),
                style: UITextStyle.text_header_18_w600,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void goToEditUserProfile() {
    Get.to(
      () => EditUserProfileWidget(
        user: user,
      ),
    );
  }
}
