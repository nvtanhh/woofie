import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/widgets/not_have_data_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_worm_flushed.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class WormFlushedWidget extends StatelessWidget {
  final double width;
  final double height;
  final List<PetWormFlushed> wormFlushed;
  final bool isMyPet;
  final Function onAddClick;

  const WormFlushedWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.wormFlushed,
    required this.isMyPet,
    required this.onAddClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: UIColor.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: UIColor.gray25,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: EdgeInsets.all(10.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: genData(),
      ),
    );
  }

  List<Widget> genData() {
    if (wormFlushed.isEmpty) {
      return [
        NotHaveData(
          isMyPet: isMyPet,
          onAddClick: onAddClick,
        )
      ];
    }
    List<Widget> list = [];
    list.add(Row(
      children: [
        Assets.resources.icons.icPill.image(
          fit: BoxFit.fill,
          width: 24.w,
          height: 24.w,
        ),
        SizedBox(
          width: 10.w,
        ),
        Text(
          LocaleKeys.profile_worm_flush.trans(),
          style: UITextStyle.text_body_12_w600,
        ),
      ],
    ));
    list.add(SizedBox(
      height: 10.h,
    ));
    for (var worm in wormFlushed) {
      list.add(SizedBox(
        height: 50.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: UIColor.primary,
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: SizedBox(
                width: 10.w,
                height: 10.w,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat("dd/MM/yyyy").format(
                      worm.createdAt ?? DateTime.now(),
                    ),
                    style: UITextStyle.text_body_12_w600,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    worm.description ?? "",
                    style: UITextStyle.text_secondary_10_w600,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ));
    }
    list.add(
      MWIcon(
        MWIcons.arrowDown,
      ),
    );
    return list;
  }
}
