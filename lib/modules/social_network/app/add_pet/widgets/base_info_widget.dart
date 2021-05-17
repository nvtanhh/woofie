import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/gender.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class BaseInfoWidget extends StatelessWidget {
  final Rx<Gender> _genderSelected = Rx<Gender>(Gender.male);
  final Rx<File?> _imageFile = Rx<File?>(null);
  final picker = ImagePicker();
  final _nameEditingController = TextEditingController();
  final _ageEditingController = TextEditingController();
  final Function(String) onNameChange;
  final Function(String) onAgeChange;
  final Function(File) onAvatarChange;
  final Function(Gender) onGenderChange;

  BaseInfoWidget({
    Key? key,
    required this.onNameChange,
    required this.onAgeChange,
    required this.onAvatarChange,
    required this.onGenderChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          SizedBox(
            height: 40.h,
          ),
          Text(
            LocaleKeys.add_pet_base_info.trans(),
            style: UITextStyle.text_body_18_w500,
          ),
          SizedBox(
            height: 30.h,
          ),
          SizedBox(
            height: 250.h,
            child: Row(
              children: [
                SizedBox(
                  width: 115,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => getImage(),
                        child: Obx(
                          () => Container(
                            decoration: BoxDecoration(
                              color: UIColor.alice_blue,
                              image: DecorationImage(
                                image: image(_imageFile.value),
                                fit: BoxFit.contain,
                              ),
                            ),
                            width: 100.w,
                            height: 135.h,
                            child: Icon(
                              Icons.image,
                              size: 30.w,
                              color: UIColor.text_secondary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        LocaleKeys.add_pet_avatar.trans(),
                        style: UITextStyle.primary_12_w500,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.add_pet_name.trans(),
                          style: UITextStyle.text_body_14_w600,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        SizedBox(
                          height: 40.h,
                          child: TextField(
                            controller: _nameEditingController,
                            decoration: InputDecoration(
                              border: outlineInputBorder(),
                              enabledBorder: outlineInputBorder(),
                              focusedBorder: outlineInputBorder(),
                            ),
                            onChanged: onNameChange,
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Text(
                          LocaleKeys.add_pet_age.trans(),
                          style: UITextStyle.text_body_14_w600,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        SizedBox(
                          height: 40.h,
                          child: TextField(
                            controller: _ageEditingController,
                            decoration: InputDecoration(
                              border: outlineInputBorder(),
                              enabledBorder: outlineInputBorder(),
                              focusedBorder: outlineInputBorder(),
                            ),
                            onChanged: onAgeChange,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          LocaleKeys.add_pet_gender.trans(),
                          style: UITextStyle.text_body_14_w600,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => TextButton(
                                onPressed: () => genderChange(Gender.male),
                                style: TextButton.styleFrom(
                                  backgroundColor: _genderSelected.value == Gender.male ? UIColor.accent2 : UIColor.text_secondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                ),
                                child: SizedBox(
                                  height: 34.h,
                                  width: 80.w,
                                  child: Center(
                                    child: Text(
                                      "Duc",
                                      style: _genderSelected.value == Gender.male ? UITextStyle.white_12_w500 : UITextStyle.text_body_12_w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Obx(
                              () => TextButton(
                                onPressed: () => genderChange(Gender.female),
                                style: TextButton.styleFrom(
                                  backgroundColor: _genderSelected.value == Gender.female ? UIColor.accent2 : UIColor.text_secondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                ),
                                child: SizedBox(
                                  height: 34.h,
                                  width: 80.w,
                                  child: Center(
                                    child: Text(
                                      "Cai",
                                      style: _genderSelected.value == Gender.female ? UITextStyle.white_12_w500 : UITextStyle.text_body_12_w600,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void genderChange(Gender gender) {
    _genderSelected.value = gender;
    onGenderChange(gender);
  }

  OutlineInputBorder outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.r),
      borderSide: const BorderSide(
        color: UIColor.silver_sand,
      ),
    );
  }

  ImageProvider image(File? file) {
    if (file == null) {
      return const AssetImage("resources/icons/ic_cat_face.png");
    } else {
      return FileImage(file);
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _imageFile.value = File(pickedFile.path);
      onAvatarChange(_imageFile.value!);
    }
  }
}
