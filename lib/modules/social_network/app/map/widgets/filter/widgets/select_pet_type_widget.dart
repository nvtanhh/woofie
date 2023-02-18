import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_type.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class MapSeacherFilterSelectPetTypeWidget extends StatelessWidget {
  final List<PetType> petTypes;
  final Function(PetType) onPetTypeSelected;
  final PetType? selectedPetType;

  const MapSeacherFilterSelectPetTypeWidget({
    super.key,
    required this.petTypes,
    required this.onPetTypeSelected,
    this.selectedPetType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: petTypes.map(_petTypeItem).toList(),
    );
  }

  Widget _getPlaceholder() {
    return Assets.resources.images.fallbacks.petTypeFallback.image();
  }

  Widget _petTypeItem(PetType petType) {
    return GestureDetector(
      onTap: () => onPetTypeSelected(petType),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: SizedBox(
          child: Column(
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    width: 1.5.w,
                    color: petType == selectedPetType
                        ? UIColor.primary
                        : Colors.transparent,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(2.5.w),
                  child: ExtendedImage.network(petType.avatar ?? "",
                      retries: 1, fit: BoxFit.fill, loadStateChanged: (e) {
                    switch (e.extendedImageLoadState) {
                      case LoadState.loading:
                        return _getPlaceholder();
                      case LoadState.completed:
                        return null;
                      case LoadState.failed:
                        return _getPlaceholder();
                    }
                  },),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                petType.name ?? "",
                style: petType == selectedPetType
                    ? UITextStyle.primary_14_w600
                    : UITextStyle.text_body_14_w600,
              )
            ],
          ),
        ),
      ),
    );
  }
}
