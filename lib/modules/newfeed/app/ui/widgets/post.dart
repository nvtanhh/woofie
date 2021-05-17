import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/modules/newfeed/app/ui/widgets/images_view_widget.dart';
import 'package:meowoof/modules/newfeed/app/ui/widgets/post_header.dart';
import 'package:meowoof/modules/newfeed/domain/models/post.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:meowoof/theme/icon.dart';
import 'package:meowoof/theme/ui_color.dart';

class PostItem extends StatelessWidget {
  final Post post;
  final Function(int)? onCommentClick;
  final Function(int) onLikeClick;
  final Function(Post)? onPostClick;
  final RxBool isLiked = RxBool(false);
  final RxInt countLike = RxInt(0);

  PostItem({
    Key? key,
    required this.post,
    this.onCommentClick,
    required this.onLikeClick,
    this.onPostClick,
  }) : super(key: key) {
    isLiked.value = post.isLiked ?? false;
    countLike.value = post.postReactsAggregate?.aggregate.count ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPostClick?.call(post),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeader(
            post: post,
            onPostDeleted: _onPostDeleted,
            onPostEdited: _onPostEdited,
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
          _buildPostActions()
        ],
      ),
    );
  }

  void likeClick() {
    if (isLiked.value) {
      countLike.value++;
    } else {
      countLike.value--;
    }
    isLiked.value = !isLiked.value;
    onLikeClick(post.id!);
  }

  void _onPostDeleted(Post value) {}

  void _onPostEdited(Post value) {}

  Widget _buildPostActions() {
    return Row(
      children: [
        SizedBox(
          width: 60.w,
          child: Row(
            children: [
              InkWell(
                onTap: () => likeClick(),
                child: MWIcon(
                  MWIcons.react,
                  size: MWIconSize.small,
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
                onTap: () => onCommentClick?.call(post.id!),
                child: const MWIcon(
                  MWIcons.comment,
                  size: MWIconSize.small,
                  color: UIColor.text_header,
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
