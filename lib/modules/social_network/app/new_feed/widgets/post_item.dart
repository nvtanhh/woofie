import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/widgets/post_body.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/widgets/post_header.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class PostItem extends StatelessWidget {
  final Post post;
  final Function(Post)? onCommentClick;
  final Function(int) onLikeClick;
  final Function(Post)? onPostClick;
  final VoidCallback onEditPost;
  final VoidCallback onDeletePost;

  PostItem({
    Key? key,
    required this.post,
    required this.onLikeClick,
    required this.onEditPost,
    required this.onDeletePost,
    this.onCommentClick,
    this.onPostClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PostHeader(
          post: post,
          onDeletePost: onDeletePost,
          onEditPost: onEditPost,
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

  Widget _buildPostActions() {
    return Row(
      children: [
        SizedBox(
          width: 60.w,
          child: InkWell(
            onTap: () => likeClick(),
            child: Row(
              children: [
                Obx(
                  () {
                    return MWIcon(
                      post.updateSubject.isLiked??false ? MWIcons.react : MWIcons.unReact,
                      size: MWIconSize.small,
                    );
                  },
                ),
                SizedBox(
                  width: 5.w,
                ),
                Obx(
                  () => Text(
                    "${post.updateSubject.postReactsCount ?? 0}",
                    style: UITextStyle.black_14_w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 30.w,
        ),
        // onCommentClick?.call(post.id),/
        SizedBox(
          width: 60.w,
          child: InkWell(
            onTap: () => onCommentClick?.call(post),
            child: Row(
              children: [
                MWIcon(
                  MWIcons.comment,
                ),
                SizedBox(
                  width: 5.w,
                ),
                Obx(
                  () => Text(
                    "${post.updateSubject.postCommentsCount ?? 0}",
                    style: UITextStyle.black_14_w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
