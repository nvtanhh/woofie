import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/helpers/datetime_helper.dart';
import 'package:meowoof/core/ui/button_widget.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/widgets/post_actions_popup.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class FunctionalPostItem extends StatelessWidget {
  final Post post;
  final Function(Post)? onCommentClick;
  final Function(int) onLikeClick;
  final Function(Post) onPostClick;
  final VoidCallback onEditPost;
  final VoidCallback onDeletePost;
  final VoidCallback? onReportPost;

  const FunctionalPostItem({
    super.key,
    required this.post,
    required this.onLikeClick,
    required this.onPostClick,
    required this.onEditPost,
    required this.onDeletePost,
    this.onCommentClick,
    this.onReportPost,
  });

  @override
  Widget build(BuildContext context) {
    final String age = DateTimeHelper.calcAge(post.taggegPets?.first.dob);
    return Container(
      constraints: BoxConstraints(maxHeight: 450.h),
      padding: EdgeInsets.only(bottom: 25.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: UIColor.white,
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 50.h),
            child: ImageWithPlaceHolderWidget(
              imageUrl: post.medias?.isEmpty ?? true
                  ? (post.taggegPets?.first.avatarUrl ?? '')
                  : post.medias!.first.url!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              topLeftRadius: 20.r,
              topRightRadius: 20.r,
              placeHolderImagePath:
                  "resources/images/fallbacks/pet-avatar-fallback.jpg",
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => onPostClick(post),
              child: Container(
                constraints: BoxConstraints(minHeight: 130.h),
                decoration: BoxDecoration(
                  color: UIColor.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: defineColor(post.type),
                    width: 2.w,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  post.taggegPets?.first.name ?? "",
                                  style: UITextStyle.text_header_18_w700,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                if (post.distanceUserToPost != null)
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_rounded,
                                        color: UIColor.primary,
                                        size: 16.w,
                                      ),
                                      SizedBox(
                                        width: 3.w,
                                      ),
                                      Text(
                                        "${post.distanceUserToPost} Km",
                                        style: UITextStyle.text_body_12_w500,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: UIColor.pattensBlue2,
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 6.h,),
                                  child: Text(
                                    post.taggegPets?.first.gender?.index == 0
                                        ? LocaleKeys.add_pet_pet_male.trans()
                                        : LocaleKeys.add_pet_pet_female.trans(),
                                    style: UITextStyle.dodger_blue_12_w500,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                if (age != 'Unknown')
                                  Container(
                                    decoration: BoxDecoration(
                                      color: UIColor.whisper,
                                      borderRadius: BorderRadius.circular(5.r),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 6.h,),
                                    child: Text(
                                      age,
                                      style: UITextStyle.text_body_12_w500,
                                    ),
                                  )
                              ],
                            ),
                          ],
                        ),
                        MWIcon(
                          defineIcon(post.type),
                          customSize: 36.w,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      post.content ?? "",
                      maxLines: 2,
                      style: UITextStyle.body_14_reg,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 10.w,
            top: 10.h,
            child: PostActionsTrailing(
              post: post,
              onDeletePost: onDeletePost,
              onEditPost: onEditPost,
              onReportPost: onReportPost,
              child: ButtonWidget(
                contentPadding: EdgeInsets.zero,
                width: 35.w,
                height: 35.w,
                borderRadius: 20.w,
                backgroundColor: UIColor.white,
                contentWidget: MWIcon(
                  MWIcons.moreHoriz,
                  customSize: 28.w,
                ),
              ),
            ),
          )
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
}
