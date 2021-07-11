import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/helpers/format_helper.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/core/ui/button.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/profile/edit_pet_profile/edit_pet_profile_model.dart';
import 'package:meowoof/modules/social_network/app/profile/edit_pet_profile/widgets/dropdown_breads_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/gender.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class EditPetProfileWidget extends StatefulWidget {
  final Pet pet;

  const EditPetProfileWidget({Key? key, required this.pet}) : super(key: key);

  @override
  _EditPetProfileWidgetState createState() => _EditPetProfileWidgetState();
}

class _EditPetProfileWidgetState extends BaseViewState<EditPetProfileWidget, EditPetProfileWidgetModel> {
  @override
  void loadArguments() {
    viewModel.pet = widget.pet;
    super.loadArguments();
  }

  UnderlineInputBorder underlineInputBorder = UnderlineInputBorder(
    borderRadius: BorderRadius.circular(20.r),
    borderSide: const BorderSide(color: UIColor.primary),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            LocaleKeys.profile_pet_information.trans(),
            style: UITextStyle.text_header_18_w600,
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              child: MWButton(
                onPressed: () => viewModel.onSaveClick(),
                minWidth: 40.w,
                borderRadius: BorderRadius.circular(10.r),
                child: Text(
                  LocaleKeys.profile_save.trans(),
                  style: UITextStyle.white_12_w600,
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () => viewModel.onUpdateAvatarClick(),
                    child: SizedBox(
                      height: 110.h,
                      width: 110.h,
                      child: Stack(
                        children: [
                          Obx(() {
                            if (viewModel.avatarFile == null) {
                              return MWAvatar(
                                avatarUrl: viewModel.pet.avatarUrl ?? "",
                                customSize: 92.h,
                                borderRadius: 15.r,
                              );
                            } else {
                              return MWAvatar(
                                avatarFile: viewModel.avatarFile,
                                customSize: 92.h,
                                borderRadius: 15.r,
                              );
                            }
                          }),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 30.w,
                              height: 30.w,
                              decoration: BoxDecoration(color: UIColor.accent, borderRadius: BorderRadius.circular(5.r)),
                              // padding: EdgeInsets.all(5.w),
                              child: const MWIcon(
                                MWIcons.camera,
                                color: UIColor.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: viewModel.nameEditingController,
                          style: UITextStyle.text_header_24_w600,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            suffixIcon: MWIcon(
                              MWIcons.edit,
                              color: UIColor.primary,
                            ),
                          ),
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
                                onPressed: () => viewModel.genderChange(Gender.male),
                                style: TextButton.styleFrom(
                                  backgroundColor: viewModel.genderSelected == Gender.male ? UIColor.accent2 : UIColor.textSecondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                ),
                                child: SizedBox(
                                  height: 20.h,
                                  width: 70.w,
                                  child: Center(
                                    child: Text(
                                      LocaleKeys.add_pet_pet_male.trans(),
                                      style: viewModel.genderSelected == Gender.male ? UITextStyle.white_12_w500 : UITextStyle.text_body_12_w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Obx(
                              () => TextButton(
                                onPressed: () => viewModel.genderChange(Gender.female),
                                style: TextButton.styleFrom(
                                  backgroundColor: viewModel.genderSelected == Gender.female ? UIColor.accent2 : UIColor.textSecondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                ),
                                child: SizedBox(
                                  height: 20.h,
                                  width: 70.w,
                                  child: Center(
                                    child: Text(
                                      LocaleKeys.add_pet_pet_female.trans(),
                                      style: viewModel.genderSelected == Gender.female ? UITextStyle.white_12_w500 : UITextStyle.text_body_12_w600,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
              TextField(
                controller: viewModel.introduceEditingController,
                style: UITextStyle.text_body_18_w500,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 15.w),
                  enabledBorder: underlineInputBorder,
                  focusedBorder: underlineInputBorder,
                  labelText: LocaleKeys.profile_introduce.trans(),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.w, right: 15.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.add_pet_age.trans(),
                          style: UITextStyle.text_body_14_w600,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Container(
                          height: 40.h,
                          width: 150.w,
                          padding: EdgeInsets.only(left: 5.w),
                          decoration: BoxDecoration(border: Border.all(color: UIColor.silverSand), borderRadius: BorderRadius.circular(5.r)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(
                                () => Text(
                                  viewModel.datePicker == null
                                      ? "dd/mm/yyyy"
                                      : FormatHelper.formatDateTime(viewModel.datePicker, pattern: "dd/MM/yyyy"),
                                  style: viewModel.datePicker == null ? UITextStyle.second_12_medium : UITextStyle.text_body_12_w600,
                                ),
                              ),
                              IconButton(
                                icon: MWIcon(
                                  MWIcons.calendar,
                                  customSize: 20.w,
                                  color: UIColor.primary,
                                ),
                                onPressed: () => viewModel.onCalendarPress(),
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.profile_bread.trans(),
                          style: UITextStyle.text_body_14_w600,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Container(
                          height: 40.h,
                          width: 150.w,
                          decoration: BoxDecoration(
                            border: Border.all(color: UIColor.silverSand),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: Obx(
                            () => DropdownBreadsWidget(
                              breads: viewModel.petBreads,
                              initValue: viewModel.pet.petBreed,
                              onPetBreadChange: viewModel.onPetBreadChange,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  EditPetProfileWidgetModel createViewModel() => injector<EditPetProfileWidgetModel>();
}
