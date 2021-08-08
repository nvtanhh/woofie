import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/helpers/datetime_helper.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/core/ui/avatar/pet_avatar.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/core/extensions/string_ext.dart';

class PetCardItem extends StatelessWidget {
  final Pet pet;
  final bool isSelected;
  final Function()? onClicked;

  const PetCardItem(
      {Key? key, required this.pet, this.onClicked, this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String age = DateTimeHelper.calcAge(pet.dob);
    return GestureDetector(
      onTap: onClicked,
      child: Container(
        constraints: BoxConstraints(minWidth: 140.w),
        padding: EdgeInsets.all(15.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: UIColor.boxShadowColor,
              blurRadius: 15,
            ),
          ],
          border: Border.all(
              color: isSelected ? UIColor.accent2 : Colors.transparent),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 70.h,
              child: PetAvatar(
                avatarUrl: pet.avatarUrl,
                size: MWAvatarSize.large,
                borderRadius: 10,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              pet.name!,
              style: UITextStyle.heading_18_semiBold,
              maxLines: 1,
            ),
            SizedBox(height: 3.h),
            Text(
              pet.bio ?? '',
              style: UITextStyle.body_12_medium,
              maxLines: 2,
            ),
            Expanded(
              child: SizedBox(height: 10.h),
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: pet.gender?.index == 0
                        ? UIColor.pattensBlue2
                        : UIColor.genderFemaleBackground,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  padding: EdgeInsets.all(5.w),
                  child: Text(
                    pet.gender?.index == 0
                        ? LocaleKeys.add_pet_pet_male.trans()
                        : LocaleKeys.add_pet_pet_female.trans(),
                    style: pet.gender?.index == 0
                        ? UITextStyle.dodger_blue_10_w500
                        : UITextStyle.dodger_pink_10_w500,
                  ),
                ),
                if (age != 'Unknown')
                  Container(
                    decoration: BoxDecoration(
                      color: UIColor.whisper,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    margin: EdgeInsets.only(left: 5.w),
                    padding: EdgeInsets.all(5.w),
                    child: Text(
                      age,
                      style: UITextStyle.text_body_10_w500,
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
