import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/core/ui/button_widget.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/profile/edit_pet_profile/edit_pet_profile.dart';
import 'package:meowoof/modules/social_network/app/profile/pet_profile/widgets/other_info_menu_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class PetInfoWidget extends StatelessWidget {
  final Pet pet;
  final bool isMyPet;
  final Function(Pet)? onPetReport;
  final Function(Pet)? onPetBlock;
  final Function(Pet)? followPet;
  final RxBool isFollowing = RxBool(false);

  PetInfoWidget({
    Key? key,
    required this.pet,
    required this.isMyPet,
    this.onPetReport,
    this.onPetBlock,
    this.followPet,
  }) : super(key: key) {
    isFollowing.value = pet.isFollowing ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 5.h,
        ),
        Obx(
          () => MWAvatar(
            avatarUrl: pet.updateSubject.avatarUrl,
            customSize: 80.w,
            borderRadius: 15.r,
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Obx(
          () => Text(
            pet.updateSubject.name ?? "Unknown",
            style: UITextStyle.text_header_24_w600,
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Obx(
          () => Text(
            pet.updateSubject.bio ?? "Unknown",
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
                      isFollowing.value = !isFollowing.value;
                      followPet?.call(pet);
                    }
                  },
                  height: 40.h,
                  title: isMyPet
                      ? LocaleKeys.profile_edit_profile.trans()
                      : (isFollowing.value ? LocaleKeys.profile_un_follow.trans() : LocaleKeys.profile_follow.trans()),
                  borderRadius: 10.r,
                  backgroundColor: isFollowing.value ? UIColor.textSecondary : UIColor.primary,
                ),
              ),
            ),
            InkWell(
              onTap: () => Get.to(
                () => OtherInfoMenuWidget(),
              ),
              child: Container(
                width: 40.w,
                height: 40.h,
                margin: EdgeInsets.only(left: 20.w),
                padding: EdgeInsets.only(top: 5.h),
                decoration: BoxDecoration(color: UIColor.holder, borderRadius: BorderRadius.circular(10.r)),
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
