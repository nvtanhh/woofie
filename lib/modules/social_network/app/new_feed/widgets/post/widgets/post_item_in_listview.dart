import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/widgets/images_view_widget.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/widgets/info_user_post_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class PostItemInListView extends StatelessWidget {
  final Post post;
  final Function(int)? onCommentClick;
  final Function(int) onLikeClick;
  final Function(Post)? onPostClick;

  PostItemInListView({
    Key? key,
    required this.post,
    this.onCommentClick,
    required this.onLikeClick,
    this.onPostClick,
  }) : super(key: key) {
    post.isLiked ??= false;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPostClick?.call(post),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoUserPostWidget(
            pets: post.taggegPets ?? [],
            postCreatedAt: post.createdAt!,
            user: post.creator!,
          ),
          ImagesViewWidget(
            medias: post.medias ?? [],
          ),
          Text(
            post.content ?? "",
            style: UITextStyle.text_body_14_w500,
            overflow: TextOverflow.clip,
          ),
          SizedBox(
            height: 13.h,
          ),
          Row(
            children: [
              SizedBox(
                width: 60.w,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => likeClick(),
                      child: Obx(
                        () => MWIcon(
                          post.updateSubjectValue.isLiked! ? MWIcons.react : MWIcons.unReact,
                          size: MWIconSize.small,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Obx(
                      () => Text(
                        "${post.updateSubjectValue.postReactsCount ?? 0}",
                        style: UITextStyle.black_14_w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 45.w,
              ),
              SizedBox(
                width: 60.w,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => onCommentClick?.call(post.id),
                      child: MWIcon(
                        MWIcons.comment,
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Obx(
                      () => Text(
                        "${post.updateSubjectValue.postCommentsCount ?? 0}",
                        style: UITextStyle.black_14_w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void likeClick() {
    if (!post.isLiked!) {
      post.increasePostReactsCount();
    } else {
      post.decreasePostReactsCount();
    }
    post.isLiked = !post.isLiked!;
    onLikeClick(post.id);
    post.notifyUpdate();
    Post.factory.addToCache(post);
  }
}
