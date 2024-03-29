import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/services/dialog_service.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/core/ui/avatar/pet_avatar.dart';
import 'package:meowoof/core/ui/button_widget.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/profile/edit_pet_profile/edit_pet_profile.dart';
import 'package:meowoof/modules/social_network/app/profile/pet_profile/widgets/other_info_menu_widget.dart';
import 'package:meowoof/modules/social_network/app/profile/user_profile/user_profile.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class PetInfoWidget extends StatelessWidget {
  final Pet pet;
  final bool isMyPet;
  final Function(Pet)? onPetReport;
  final Function(Pet)? onPetBlock;
  final Function(Pet)? followPet;
  final Function(Pet)? onDeletePost;

  const PetInfoWidget({
    super.key,
    required this.pet,
    required this.isMyPet,
    this.onPetReport,
    this.onPetBlock,
    this.followPet,
    this.onDeletePost,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 5.h,
        ),
        Obx(
          () => GestureDetector(
            onTap: () => injector<DialogService>().showZoomablePhotoBoxView(
              imageUrl: pet.updateSubjectValue.avatarUrl ?? "",
              context: context,
            ),
            child: Stack(
              children: [
                PetAvatar(
                  avatarUrl: pet.updateSubjectValue.avatarUrl,
                  customSize: 80.w,
                  borderRadius: 15.r,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Transform.translate(
                    offset: Offset(10.w, 10.h),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(
                          () => UserProfile(
                            user: pet.updateSubjectValue.currentOwner,
                          ),
                        );
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(2.w),
                        child: MWAvatar(
                          avatarUrl:
                              pet.updateSubjectValue.currentOwner?.avatarUrl ??
                                  '',
                          size: MWAvatarSize.small,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        Obx(
          () => Text(
            pet.updateSubjectValue.name ?? "",
            style: UITextStyle.text_header_24_w600,
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Obx(
          () => Text(
            pet.updateSubjectValue.bio ?? "",
            style: UITextStyle.text_body_14_w500,
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          children: [
            Expanded(
              child: Obx(
                () => ButtonWidget(
                  onPress: () {
                    if (isMyPet) {
                      Get.to(() => EditPetProfileWidget(pet: pet));
                    } else {
                      followPet?.call(pet);
                    }
                  },
                  height: 40.h,
                  title: isMyPet
                      ? LocaleKeys.profile_edit_profile.trans()
                      : (pet.updateSubjectValue.isFollowing ?? false
                          ? LocaleKeys.profile_un_follow.trans()
                          : LocaleKeys.profile_follow.trans()),
                  borderRadius: 10.r,
                  backgroundColor: pet.updateSubjectValue.isFollowing ?? false
                      ? UIColor.textSecondary
                      : UIColor.primary,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(
                () => OtherInfoMenuWidget(
                  onDeletePost: () => onDeletePost?.call(pet),
                  isMyPet: isMyPet,
                  pet: pet,
                ),
              ),
              child: Container(
                width: 40.w,
                height: 40.h,
                margin: EdgeInsets.only(left: 20.w),
                padding: EdgeInsets.only(top: 5.h),
                decoration: BoxDecoration(
                    color: UIColor.holder,
                    borderRadius: BorderRadius.circular(10.r),),
                child: const Center(
                  child: MWIcon(
                    MWIcons.moreHoriz,
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }
}
