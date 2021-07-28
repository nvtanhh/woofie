import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class OtherInfoMenuWidget extends StatelessWidget {
  final bool isMyPet;
  final Function? onDeletePost;

  const OtherInfoMenuWidget({
    Key? key,
    this.onDeletePost,
    required this.isMyPet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            LocaleKeys.profile_other_information.trans(),
            style: UITextStyle.text_header_18_w700,
          ),
          leading: IconButton(
            icon: const MWIcon(MWIcons.back),
            onPressed: () => Get.back(),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              InkWell(
                child: Row(
                  children: [
                    MWIcon(
                      MWIcons.otherInformation,
                      customSize: 24.w,
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                    Text(
                      LocaleKeys.profile_other_information.trans(),
                      style: UITextStyle.text_body_14_w500,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              InkWell(
                child: Row(
                  children: [
                    MWIcon(
                      MWIcons.petOwners,
                      customSize: 24.w,
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                    Text(
                      LocaleKeys.profile_pet_owners.trans(),
                      style: UITextStyle.text_body_14_w500,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              if(isMyPet)
              InkWell(
                onTap: () {
                  Get.back();
                  onDeletePost?.call();
                },
                child: Row(
                  children: [
                    MWIcon(
                      MWIcons.delete,
                      customSize: 24.w,
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                    Text(
                      LocaleKeys.profile_delete_pet.trans(),
                      style: UITextStyle.text_body_14_w500,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
