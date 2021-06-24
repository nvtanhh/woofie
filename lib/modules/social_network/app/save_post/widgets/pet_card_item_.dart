import 'package:flutter/material.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PetCardItem extends StatelessWidget {
  final Pet pet;
  final Function()? onClicked;
  final bool isSelected;

  const PetCardItem({Key? key, required this.pet, this.onClicked, this.isSelected = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClicked,
      child: Container(
        constraints: BoxConstraints(minWidth: 130.w),
        padding: const EdgeInsets.all(20),
        margin: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: UIColor.boxShadowColor,
              blurRadius: 15,
            ),
          ],
          border: Border.all(color: isSelected ? UIColor.accent2 : Colors.transparent),
        ),
        child: Column(
          children: [
            MWAvatar(
              avatarUrl: pet.avatar?.url,
              size: MWAvatarSize.large,
              borderRadius: 10,
            ),
            const SizedBox(height: 10),
            Text(pet.name!, style: UITextStyle.heading_18_semiBold),
            // const SizedBox(height: 5),
            Text(pet.petBreed?.name ?? 'Yellow cat', style: UITextStyle.body_12_medium),
          ],
        ),
      ),
    );
  }
}
