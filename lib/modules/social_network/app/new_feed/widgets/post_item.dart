import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/widgets/post_header.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post_item_model.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

import './post/widgets/post_body.dart';

class PostItem extends StatefulWidget {
  final Post post;
  final VoidCallback onPostDeleted;

  const PostItem({
    Key? key,
    required this.post,
    required this.onPostDeleted,
  }) : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends BaseViewState<PostItem, PostItemModel> {
  @override
  void loadArguments() {
    viewModel.post = widget.post;
    viewModel.onPostDeleted = widget.onPostDeleted;
    super.loadArguments();
  }

  final RxBool isLiked = RxBool(false);

  final RxInt countLike = RxInt(0);

  @override
  Widget build(BuildContext context) {
    isLiked.value = widget.post.isLiked ?? false;
    countLike.value = widget.post.postReactsAggregate?.aggregate.count ?? 0;
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeader(
            post: viewModel.updatablePost,
            onDeletePost: viewModel.onDeletePost,
            onEditPost: viewModel.onWantsToEditPost,
            onReportPost: viewModel.onReportPost,
          ),
          InkWell(
            onTap: viewModel.onPostClick,
            child: PostBody(post: viewModel.updatablePost),
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
    viewModel.onLikeClick(widget.post.id);
    widget.post.isLiked = isLiked.value;
    widget.post.postReactsAggregate?.aggregate.count = countLike.value;
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
                  "${viewModel.updatablePost.reactionsCounts}",
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
                onTap: viewModel.onCommentClick,
                child: MWIcon(
                  MWIcons.comment,
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Obx(
                () => Text(
                  "${viewModel.updatablePost.commentsAggregate?.aggregate.count ?? "0"}",
                  style: UITextStyle.black_14_w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  PostItemModel createViewModel() => injector<PostItemModel>();
}
