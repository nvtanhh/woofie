import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class PetMenuActionWidget extends StatelessWidget {
  final Pet pet;
  final ValueChanged<Pet> onPetReport;
  final ValueChanged<Pet> onPetBlock;

  const PetMenuActionWidget({
    Key? key,
    required this.pet,
    required this.onPetReport,
    required this.onPetBlock,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PetMenuAction>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      padding: EdgeInsets.zero,
      onSelected: (PetMenuAction action) {
        switch (action) {
          case PetMenuAction.report:
            onPetBlock(pet);
            break;
          case PetMenuAction.block:
            onPetReport(pet);
            break;
          default:
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<PetMenuAction>(
          value: PetMenuAction.report,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const MWIcon(
                MWIcons.warning,
                customSize: 20,
              ),
              SizedBox(width: 10.w),
              Text(
                LocaleKeys.profile_report.trans(),
                style: UITextStyle.body_14_medium,
              ),
            ],
          ),
        ),
        PopupMenuItem<PetMenuAction>(
          value: PetMenuAction.block,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const MWIcon(
                MWIcons.block,
                customSize: 20,
              ),
              SizedBox(width: 10.w),
              Text(
                LocaleKeys.profile_block.trans(),
                style: UITextStyle.body_14_medium,
              ),
            ],
          ),
        )
      ],
      child: Container(
        width: 40.w,
        height: 40.h,
        margin: EdgeInsets.only(left: 20.w),
        padding: EdgeInsets.only(top: 5.h),
        decoration: BoxDecoration(color: UIColor.holder, borderRadius: BorderRadius.circular(10.r)),
        child: const Center(
          child: MWIcon(
            MWIcons.moreHoriz,
          ),
        ),
      ),
    );
  }
}

enum PetMenuAction { report, block }
