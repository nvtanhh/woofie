import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/helpers/datetime_helper.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class ChatSenderPostPreviewer extends StatelessWidget {
  final Post post;
  final VoidCallback? onRemovePost;

  const ChatSenderPostPreviewer(this.post, {super.key, this.onRemovePost});

  @override
  Widget build(BuildContext context) {
    final pet = post.taggegPets![0];
    final String age = DateTimeHelper.calcAge(pet.dob);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.r),
      child: Stack(
        children: [
          ImageWithPlaceHolderWidget(
            imageUrl: post.medias?.isEmpty ?? true
                ? (post.taggegPets![0].avatarUrl ?? '')
                : post.medias!.first.url!,
            placeHolderImagePath:
                "resources/images/fallbacks/pet-avatar-fallback.jpg",
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              decoration: BoxDecoration(
                color: UIColor.white,
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(
                  color: defineColor(post.type),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 8.h,
              ),
              child: Row(
                children: [
                  MWIcon(
                    defineIcon(post.type),
                    customSize: 24.w,
                  ),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.taggegPets![0].name ?? "",
                          style: UITextStyle.text_header_14_w700,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: pet.gender?.index == 0
                                      ? UIColor.pattensBlue2
                                      : UIColor.genderFemaleBackground,
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 2.h,),
                                child: Text(
                                  pet.gender?.index == 0
                                      ? LocaleKeys.add_pet_pet_male.trans()
                                      : LocaleKeys.add_pet_pet_female.trans(),
                                  style: pet.gender?.index == 0
                                      ? UITextStyle.dodger_blue_10_w500
                                      : UITextStyle.dodger_pink_10_w500,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ),
                              ),
                            ),
                            if (age != 'Unknown')
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: UIColor.whisper,
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                  margin: EdgeInsets.only(left: 5.w),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 2.h,),
                                  child: Text(
                                    age,
                                    style: UITextStyle.text_body_10_w500,
                                    overflow: TextOverflow.clip,
                                    softWrap: false,
                                  ),
                                ),
                              )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (onRemovePost != null)
            Positioned(
              top: 5.h,
              right: 5.w,
              child: _buildRemoveButton(),
            ),
        ],
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

  Widget _buildRemoveButton() {
    return GestureDetector(
      onTap: onRemovePost,
      child: SizedBox(
        width: 25.w,
        height: 25.h,
        child: FloatingActionButton(
          onPressed: onRemovePost,
          backgroundColor: Colors.black54,
          child: const MWIcon(
            MWIcons.close,
            customSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
