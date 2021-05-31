import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:meowoof/modules/social_network/app/save_post/widgets/pet_card_item_.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TagPetBottomSheetWidget extends StatelessWidget {
  final RxList<Pet> taggedPets;
  final ValueChanged<Pet> onPetChosen;
  final List<Pet> userPets;

  const TagPetBottomSheetWidget({
    Key? key,
    required this.taggedPets,
    required this.onPetChosen,
    required this.userPets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.h, left: 20.w, bottom: 50.h),
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
          Text('Gắn thẻ thú cưng:', style: UITextStyle.heading_18_semiBold),
          const SizedBox(height: 20),
          SizedBox(
            height: 0.2.sh,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: userPets.length,
              itemBuilder: (context, index) => Obx(() {
                final bool isSelected = taggedPets.toList().contains(userPets[index]);
                return PetCardItem(
                  pet: userPets[index],
                  isSelected: isSelected,
                  onClicked: () => onPetChosen(userPets[index]),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
