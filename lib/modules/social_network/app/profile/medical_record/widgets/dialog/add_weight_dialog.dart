import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/core/ui/button.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/widgets/pick_date_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_weight.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

// ignore: must_be_immutable
class AddWeightDialog extends StatelessWidget {
  final RxDouble weight = RxDouble(1);
  final _weightEditController = TextEditingController(text: "0.5");
  double maxWeight = 20;
  double doubleValueParse = 0;
  PetWeight? petWeight;
  ToastService toastService = injector<ToastService>();
  bool isUpdate = false;

  AddWeightDialog({
    Key? key,
    this.petWeight,
  }) : super(key: key) {
    if (petWeight == null) {
      petWeight = PetWeight(id: 0);
    } else {
      isUpdate = true;
      weight.value = petWeight!.weight!;
      _weightEditController.text = petWeight!.weight.toString();
    }
  }

  void onTextChange(String value) {
    doubleValueParse = double.tryParse(_weightEditController.text) ?? 0.5;
    if (doubleValueParse >= maxWeight) {
      if (doubleValueParse >= 200) {
        _weightEditController.text = "200";
        maxWeight = 200;
        weight.value = maxWeight;
        return;
      }
      maxWeight = doubleValueParse + 10;
      weight.value = doubleValueParse;
      return;
    }
    if (doubleValueParse < 0.5) {
      _weightEditController.text = "0.5";
      weight.value = 0.5;
      return;
    }
    weight.value = doubleValueParse;
  }

  final outSizeBorder = const OutlineInputBorder(borderSide: BorderSide(color: UIColor.silverSand));

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      child: Container(
        width: 400.w,
        height: 300.h,
        decoration: BoxDecoration(
          color: UIColor.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.all(10.w),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    LocaleKeys.profile_weight.trans(),
                    style: UITextStyle.text_header_18_w700,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    width: 80.w,
                    height: 50.h,
                    child: TextField(
                      controller: _weightEditController,
                      decoration: InputDecoration(
                        border: outSizeBorder,
                        enabledBorder: outSizeBorder,
                        focusedBorder: outSizeBorder,
                        contentPadding: EdgeInsets.all(5.w),
                        suffix: Text(
                          "Kg",
                          style: UITextStyle.text_body_16_w700,
                        ),
                      ),
                      onChanged: onTextChange,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Obx(
                    () => Slider(
                      value: weight.value,
                      onChanged: (value) {
                        weight.value = value.toPrecision(1);
                        _weightEditController.text = value.toPrecision(1).toString();
                        if (value == maxWeight) {
                          if (maxWeight >= 200) return;
                          maxWeight += 10;
                        }
                      },
                      min: 0.5,
                      max: maxWeight,
                      label: "${weight.value}",
                      activeColor: UIColor.primary,
                      inactiveColor: UIColor.accent,
                    ),
                  ),
                  Text(
                    LocaleKeys.profile_select_date.trans(),
                    style: UITextStyle.text_header_18_w700,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  PickDateWidget(
                    onDateSelected: onDateSelected,
                    datePick: petWeight?.date,
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
                    style: UITextStyle.white_18_w500,
                  ),
                ),
                MWButton(
                  onPressed: () {
                    if (validate()) {
                      Get.back(result: petWeight);
                    }
                  },
                  child: Text(
                    isUpdate?LocaleKeys.profile_save.trans():LocaleKeys.profile_add.trans(),
                    style: UITextStyle.white_18_w500,
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
    petWeight!.weight = weight.value;
    if ((petWeight!.weight ?? 0) < 0.5 || (petWeight!.weight ?? 0) > 210) {
      toastService.warning(message: LocaleKeys.profile_weight_invalid.trans(), context: Get.context!);
      return false;
    }
    if (petWeight!.date == null) {
      toastService.warning(message: LocaleKeys.profile_date_invalid.trans(), context: Get.context!);
      return false;
    }
    return true;
  }

  void onDateSelected(DateTime date) {
    petWeight!.date = date;
    return;
  }
}
