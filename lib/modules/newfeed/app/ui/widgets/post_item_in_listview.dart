import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/modules/newfeed/app/ui/widgets/images_view_widget.dart';
import 'package:meowoof/modules/newfeed/app/ui/widgets/info_user_post_widget.dart';
import 'package:meowoof/modules/newfeed/domain/models/post.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class PostItemInListView extends StatelessWidget {
  final Post post;
  final Function(int) onCommentClick;
  final Function(int) onLikeClick;
  final RxBool isLiked = RxBool(false);
  final RxInt countLike = RxInt(0);

  PostItemInListView({
    Key? key,
    required this.post,
    required this.onCommentClick,
    required this.onLikeClick,
  }) : super(key: key) {
    isLiked.value = post.isLiked ?? false;
    countLike.value = post.postReactsAggregate?.aggregate.count ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600.h,
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
                      child: Assets.resources.icons.icReact.image(
                        width: 24.w,
                        height: 24.w,
                        fit: BoxFit.fill,
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
                      onTap: () => onCommentClick(post.id!),
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
    if (isLiked.value) {
      countLike.value++;
    } else {
      countLike.value--;
    }
    isLiked.value = !isLiked.value;
    onLikeClick(post.id!);
  }
}
