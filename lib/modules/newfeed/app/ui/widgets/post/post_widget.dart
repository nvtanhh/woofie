import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/newfeed/app/ui/widgets/comment/widgets/comment_widget.dart';
import 'package:meowoof/modules/newfeed/app/ui/widgets/comment/widgets/send_comment_widget.dart';
import 'package:meowoof/modules/newfeed/app/ui/widgets/comment/widgets/shimmer_comment_widget.dart';
import 'package:meowoof/modules/newfeed/app/ui/widgets/post/post_widget_model.dart';
import 'package:meowoof/modules/newfeed/app/ui/widgets/post_item_in_listview.dart';
import 'package:meowoof/modules/newfeed/domain/models/post.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class PostWidget extends StatefulWidget {
  final Post post;

  const PostWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends BaseViewState<PostWidget, PostWidgetModel> {
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
              child: Obx(
                () => ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return PostItemInListView(
                        post: viewModel.post,
                        onLikeClick: viewModel.onLikeClick,
                      );
                    }
                    if (!viewModel.isLoaded) {
                      return ShimmerCommentWidget();
                    } else {
                      return CommentWidget(
                        comment: viewModel.post.comments![index - 1],
                        onLikeCommentClick: viewModel.onLikeCommentClick,
                      );
                    }
                  },
                  itemCount: viewModel.isLoaded ? (viewModel.post.comments?.length ?? 0) + 1 : 2,
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
