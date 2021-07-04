import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/images_view_widget.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/widgets/info_user_post_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class PostItemInListView extends StatelessWidget {
  final Post post;
  final Function(int)? onCommentClick;
  final Function(int) onLikeClick;
  final Function(Post)? onPostClick;
  final RxBool isLiked = RxBool(false);
  final RxInt countLike = RxInt(0);

  PostItemInListView({
    Key? key,
    required this.post,
    this.onCommentClick,
    required this.onLikeClick,
    this.onPostClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    isLiked.value = post.isLiked ?? false;
    countLike.value = post.postReactsAggregate?.aggregate.count ?? 0;
    return InkWell(
      onTap: () => onPostClick?.call(post),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoUserPostWidget(
            pets: post.pets!,
            postCreatedAt: post.createdAt!,
            user: post.creator!,
          ),
          ImagesViewWidget(
            medias: post.medias ?? [],
          ),
          Text(
            post.content ?? "",
            maxLines: 4,
            style: UITextStyle.text_body_14_w500,
            overflow: TextOverflow.ellipsis,
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
                          isLiked.value ? MWIcons.react : MWIcons.unReact,
                          size: MWIconSize.small,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Obx(
                      () => Text(
                        "${countLike.value}",
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
                      child: Icon(
                        Icons.comment_outlined,
                        size: 24.w,
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      "${post.commentsAggregate?.aggregate.count ?? "0"}",
                      style: UITextStyle.black_14_w600,
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
    if (!isLiked.value) {
      countLike.value++;
    } else {
      countLike.value--;
    }
    isLiked.value = !isLiked.value;
    onLikeClick(post.id);
    post.isLiked = isLiked.value;
    post.postReactsAggregate?.aggregate.count = countLike.value;
  }
}
