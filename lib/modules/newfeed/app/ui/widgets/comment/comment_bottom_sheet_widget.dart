import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/newfeed/app/ui/widgets/comment/comment_bottom_sheet_widget_model.dart';
import 'package:meowoof/modules/newfeed/app/ui/widgets/comment/widgets/comment_widget.dart';
import 'package:meowoof/modules/newfeed/app/ui/widgets/comment/widgets/send_comment_widget.dart';
import 'package:meowoof/modules/newfeed/app/ui/widgets/comment/widgets/shimmer_comment_widget.dart';
import 'package:meowoof/modules/newfeed/domain/models/comment.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class CommentBottomSheetWidget extends StatefulWidget {
  final int postId;

  const CommentBottomSheetWidget({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  _CommentBottomSheetWidgetState createState() => _CommentBottomSheetWidgetState();
}

class _CommentBottomSheetWidgetState extends BaseViewState<CommentBottomSheetWidget, CommentBottomSheetWidgetModel> {
  @override
  void loadArguments() {
    viewModel.postId = widget.postId;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (Get.height - 93).h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
        color: UIColor.white,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: UIColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              topRight: Radius.circular(30.r),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.close,
                size: 24.w,
                color: UIColor.text_header,
              ),
              onPressed: () => Get.back(),
              padding: EdgeInsets.only(right: 20.w),
              constraints: const BoxConstraints(),
            ),
          ],
          title: Text(
            LocaleKeys.new_feed_comment.trans(),
            style: UITextStyle.text_header_18_w600,
          ),
          centerTitle: true,
          elevation: 0,
          toolbarHeight: 30.h,
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: PagedListView<int, Comment>(
                pagingController: viewModel.pagingController,
                builderDelegate: PagedChildBuilderDelegate<Comment>(
                  itemBuilder: (context, item, index) {
                    return CommentWidget(
                      comment: item,
                      onLikeCommentClick: viewModel.onLikeCommentClick,
                    );
                  },
                  firstPageProgressIndicatorBuilder: (_) => ShimmerCommentWidget(),
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
  CommentBottomSheetWidgetModel createViewModel() => injector<CommentBottomSheetWidgetModel>();
}
