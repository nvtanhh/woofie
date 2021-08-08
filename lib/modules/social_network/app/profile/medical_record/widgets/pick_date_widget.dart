import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/helpers/format_helper.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

// ignore: must_be_immutable
class PickDateWidget extends StatelessWidget {
  DateTime? datePick;
  RxString data = RxString("");
  Function(DateTime) onDateSelected;

  PickDateWidget({
    Key? key,
    required this.onDateSelected,
    this.datePick,
  }) : super(key: key) {
    if (datePick != null) {
      data.value = FormatHelper.formatDateTime(datePick, pattern: "dd/MM/yyyy");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5.w),
      decoration: BoxDecoration(border: Border.all(color: UIColor.silverSand), borderRadius: BorderRadius.circular(5.r)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => Text(
              data.value.isEmpty ? "dd/mm/yyyy" : data.value,
              style: data.value.isEmpty ? UITextStyle.second_12_medium : UITextStyle.text_body_12_w600,
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
    );
  }

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
      data.value = FormatHelper.formatDateTime(datePick, pattern: "dd/MM/yyyy");
      onDateSelected(datePick!);
    }
  }
}
