import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/newfeed/app/ui/widgets/comment/comment_bottom_sheet_widget_model.dart';
import 'package:meowoof/modules/newfeed/app/ui/widgets/comment/widgets/comment_widget.dart';
import 'package:meowoof/modules/newfeed/app/ui/widgets/comment/widgets/shimmer_comment_widget.dart';
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
      ),
      padding: EdgeInsets.all(10.r),
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 60.h,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: Text(
                      LocaleKeys.new_feed_comment.trans(),
                      style: UITextStyle.text_header_18_w600,
                    ),
                  ),
                  Positioned(
                    right: 10.w,
                    top: 15.h,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 24.w,
                      ),
                      onPressed: () => Get.back(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Obx(
                () {
                  if (viewModel.isLoading) {
                    return ShimmerCommentWidget();
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        if (viewModel.comments.isEmpty) {
                          return Text(
                            LocaleKeys.new_feed_no_comments_yet.trans(),
                            style: UITextStyle.text_secondary_12_w500,
                          );
                        }
                        return CommentWidget(
                          comment: viewModel.comments[index],
                          onLikeCommentClick: viewModel.onLikeCommentClick,
                        );
                      },
                      itemCount: viewModel.comments.length,
                    );
                  }
                },
              ),
            ),
            Container(
              height: 60.h,
              padding: EdgeInsets.only(top: 10.h),
              child: Row(
                children: [
                  ImageWithPlaceHolderWidget(
                    width: 45.w,
                    height: 45.w,
                    fit: BoxFit.fill,
                    imageUrl: viewModel.user?.avatar?.url ?? "",
                    radius: 10.r,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: LocaleKeys.new_feed_write_a_comment.trans(),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none),
                        fillColor: UIColor.holder,
                        focusColor: UIColor.black,
                        filled: true,
                      ),
                      controller: viewModel.commentEditingController,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: UIColor.primary,
                      size: 30.w,
                    ),
                    onPressed: () => viewModel.onSendComment(),
                    constraints: const BoxConstraints(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  CommentBottomSheetWidgetModel createViewModel() => injector<CommentBottomSheetWidgetModel>();
}
