import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/modules/social_network/app/save_post/widgets/pet_card_item.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class TagPetBottomSheetWidget extends StatelessWidget {
  final List<Pet>? taggedPets;
  final ValueChanged<Pet> onPetChosen;
  final List<Pet> userPets;

  final String? title;

  const TagPetBottomSheetWidget(
      {Key? key,
      required this.onPetChosen,
      required this.userPets,
      this.taggedPets = const [],
      this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 20.h,
        left: 20.w,
        bottom: 50.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
        color: UIColor.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title ?? 'Gắn thẻ thú cưng:',
              style: UITextStyle.heading_18_semiBold),
          SizedBox(height: 10.h),
          SizedBox(
            height: 180.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: userPets.length,
              itemBuilder: (context, index) {
                final bool isSelected =
                    (taggedPets ?? []).contains(userPets[index]);
                return PetCardItem(
                  pet: userPets[index],
                  isSelected: isSelected,
                  onClicked: () => onPetChosen(userPets[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
