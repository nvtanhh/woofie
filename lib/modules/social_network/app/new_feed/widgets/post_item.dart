import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post_header.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_text_style.dart';

import 'post_body.dart';

class PostItem extends StatelessWidget {
  final Post post;
  final Function(int)? onCommentClick;
  final Function(int) onLikeClick;
  final Function(Post)? onPostClick;
  final RxBool isLiked = RxBool(false);
  final RxInt countLike = RxInt(0);
  final VoidCallback onEdidPost;
  final VoidCallback onDeletePost;

  PostItem({
    Key? key,
    required this.post,
    required this.onLikeClick,
    required this.onEdidPost,
    required this.onDeletePost,
    this.onCommentClick,
    this.onPostClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    isLiked.value = post.isLiked ?? false;
    countLike.value = post.postReactsAggregate?.aggregate.count ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PostHeader(
          post: post,
          onDeletePost: onDeletePost,
          onEditPost: onEdidPost,
        ),
        InkWell(
          onTap: () => onPostClick?.call(post),
          child: PostBody(post: post),
        ),
        SizedBox(
          height: 13.h,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: _buildPostActions(),
        ),
        SizedBox(
          height: 25.h,
        ),
      ],
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

  Widget _buildPostActions() {
    return Row(
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
          width: 30.w,
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
              Text(
                "${post.commentsAggregate?.aggregate.count ?? "0"}",
                style: UITextStyle.black_14_w600,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
