import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_breed.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class SelectPetBreedWidget extends StatelessWidget {
  final List<PetBreed> petBreeds;
  final int selectedIndex;
  final Function(int) onSelectedIndex;

  const SelectPetBreedWidget({
    super.key,
    required this.petBreeds,
    required this.selectedIndex,
    required this.onSelectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30.h,
            ),
            Text(
              LocaleKeys.add_pet_select_pet_breed.trans(),
              style: UITextStyle.text_body_18_w500,
            ),
            SizedBox(
              height: 20.h,
            ),
            SizedBox(
              height: 520.h,
              child: ListView.builder(
                itemCount: petBreeds.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => onSelectedIndex(index),
                    child: Container(
                      key: ObjectKey(petBreeds[index]),
                      margin: EdgeInsets.symmetric(vertical: 15.h),
                      child: Row(
                        children: [
                          Container(
                            width: 70.w,
                            height: 90.0.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: index == selectedIndex
                                    ? UIColor.accent2
                                    : UIColor.white,
                              ),
                            ),
                            child: ImageWithPlaceHolderWidget(
                              imageUrl: petBreeds[index].avatar ?? "",
                              radius: 10.r,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 17.w,
                          ),
                          Expanded(
                            child: Text(
                              petBreeds[index].name ?? "",
                              maxLines: 1,
                              style: index == selectedIndex
                                  ? UITextStyle.accent2_18_w500
                                  : UITextStyle.text_body_18_w500,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
