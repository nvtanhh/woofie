import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/newfeed/app/ui/widgets/comment/comment_bottom_sheet_widget_model.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class CommentBottomSheetWidget extends StatefulWidget {
  final int postId;

  const CommentBottomSheetWidget({
    Key key,
    this.postId,
  }) : super(key: key);

  @override
  _CommentBottomSheetWidgetState createState() => _CommentBottomSheetWidgetState();
}

class _CommentBottomSheetWidgetState extends BaseViewState<CommentBottomSheetWidget, CommentBottomSheetWidgetModel> {
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
      child: Column(
        children: [
          SizedBox(
            height: 60.h,
            child: Stack(
              children: [
                Text(
                  LocaleKeys.new_feed_comment.trans(),
                  style: UITextStyle.text_header_18_w600,
                ),
                Positioned(
                  right: 10,
                  child: Icon(
                    Icons.close,
                    size: 24.w,
                  ),
                )
              ],
            ),
          ),
          const Expanded(
            child: SizedBox(),
          ),
          SizedBox(
            height: 50.h,
            child: Row(
              children: [
                ImageWithPlaceHolderWidget(
                  width: 45.w,
                  height: 45.w,
                  fit: BoxFit.fill,
                  imageUrl: viewModel.user.avatar.url,
                  radius: 10.r,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: LocaleKeys.new_feed_write_a_comment.trans(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: UIColor.holder),
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  CommentBottomSheetWidgetModel createViewModel() => injector<CommentBottomSheetWidgetModel>();
}
