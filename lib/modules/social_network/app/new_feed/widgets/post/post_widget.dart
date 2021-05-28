import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/comment/widgets/comment_widget.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/comment/widgets/send_comment_widget.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/comment/widgets/shimmer_comment_widget.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/post_widget_model.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/widgets/post_item_in_listview.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class PostDetail extends StatefulWidget {
  final Post post;

  const PostDetail({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends BaseViewState<PostDetail, PostWidgetModel> {
  @override
  void loadArguments() {
    viewModel.post = widget.post;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: UIColor.white,
          elevation: 0,
          title: Text(
            LocaleKeys.new_feed_post.trans(),
            style: UITextStyle.text_header_18_w600,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: UIColor.text_header,
              size: 20.w,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: PagedListView<int, Comment>(
                pagingController: viewModel.pagingController,
                builderDelegate: PagedChildBuilderDelegate<Comment>(
                  itemBuilder: (context, item, index) {
                    if (index == 0) {
                      return PostItemInListView(
                        post: viewModel.post,
                        onLikeClick: viewModel.onLikeClick,
                      );
                    }
                    return CommentWidget(
                      comment: viewModel.pagingController.itemList![index - 1],
                      onLikeCommentClick: viewModel.onLikeCommentClick,
                    );
                  },
                  firstPageProgressIndicatorBuilder: (_) => Column(
                    children: [
                      PostItemInListView(
                        post: viewModel.post,
                        onLikeClick: viewModel.onLikeClick,
                      ),
                      ShimmerCommentWidget()
                    ],
                  ),
                  noItemsFoundIndicatorBuilder: (_) => Center(
                    child: Text(
                      LocaleKeys.new_feed_no_comments_yet.trans(),
                      style: UITextStyle.text_secondary_12_w500,
                    ),
                  ),
                  newPageProgressIndicatorBuilder: (_) => ShimmerCommentWidget(),
                ),
                padding: EdgeInsets.only(
                  top: 10.h,
                  left: 10.w,
                  right: 10.w,
                ),
              ),
            ),
            SendCommentWidget(
              user: viewModel.user,
              commentEditingController: viewModel.commentEditingController,
              onSendComment: viewModel.onSendComment,
            )
          ],
        ),
      ),
    );
  }

  @override
  PostWidgetModel createViewModel() => injector<PostWidgetModel>();
}
