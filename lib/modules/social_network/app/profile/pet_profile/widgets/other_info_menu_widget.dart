import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/profile/pet_profile/widgets/other_infor/owner_history.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class OtherInfoMenuWidget extends StatelessWidget {
  final bool isMyPet;
  final Function? onDeletePost;
  final Pet pet;

  const OtherInfoMenuWidget({
    super.key,
    this.onDeletePost,
    required this.isMyPet,
    required this.pet,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            LocaleKeys.profile_other_information.trans(),
            style: UITextStyle.text_header_18_w600,
          ),
          leading: IconButton(
            icon: const MWIcon(MWIcons.back),
            onPressed: () => Get.back(),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  child: Row(
                    children: [
                      MWIcon(
                        MWIcons.otherInformation,
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
                GestureDetector(
                  onTap: () {
                    Get.to(() => PetOwnerHistoryScreen(
                          ownerHistories: pet.allOwners ?? [],
                        ),);
                  },
                  child: Row(
                    children: [
                      MWIcon(
                        MWIcons.petOwners,
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
                if (isMyPet)
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      onDeletePost?.call();
                    },
                    child: Row(
                      children: [
                        const MWIcon(
                          MWIcons.delete,
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
      ),
    );
  }
}
