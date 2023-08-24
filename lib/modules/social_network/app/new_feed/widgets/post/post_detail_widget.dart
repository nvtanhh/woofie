import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/comment/widgets/comment_widget.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/comment/widgets/send_comment/send_comment_widget.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/comment/widgets/shimmer_comment_widget.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/post_detail_widget_model.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/widgets/post_item_in_listview.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class PostDetail extends StatefulWidget {
  final Post post;

  const PostDetail({
    super.key,
    required this.post,
  });

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState
    extends BaseViewState<PostDetail, PostDetailWidgetModel> {
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
              color: UIColor.textHeader,
              size: 20.w,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => viewModel.onRefresh(),
                child: PagedListView<int, Comment>(
                  pagingController:
                      viewModel.commentServiceModel.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Comment>(
                    itemBuilder: (context, item, index) {
                      if (index == 0) {
                        return PostItemInListView(
                          post: viewModel.post,
                          onLikeClick: viewModel.onLikeClick,
                        );
                      }
                      return CommentWidget(
                        comment: item,
                        onLikeCommentClick: (_) =>
                            viewModel.commentServiceModel.onLikeComment(
                          item,
                          viewModel.post.id,
                        ),
                        onReport: () => viewModel.commentServiceModel
                            .onReportComment(item, "content"),
                        onDelete: () => viewModel.commentServiceModel
                            .onDeleteComment(item, index),
                        onEdit: () => viewModel.commentServiceModel
                            .setOldComment(item, index),
                      );
                    },
                    firstPageProgressIndicatorBuilder: (_) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ShimmerCommentWidget(),
                      ],
                    ),
                    newPageProgressIndicatorBuilder: (_) =>
                        ShimmerCommentWidget(),
                  ),
                  padding: EdgeInsets.only(
                    top: 10.h,
                    left: 16.w,
                    right: 16.w,
                  ),
                ),
              ),
            ),
            SendCommentWidget(
              onSendComment: viewModel.onSendComment,
              post: viewModel.post,
              comment: viewModel.commentServiceModel.commentUpdate,
            )
          ],
        ),
      ),
    );
  }

  @override
  PostDetailWidgetModel createViewModel() => injector<PostDetailWidgetModel>();
}
