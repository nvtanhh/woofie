import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/modules/newfeed/app/ui/widgets/images_view_widget.dart';
import 'package:meowoof/modules/newfeed/app/ui/widgets/info_user_post_widget.dart';
import 'package:meowoof/modules/newfeed/domain/models/post.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class PostItemInListView extends StatelessWidget {
  final Post post;
  final Function(int) onCommentClick;
  final Function(int) onLikeClick;

  const PostItemInListView({
    Key? key,
    required this.post,
    required this.onCommentClick,
    required this.onLikeClick,
  }) : super(key: key);

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
            maxLines: 3,
            style: UITextStyle.text_body_14_w500,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 13.h,
          ),
          Row(
            children: [
              InkWell(
                onTap: () => () => onLikeClick(post.id!),
                child: Row(
                  children: [
                    Assets.resources.icons.icReact.image(width: 24.w, height: 24.w, fit: BoxFit.fill),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text("${post.postReactsAggregate?.aggregate.count ?? "0"}", style: UITextStyle.black_14_w600),
                  ],
                ),
              ),
              SizedBox(
                width: 45.w,
              ),
              InkWell(
                onTap: () => onCommentClick(post.id!),
                child: Row(
                  children: [
                    Icon(
                      Icons.comment_outlined,
                      size: 24.w,
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
}
