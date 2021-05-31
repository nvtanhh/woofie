import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/core/ui/button_widget.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/profile/pet_profile/widgets/pet_menu_action_widget.dart';
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
        MWAvatar(
          avatarUrl: pet.avatar,
          customSize: 80.w,
          borderRadius: 15.r,
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          pet.name ?? "Unknown",
          style: UITextStyle.text_header_24_w600,
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          pet.bio ?? "Unknown",
          style: UITextStyle.text_body_14_w500,
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
                      // Get.to(page)
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
                  backgroundColor: isFollowing.value ? UIColor.text_secondary : UIColor.primary,
                ),
              ),
            ),
            if (!isMyPet)
              PetMenuActionWidget(
                pet: pet,
                onPetBlock: onPetReport!,
                onPetReport: onPetBlock!,
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
