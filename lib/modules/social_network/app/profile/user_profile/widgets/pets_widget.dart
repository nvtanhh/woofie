import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/add_pet/add_pet_widget.dart';
import 'package:meowoof/modules/social_network/app/commons/preview_follow_pet.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class PetsWidget extends StatelessWidget {
  final List<Pet> pets;
  final Function(Pet)? onFollow;
  final bool isMyPets;

  const PetsWidget({Key? key, required this.pets, this.onFollow, required this.isMyPets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.profile_pet.trans(),
          style: UITextStyle.text_header_18_w600,
        ),
        SizedBox(
          height: 5.h,
        ),
        SizedBox(
          height: 180.h,
          child: pets.isEmpty
              ? Center(child: Text(LocaleKeys.add_pet_do_not_have_pet.trans()))
              : ListView.builder(
                  itemBuilder: (context, index) {
                    if (isMyPets && index == pets.length) {
                      return Container(
                        width: 115.w,
                        height: 180.h,
                        margin: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: const [
                            BoxShadow(
                              color: UIColor.dim_gray,
                              blurRadius: 5,
                              offset: Offset(2, 0),
                              spreadRadius: 2,
                            ),
                          ],
                          color: UIColor.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () => Get.to(() => AddPetWidget()),
                              icon: const Icon(
                                Icons.add_box_outlined,
                                color: UIColor.text_body,
                              ),
                            ),
                            Text(
                              LocaleKeys.profile_add_pet.trans(),
                              style: UITextStyle.text_body_12_w600,
                            ),
                          ],
                        ),
                      );
                    }
                    return PreviewFollowPet(
                      pet: pets[index],
                      onFollow: onFollow,
                      margin: EdgeInsets.all(5.w),
                      isMyPet: isMyPets,
                    );
                  },
                  itemCount: isMyPets ? pets.length + 1 : pets.length,
                  scrollDirection: Axis.horizontal,
                ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          LocaleKeys.profile_post.trans(),
          style: UITextStyle.text_header_18_w600,
        ),
      ],
    );
  }
}
