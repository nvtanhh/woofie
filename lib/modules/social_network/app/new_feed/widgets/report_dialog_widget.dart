import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/ui/button.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class ReportDialogWidget extends StatelessWidget {
  final String? title;
  TextEditingController textEditingController = TextEditingController();

  ReportDialogWidget({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    final boderStyle = OutlineInputBorder(
      borderSide: const BorderSide(
        color: UIColor.textBody,
      ),
      borderRadius: BorderRadius.circular(10.r),
    );
    return Dialog(
      child: Container(
        width: 200.w,
        height: 320.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: UIColor.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title ?? "Report",
                    style: UITextStyle.text_header_18_w700,
                  ),
                  InkWell(
                    onTap: () => Get.back(),
                    child: const MWIcon(
                      MWIcons.close,
                      color: UIColor.black,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 50.h,
              ),
              TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  labelText: "Nội dung",
                  labelStyle: UITextStyle.text_body_14_w600,
                  border: boderStyle,
                  focusedBorder: boderStyle,
                  enabledBorder: boderStyle,
                ),
                minLines: 3,
                maxLines: null,
              ),
              SizedBox(
                height: 50.h,
              ),
              Align(
                child: MWButton(
                  onPressed: () {
                    if (textEditingController.text.isEmpty) return;
                    Get.back(result: textEditingController.text);
                  },
                  borderRadius: BorderRadius.circular(10.r),
                  child: Text(
                    "Gửi",
                    style: UITextStyle.white_18_w500,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
