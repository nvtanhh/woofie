import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:timeago/timeago.dart' as time_ago;

class CommentWidget extends StatelessWidget {
  final Comment comment;
  final Function(int) onLikeCommentClick;
  final RxBool isLiked = RxBool(false);

  CommentWidget({
    Key? key,
    required this.comment,
    required this.onLikeCommentClick,
  }) : super(key: key) {
    isLiked.value = comment.isLiked ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h, top: 20.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageWithPlaceHolderWidget(
            width: 40.w,
            height: 40.w,
            fit: BoxFit.cover,
            imageUrl: comment.creator?.avatar?.url ?? "",
            radius: 10.r,
          ),
          SizedBox(
            width: 10.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment.creator?.name ?? "",
                style: UITextStyle.text_header_14_w600,
              ),
              SizedBox(
                height: 5.h,
              ),
              Container(
                width: Get.width * 0.7.w,
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(color: UIColor.holder, borderRadius: BorderRadius.circular(10.r)),
                child: Text.rich(
                  TextSpan(
                    text: comment.content,
                    children: createTagUser(),
                    style: UITextStyle.text_body_14_w400,
                  ),
                  overflow: TextOverflow.fade,
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time_ago.format(comment.createdAt ?? DateTime.now(), locale: 'vi'),
                    style: UITextStyle.text_secondary_10_w600,
                  ),
                  SizedBox(
                    width: 26.w,
                  ),
                  Obx(
                    () => Text.rich(
                      TextSpan(
                        text: LocaleKeys.new_feed_like.trans(),
                        style: isLiked.value ? UITextStyle.primary_10_w600 : UITextStyle.text_body_10_w600,
                        recognizer: TapGestureRecognizer()..onTap = () => onLikeClick(),
                      ),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  void onLikeClick() {
    isLiked.value = !isLiked.value;
    onLikeCommentClick(comment.id);
  }

  List<InlineSpan> createTagUser() {
    if (comment.commentTagUser == null) return [];
    final List<InlineSpan> inLineSpan = [];
    for (var i = 0; i < (comment.commentTagUser?.length ?? 0); i++) {
      inLineSpan.add(
        TextSpan(
          text: "${comment.commentTagUser?[i].user?.name ?? ""}${i != (comment.commentTagUser?.length ?? 0) - 1 ? ", " : " "}",
          style: UITextStyle.text_header_16_w600,
          recognizer: TapGestureRecognizer()..onTap = () => openProfileUser(comment.commentTagUser?[i].user?.id ?? 0),
        ),
      );
    }
    inLineSpan.add(
      TextSpan(
        text: comment.content,
        style: UITextStyle.text_body_14_w400,
      ),
    );
    return inLineSpan;
  }

  void openProfileUser(int idUser) {
    printInfo(info: "GO to profile user");
  }
}
