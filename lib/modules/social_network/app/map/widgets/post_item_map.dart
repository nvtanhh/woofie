import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_pet_detail/adoption_pet_detail_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class PostMapWidget extends StatelessWidget {
  final Post post;

  const PostMapWidget({required this.post});

  @override
  Widget build(BuildContext context) {
    final Pet pet = post.taggegPets![0];
    return GestureDetector(
      onTap: () {
        Get.to(() => AdoptionPetDetailWidget(post: post));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        width: 0.75.sw,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              width: 0.3.sw,
              child: ImageWithPlaceHolderWidget(
                clickable: false,
                imageUrl: post.medias?.isEmpty ?? true
                    ? (pet.avatarUrl ?? '')
                    : post.medias!.first.url!,
                fit: BoxFit.cover,
                topLeftRadius: 15.r,
                topRightRadius: 0,
                bottomLeftRadius: 15.r,
                bottomRightRadius: 0,
                placeHolderImage:
                    "resources/images/fallbacks/pet-avatar-fallback.jpg",
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        MWIcon(
                          defineIcon(post.type),
                          customSize: 28.w,
                        ),
                      ],
                    ),
                    Text(
                      pet.name ?? "",
                      style: UITextStyle.text_header_18_w700,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                    Row(
                      children: [
                        const MWIcon(
                          MWIcons.location,
                          color: UIColor.primary,
                          customSize: 18,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          post.location?.name ?? "",
                          style: UITextStyle.text_body_12_w400,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Text(
                      '(${post.distanceUserToPost?.toString()} Km)',
                      style: UITextStyle.text_body_12_w600,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  MWIconData defineIcon(PostType postType) {
    switch (postType) {
      case PostType.mating:
        return MWIcons.icMatting;
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
