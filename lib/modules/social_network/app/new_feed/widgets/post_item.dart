import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/functional_post_item.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/widgets/post_body.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/widgets/post_header.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class PostItem extends StatefulWidget {
  final Post post;
  final Function(Post)? onCommentClick;
  final Function(int) onLikeClick;
  final Function(Post) onPostClick;
  final VoidCallback onEditPost;
  final VoidCallback onDeletePost;
  final VoidCallback? onReportPost;

  const PostItem({
    super.key,
    required this.post,
    required this.onLikeClick,
    required this.onEditPost,
    required this.onDeletePost,
    required this.onPostClick,
    this.onCommentClick,
    this.onReportPost,
  });

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  void initState() {
    widget.post.isLiked ??= false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.post.type != PostType.activity) {
      return FunctionalPostItem(
        post: widget.post,
        onDeletePost: widget.onDeletePost,
        onEditPost: widget.onEditPost,
        onLikeClick: widget.onLikeClick,
        onCommentClick: widget.onCommentClick,
        onReportPost: widget.onReportPost,
        onPostClick: widget.onPostClick,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PostHeader(
          post: widget.post,
          onDeletePost: widget.onDeletePost,
          onEditPost: widget.onEditPost,
          onReportPost: widget.onReportPost,
        ),
        GestureDetector(
          onTap: () => widget.onPostClick.call(widget.post),
          child: PostBody(post: widget.post),
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
    if (!widget.post.isLiked!) {
      widget.post.increasePostReactsCount();
    } else {
      widget.post.decreasePostReactsCount();
    }
    widget.post.isLiked = !widget.post.isLiked!;
    widget.onLikeClick(widget.post.id);
    widget.post.notifyUpdate();
    Post.factory.addToCache(widget.post);
  }

  Widget _buildPostActions() {
    return Row(
      children: [
        SizedBox(
          width: 60.w,
          child: GestureDetector(
            onTap: () => likeClick(),
            child: Row(
              children: [
                Obx(
                  () {
                    return MWIcon(
                      widget.post.updateSubjectValue.isLiked ?? false
                          ? MWIcons.react
                          : MWIcons.unReact,
                      size: MWIconSize.small,
                    );
                  },
                ),
                SizedBox(
                  width: 5.w,
                ),
                Obx(
                  () => Text(
                    "${widget.post.updateSubjectValue.postReactsCount ?? 0}",
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
            onTap: () => widget.onCommentClick?.call(widget.post),
            highlightColor: UIColor.white,
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
                    "${widget.post.updateSubjectValue.postCommentsCount ?? 0}",
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
