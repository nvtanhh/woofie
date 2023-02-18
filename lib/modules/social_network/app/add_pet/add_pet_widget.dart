import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/add_pet/add_pet_widget_model.dart';
import 'package:meowoof/modules/social_network/app/add_pet/widgets/base_info_widget.dart';
import 'package:meowoof/modules/social_network/app/add_pet/widgets/select_pet_breed_widget.dart';
import 'package:meowoof/modules/social_network/app/add_pet/widgets/select_pet_type_widget.dart';
import 'package:meowoof/modules/social_network/app/add_pet/widgets/step_add_pet_widget.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class AddPetWidget extends StatefulWidget {
  final bool isAddMore;

  const AddPetWidget({super.key, this.isAddMore = false});

  @override
  _AddPetWidgetState createState() => _AddPetWidgetState();
}

class _AddPetWidgetState
    extends BaseViewState<AddPetWidget, AddPetWidgetModel> {
  @override
  void loadArguments() {
    viewModel.isAddMore = widget.isAddMore;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            onPressed: viewModel.onPressBack,
            icon: const MWIcon(MWIcons.back),
          ),
          title: Text(
            LocaleKeys.add_pet_add_pet.trans(),
            style: UITextStyle.text_header_24_w600,
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: Column(
          children: [
            Obx(
              () => StepAddPetWidget(
                currentStep: viewModel.currentStepAddPet,
              ),
            ),
            Expanded(
              child: Obx(() {
                switch (viewModel.currentStepAddPet) {
                  case 1:
                    return Obx(
                      () => SelectPetTypeWidget(
                        petTypes: viewModel.petTypes,
                        onSelectedIndex: viewModel.onPetTypeSelectedIndex,
                        selectedIndex: viewModel.indexPetTypeSelected,
                      ),
                    );
                  case 2:
                    return Obx(
                      () => SelectPetBreedWidget(
                        selectedIndex: viewModel.indexPetBreedSelected,
                        onSelectedIndex: viewModel.onPetBreedSelectedIndex,
                        petBreeds: viewModel.petBreeds,
                      ),
                    );
                  case 3:
                    return BaseInfoWidget(
                      onAgeChange: viewModel.onAgeChange,
                      onGenderChange: viewModel.onGenderChange,
                      onAvatarChange: viewModel.onAvatarChange,
                      onNameChange: viewModel.onNameChange,
                      onBioChange: viewModel.onBioChange,
                    );
                  default:
                    return Container();
                }
              }),
            ),
            Obx(() {
              switch (viewModel.currentStepAddPet) {
                case 1:
                  return TextButton(
                    onPressed: () => viewModel.doNotHavePet(),
                    child: Text(
                      LocaleKeys.add_pet_do_not_have_pet.trans(),
                      style: UITextStyle.text_secondary_18_w600,
                    ),
                  );
                case 2:
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextButton(
                          onPressed: viewModel.unknownBreed,
                          child: Text(
                            LocaleKeys.add_pet_unknown.trans(),
                            style: UITextStyle.text_secondary_18_w600,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: viewModel.continues,
                        style: TextButton.styleFrom(
                          backgroundColor: UIColor.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                        ),
                        child: SizedBox(
                          height: 50.h,
                          width: 100.w,
                          child: Center(
                            child: Text(
                              LocaleKeys.add_pet_continue.trans(),
                              textAlign: TextAlign.center,
                              style: UITextStyle.text_white_18_w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                case 3:
                  return TextButton(
                    onPressed: () => viewModel.onDone(),
                    style: TextButton.styleFrom(
                      backgroundColor: UIColor.primary,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 67.h,
                          child: Center(
                            child: Text(
                              LocaleKeys.add_pet_done.trans(),
                              style: UITextStyle.white_18_w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                default:
                  return Container();
              }
            }),
          ],
        ),
      ),
    );
  }

  @override
  AddPetWidgetModel createViewModel() => injector<AddPetWidgetModel>();
}
