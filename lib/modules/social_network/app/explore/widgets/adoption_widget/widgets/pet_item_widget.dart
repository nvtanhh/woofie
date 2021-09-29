import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/helpers/datetime_helper.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class PetItemWidget extends StatelessWidget {
  final Pet pet;
  final Post post;
  final VoidCallback? onClick;
  final PostType postType;
  final double? height;
  final double? width;
  final bool showDistance;
  final bool isConstraintsSize;

  const PetItemWidget({
    Key? key,
    required this.pet,
    required this.postType,
    required this.post,
    this.onClick,
    this.height,
    this.width,
    this.showDistance = true,
    this.isConstraintsSize = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String age = DateTimeHelper.calcAge(pet.dob);
    return InkWell(
      onTap: onClick,
      child: Container(
        width: isConstraintsSize ? width ?? 165.w : null,
        height: isConstraintsSize ? height ?? 213.h : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: UIColor.white,
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 50.h),
              child: ImageWithPlaceHolderWidget(
                imageUrl: post.medias?.isEmpty ?? true
                    ? (pet.avatarUrl ?? '')
                    : post.medias!.first.url!,
                fit: BoxFit.cover,
                topLeftRadius: 15.r,
                topRightRadius: 15.r,
                bottomLeftRadius: 0,
                bottomRightRadius: 0,
                placeHolderImage:
                    "resources/images/fallbacks/pet-avatar-fallback.jpg",
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: UIColor.white,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: defineColor(postType),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: showDistance ? 16.w : 12.w,
                  vertical: 10.h,
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                        if (showDistance)
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
                                "${post.distanceUserToPost ?? ""} Km",
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
                                color: pet.gender?.index == 0
                                    ? UIColor.pattensBlue2
                                    : UIColor.genderFemaleBackground,
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              padding: EdgeInsets.all(5.w),
                              child: Text(
                                pet.gender?.index == 0
                                    ? LocaleKeys.add_pet_pet_male.trans()
                                    : LocaleKeys.add_pet_pet_female.trans(),
                                style: pet.gender?.index == 0
                                    ? UITextStyle.dodger_blue_10_w500
                                    : UITextStyle.dodger_pink_10_w500,
                              ),
                            ),
                            if (age != 'Unknown')
                              Container(
                                decoration: BoxDecoration(
                                  color: UIColor.whisper,
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                margin: EdgeInsets.only(left: 5.w),
                                padding: EdgeInsets.all(5.w),
                                child: Text(
                                  age,
                                  style: UITextStyle.text_body_10_w500,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                          ],
                        )
                      ],
                    ),
                    Positioned(
                      right: 0,
                      child: MWIcon(
                        defineIcon(postType),
                        customSize: 24.w,
                      ),
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

  MWIconData defineIcon(PostType postType) {
    switch (postType) {
      case PostType.mating:
        return MWIcons.icMating;
      case PostType.adop:
        return MWIcons.icAdoption;
      case PostType.lose:
        return MWIcons.icLose;
      default:
        return MWIcons.icAdoption;
    }
  }

  Color defineColor(PostType postType) {
    switch (postType) {
      case PostType.mating:
        return UIColor.matingColor.withOpacity(.6);
      case PostType.adop:
        return UIColor.adoptionColor.withOpacity(.6);
      case PostType.lose:
        return UIColor.danger;
      default:
        return UIColor.accent2;
    }
  }
}
