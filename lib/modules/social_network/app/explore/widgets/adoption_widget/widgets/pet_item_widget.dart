import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class PetItemWidget extends StatelessWidget {
  final Pet pet;
  final Function onClick;

  const PetItemWidget({
    Key? key,
    required this.pet,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(),
      child: Container(
        width: 165.w,
        height: 213.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: UIColor.white,
        ),
        child: Stack(
          children: [
            ImageWithPlaceHolderWidget(
              imageUrl: pet.avatar?.url ?? "",
              width: 165.w,
              height: 157.h,
              fit: BoxFit.cover,
              topLeftRadius: 15.r,
              topRightRadius: 15.r,
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 84.h,
                width: 165.w,
                decoration: BoxDecoration(
                  color: UIColor.aliceBlue2,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: UIColor.viking,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 5.h,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          pet.name ?? "",
                          style: UITextStyle.text_header_14_w700,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: UIColor.primary,
                          size: 15.w,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          "0 Km",
                          style: UITextStyle.text_body_10_w500,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: UIColor.pattensBlue2,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          padding: EdgeInsets.all(5.w),
                          child: Text(
                            pet.gender?.index == 0 ? "Đực" : "Cái",
                            style: UITextStyle.dodger_blue_10_w500,
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: UIColor.whisper,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          padding: EdgeInsets.all(5.w),
                          child: Text(
                            "9 tháng",
                            style: UITextStyle.dodger_blue_10_w500,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
