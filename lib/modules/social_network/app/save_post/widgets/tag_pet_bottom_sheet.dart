import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/ui/button_widget.dart';
import 'package:meowoof/modules/social_network/app/save_post/widgets/pet_card_item.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class TagPetBottomSheetWidget extends StatefulWidget {
  final List<Pet>? taggedPets;
  final ValueChanged<Pet> onPetChosen;
  final List<Pet> userPets;
  final String? title;
  final bool needConfirmButton;

  const TagPetBottomSheetWidget({
    Key? key,
    required this.onPetChosen,
    required this.userPets,
    this.taggedPets = const [],
    this.title,
    this.needConfirmButton = false,
  }) : super(key: key);

  @override
  _TagPetBottomSheetWidgetState createState() =>
      _TagPetBottomSheetWidgetState();
}

class _TagPetBottomSheetWidgetState extends State<TagPetBottomSheetWidget> {
  Pet? _selectedPet;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 20.h,
        bottom: widget.needConfirmButton ? 0 : 50.h,
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(widget.title ?? 'Gắn thẻ thú cưng:',
                style: UITextStyle.heading_18_semiBold),
          ),
          SizedBox(height: 15.h),
          SizedBox(
            height: 180.h,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 20.w),
              scrollDirection: Axis.horizontal,
              itemCount: widget.userPets.length,
              itemBuilder: (context, index) {
                final bool isSelected =
                    (widget.taggedPets ?? []).contains(widget.userPets[index]);
                return Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: PetCardItem(
                    pet: widget.userPets[index],
                    isSelected: !widget.needConfirmButton
                        ? isSelected
                        : widget.userPets[index] == _selectedPet,
                    onClicked: () => !widget.needConfirmButton
                        ? widget.onPetChosen(widget.userPets[index])
                        : _setSelectedPet(widget.userPets[index]),
                  ),
                );
              },
            ),
          ),
          if (widget.needConfirmButton)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 15.h),
              child: ButtonWidget(
                height: 47.h,
                borderRadius: 15.r,
                onPress: () {
                  if (_selectedPet != null) {
                    widget.onPetChosen(_selectedPet!);
                  }
                },
                contentWidget: Text(
                  'Chọn',
                  style: UITextStyle.white_14_w600,
                ),
              ),
            )
        ],
      ),
    );
  }

  void _setSelectedPet(Pet pet) => setState(() {
        _selectedPet = pet;
      });
}
