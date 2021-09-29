import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_type.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class MapSeacherFilterSelectPetTypeWidget extends StatelessWidget {
  final List<PetType> petTypes;
  final int selectedIndex;
  final Function(int) onSelectedIndex;

  const MapSeacherFilterSelectPetTypeWidget({
    Key? key,
    required this.petTypes,
    this.selectedIndex = -1,
    required this.onSelectedIndex,
  }) : super(key: key);

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
    final index = petTypes.indexOf(petType);
    return GestureDetector(
      onTap: () => onSelectedIndex(index),
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
                  color: UIColor.antiqueWhite,
                  border: Border.all(
                    color: index == selectedIndex
                        ? UIColor.accent2
                        : UIColor.antiqueWhite,
                  ),
                ),
                child: ExtendedImage.network(petTypes[index].avatar ?? "",
                    retries: 1, fit: BoxFit.fill, loadStateChanged: (e) {
                  switch (e.extendedImageLoadState) {
                    case LoadState.loading:
                      return _getPlaceholder();
                    case LoadState.completed:
                      return null;
                    case LoadState.failed:
                      return _getPlaceholder();
                  }
                }),
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                petTypes[index].name ?? "",
                style: index == selectedIndex
                    ? UITextStyle.accent2_14_w600
                    : UITextStyle.text_body_14_w600,
              )
            ],
          ),
        ),
      ),
    );
  }
}
