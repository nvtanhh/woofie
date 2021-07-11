import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/button_widget.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/profile/pet_profile/pet_profile.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class PreviewFollowPet extends StatelessWidget {
  final Pet pet;
  final Function(Pet)? onFollow;
  final EdgeInsets? margin;
  final RxBool isFollowing = RxBool(false);
  final bool isMyPet;

  PreviewFollowPet({
    Key? key,
    required this.pet,
    this.onFollow,
    this.margin,
    required this.isMyPet,
  }) : super(key: key) {
    isFollowing.value = pet.isFollowing ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => PetProfile(
            pet: pet,
            isMyPet: isMyPet,
          )),
      child: Container(
        width: 115.w,
        height: 180.h,
        margin: margin,
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: const [
            BoxShadow(color: UIColor.dimGray, blurRadius: 5, offset: Offset(2, 0), spreadRadius: 2),
          ],
          color: UIColor.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => ImageWithPlaceHolderWidget(
                imageUrl: pet.updateSubject.avatarUrl ?? "",
                width: 60.w,
                height: 60.w,
                radius: 10.r,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Obx(
              () => Text(
                pet.updateSubject.name ?? "",
                style: UITextStyle.text_header_18_w600,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Expanded(
              child: Obx(
                () => Text(
                  pet.updateSubject.bio ?? "",
                  style: UITextStyle.text_body_12_w600,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            if (onFollow != null)
              Obx(
                () => ButtonWidget(
                  onPress: () {
                    isFollowing.value = !isFollowing.value;
                    onFollow?.call(pet);
                  },
                  title: isFollowing.value ? LocaleKeys.profile_un_follow.trans() : LocaleKeys.profile_follow.trans(),
                  titleStyle: UITextStyle.white_10_w600,
                  width: 60.w,
                  height: 22.h,
                  backgroundColor: isFollowing.value ? UIColor.textSecondary : UIColor.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
