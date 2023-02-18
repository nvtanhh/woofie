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
    super.key,
    required this.onPetChosen,
    required this.userPets,
    this.taggedPets = const [],
    this.title,
    this.needConfirmButton = false,
  });

  @override
  _TagPetBottomSheetWidgetState createState() =>
      _TagPetBottomSheetWidgetState();
}

class _TagPetBottomSheetWidgetState extends State<TagPetBottomSheetWidget> {
  Pet? _selectedPet;
  List<Pet>? _selectedPets;

  @override
  void initState() {
    super.initState();
    _selectedPets = widget.taggedPets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 30.h,
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
                style: UITextStyle.heading_18_semiBold,),
          ),
          SizedBox(
            height: 210.h,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 20.w, top: 10.h, bottom: 10.h),
              scrollDirection: Axis.horizontal,
              itemCount: widget.userPets.length,
              itemBuilder: (context, index) {
                final bool isSelected =
                    (_selectedPets ?? []).contains(widget.userPets[index]);
                return Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: PetCardItem(
                      pet: widget.userPets[index],
                      isSelected: !widget.needConfirmButton
                          ? isSelected
                          : widget.userPets[index] == _selectedPet,
                      onClicked: () {
                        if (!widget.needConfirmButton) {
                          widget.onPetChosen(widget.userPets[index]);
                          setState(() {
                            if (isSelected) {
                              _selectedPets!.remove(widget.userPets[index]);
                            } else {
                              _selectedPets!.add(widget.userPets[index]);
                            }
                          });
                        }
                        _setSelectedPet(widget.userPets[index]);
                      },),
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
