import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/ui/button.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class ReportDialogWidget extends StatelessWidget {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 200.w,
        height: 280.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: UIColor.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(
                "Report",
                style: UITextStyle.text_header_18_w700,
              ),
              trailing: InkWell(
                onTap: () => Get.back(),
                child: const MWIcon(
                  MWIcons.close,
                  color: UIColor.black,
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                labelText: "Content",
                labelStyle: UITextStyle.text_body_16_w700,
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Align(
              child: MWButton(
                onPressed: () {
                  if (textEditingController.text.isEmpty) return;
                  Get.back(result: textEditingController.text);
                },
                child: Text(
                  "Report",
                  style: UITextStyle.white_18_w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
