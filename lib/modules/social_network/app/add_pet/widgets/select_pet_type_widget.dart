import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_type.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class SelectPetTypeWidget extends StatelessWidget {
  final List<PetType> petTypes;
  final int selectedIndex;
  final Function(int) onSelectedIndex;

  const SelectPetTypeWidget({
    Key? key,
    required this.petTypes,
    this.selectedIndex = -1,
    required this.onSelectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 620.h,
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      child: petTypes.isNotEmpty
          ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 10.h,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => onSelectedIndex(index),
                  child: SizedBox(
                    height: 102.h,
                    child: Column(
                      children: [
                        Container(
                          width: 80.w,
                          height: 80.0.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: UIColor.antiqueWhite,
                              border: Border.all(color: index == selectedIndex ? UIColor.accent2 : UIColor.antiqueWhite)),
                          child: index == petTypes.length - 1
                              ? Assets.resources.icons.icAnotherPet.image()
                              : Image.network(
                                  petTypes[index].avatar ??
                                      "https://image.shutterstock.com/image-vector/pet-friendly-logo-design-vector-600w-1297665529.jpg",
                                  fit: BoxFit.fill,
                                ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          petTypes[index].name ?? "",
                          style: index == selectedIndex ? UITextStyle.accent2_14_w600 : UITextStyle.text_body_14_w600,
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: petTypes.length,
            )
          : Text(
              "Empty",
              style: UITextStyle.text_header_18_w700,
            ),
    );
  }
}
