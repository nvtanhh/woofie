import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/core/ui/button.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/widgets/pick_date_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_vaccinated.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class AddVaccinatedDialog extends StatelessWidget {
  final RxDouble weight = RxDouble(1);
  final _descriptionEditController = TextEditingController(text: "");
  final _vaccineNameEditController = TextEditingController(text: "");
  double maxWeight = 20;
  double doubleValueParse = 0;
  PetVaccinated petVaccinated = PetVaccinated(id: 0);

  AddVaccinatedDialog({
    Key? key,
  }) : super(key: key);
  ToastService toastService = injector<ToastService>();

  final outSizeBorder = const OutlineInputBorder(borderSide: BorderSide(color: UIColor.silverSand));

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      child: Container(
        width: 400.w,
        height: 400.h,
        decoration: BoxDecoration(
          color: UIColor.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.all(10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.profile_vaccinated.trans(),
                        style: UITextStyle.text_header_18_w700,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    LocaleKeys.profile_select_date.trans(),
                    style: UITextStyle.text_header_18_w600,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  PickDateWidget(onDateSelected: onDateSelected),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    LocaleKeys.profile_vaccine_name.trans(),
                    style: UITextStyle.text_header_18_w600,
                  ),
                  TextField(
                    controller: _vaccineNameEditController,
                    decoration: InputDecoration(
                      border: outSizeBorder,
                      enabledBorder: outSizeBorder,
                      focusedBorder: outSizeBorder,
                      contentPadding: EdgeInsets.all(5.w),
                      suffixIcon: const MWIcon(MWIcons.edit,color: UIColor.accent,),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    LocaleKeys.profile_description.trans(),
                    style: UITextStyle.text_header_18_w600,
                  ),
                  TextField(
                    controller: _descriptionEditController,
                    decoration: InputDecoration(
                      border: outSizeBorder,
                      enabledBorder: outSizeBorder,
                      focusedBorder: outSizeBorder,
                      contentPadding: EdgeInsets.all(5.w),
                      suffixIcon: const MWIcon(MWIcons.edit,color: UIColor.accent,),
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MWButton(
                  onPressed: () {
                    if (Get.isDialogOpen!) {
                      Get.back();
                    }
                  },
                  child: Text(
                    LocaleKeys.profile_cancel.trans(),
                    style: UITextStyle.white_16_w500,
                  ),
                ),
                MWButton(
                  onPressed: () {
                    if (validate()) {
                      Get.back(result: petVaccinated);
                    }
                  },
                  child: Text(
                    LocaleKeys.profile_add.trans(),
                    style: UITextStyle.white_16_w500,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  bool validate() {
    petVaccinated.description = _descriptionEditController.text;
    petVaccinated.name = _vaccineNameEditController.text;
    if (petVaccinated.name == null || petVaccinated.name?.isEmpty == true) {
      toastService.warning(message: LocaleKeys.profile_vaccinate_name_invalid.trans(), context: Get.context!);
      return false;
    }
    if (petVaccinated.date == null) {
      toastService.warning(message: LocaleKeys.profile_date_invalid.trans(), context: Get.context!);
      return false;
    }
    return true;
  }

  void onDateSelected(DateTime date) {
    petVaccinated.date = date;
    return;
  }
}
