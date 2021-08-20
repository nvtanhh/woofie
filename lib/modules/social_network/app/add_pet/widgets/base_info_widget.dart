import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/helpers/datetime_helper.dart';
import 'package:meowoof/core/helpers/format_helper.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/gender.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

// ignore: must_be_immutable
class BaseInfoWidget extends StatelessWidget {
  final Rx<Gender> _genderSelected = Rx<Gender>(Gender.male);
  final Rxn<File?> _imageFile = Rxn<File?>();
  final picker = ImagePicker();
  final _nameEditingController = TextEditingController();
  final _bioEditingController = TextEditingController();
  final Function(String) onNameChange;
  final Function(String) onBioChange;
  final Function(DateTime?) onAgeChange;
  final Function(File) onAvatarChange;
  final Function(Gender) onGenderChange;
  final RxString _ageData = RxString("");

  BaseInfoWidget({
    Key? key,
    required this.onNameChange,
    required this.onAgeChange,
    required this.onAvatarChange,
    required this.onGenderChange,
    required this.onBioChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
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
                        Obx(
                          () => Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10.r),
                              image: DecorationImage(
                                image: image(_imageFile.value),
                                fit: _imageFile.value == null
                                    ? BoxFit.contain
                                    : BoxFit.cover,
                              ),
                            ),
                            width: 100.w,
                            height: 135.h,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        GestureDetector(
                          onTap: () => onUpdateAvatarClick(),
                          child: Text(
                            LocaleKeys.add_pet_avatar.trans(),
                            style: UITextStyle.primary_14_w500,
                          ),
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
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 5.h,
                                  horizontal: 10.w,
                                ),
                              ),
                              onChanged: onNameChange,
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Text(
                            LocaleKeys.add_pet_age.trans(),
                            style: UITextStyle.text_body_14_w600,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            height: 40.h,
                            padding: EdgeInsets.only(left: 10.w),
                            decoration: BoxDecoration(
                                border: Border.all(color: UIColor.silverSand),
                                borderRadius: BorderRadius.circular(5.r)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(
                                  () => Text(
                                    _ageData.value.isEmpty
                                        ? "dd/mm/yyyy"
                                        : _ageData.value,
                                    style: _ageData.value.isEmpty
                                        ? UITextStyle.second_12_medium
                                        : UITextStyle.text_body_12_w600,
                                  ),
                                ),
                                IconButton(
                                  icon: MWIcon(
                                    MWIcons.calendar,
                                    customSize: 20.w,
                                    color: UIColor.primary,
                                  ),
                                  onPressed: () => onCalendarPress(),
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
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
                                    backgroundColor:
                                        _genderSelected.value == Gender.male
                                            ? UIColor.primary
                                            : UIColor.holder,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.r),
                                    ),
                                  ),
                                  child: SizedBox(
                                    height: 34.h,
                                    width: 80.w,
                                    child: Center(
                                      child: Text(
                                        LocaleKeys.add_pet_pet_male.trans(),
                                        style:
                                            _genderSelected.value == Gender.male
                                                ? UITextStyle.white_14_w600
                                                : UITextStyle.text_body_14_w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Obx(
                                () => TextButton(
                                  onPressed: () => genderChange(Gender.female),
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        _genderSelected.value == Gender.female
                                            ? UIColor.primary
                                            : UIColor.holder,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.r),
                                    ),
                                  ),
                                  child: SizedBox(
                                    height: 34.h,
                                    width: 80.w,
                                    child: Center(
                                      child: Text(
                                        LocaleKeys.add_pet_pet_female.trans(),
                                        style: _genderSelected.value ==
                                                Gender.female
                                            ? UITextStyle.white_14_w600
                                            : UITextStyle.text_body_14_w600,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.add_pet_pet_description.trans(),
                  style: UITextStyle.text_body_14_w600,
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextField(
                  controller: _bioEditingController,
                  decoration: InputDecoration(
                    border: outlineInputBorder(),
                    enabledBorder: outlineInputBorder(),
                    focusedBorder: outlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 5.h,
                      horizontal: 10.w,
                    ),
                    hintText: "Cute thân thiện",
                    hintStyle: UITextStyle.second_14_medium,
                  ),
                  onChanged: onBioChange,
                )
              ],
            )
          ],
        ),
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
        color: UIColor.silverSand,
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

  Future onUpdateAvatarClick() async {
    List<File>? files;
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ["jpg", "png", "JPG", "PNG"]);
    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
    }

    if (files != null) {
      _imageFile.value = files[0];
      _imageFile.refresh();
      onAvatarChange(_imageFile.value!);
    }
  }

  DateTime? datePick;

  Future onCalendarPress() async {
    datePick = await showDatePicker(
      context: Get.context!,
      initialDate: datePick ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (datePick == null) {
      return;
    } else {
      _ageData.value =
          "${FormatHelper.formatDateTime(datePick, pattern: "dd/MM/yyyy")} (${DateTimeHelper.calcAge(datePick)})";
      onAgeChange(datePick);
    }
  }

  void onTapFieldAge() {}
}
