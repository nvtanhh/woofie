import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/comment/widgets/comment_actions_popup.dart';
import 'package:meowoof/modules/social_network/app/profile/user_profile/user_profile.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:timeago/timeago.dart' as time_ago;

class CommentWidget extends StatelessWidget {
  final Comment comment;
  final Function(int) onLikeCommentClick;
  final RxBool isLiked = RxBool(false);
  final Function? onDelete;
  final Function? onEdit;
  final Function? onReport;

  CommentWidget({
    Key? key,
    required this.comment,
    required this.onLikeCommentClick,
    this.onDelete,
    this.onEdit,
    this.onReport,
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
            imageUrl: comment.creator?.avatarUrl ?? "",
            radius: 10.r,
          ),
          SizedBox(
            width: 10.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => Get.to(
                  () => UserProfile(
                    user: comment.creator,
                  ),
                ),
                child: Text(
                  comment.creator?.name ?? "",
                  style: UITextStyle.text_header_14_w600,
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              CommentActionsTrailing(
                comment: comment,
                onDeleteComment: () => onDelete?.call(),
                onEditComment: () => onEdit?.call(),
                onReportComment: () => onReport?.call(),
                widget: Container(
                  width: Get.width * 0.7.w,
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(color: UIColor.holder, borderRadius: BorderRadius.circular(10.r)),
                  child: Text.rich(
                    TextSpan(
                      text: "",
                      children: createTagUser(),
                      style: UITextStyle.text_body_14_w400,
                    ),
                    overflow: TextOverflow.fade,
                  ),
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
    final List<InlineSpan> inLineSpan = [];
    const perfix = "@";
    String pattern = "";
    // ignore: unnecessary_raw_strings
    if (comment.commentTagUser != null && comment.commentTagUser!.isNotEmpty) {
      // ignore: prefer_interpolation_to_compose_strings, unnecessary_raw_strings
      pattern = r'(?<=' + perfix + ')(' + comment.commentTagUser!.map((e) => e.name!).join('|') + r')';
      RegExp _regex = RegExp(pattern);
      comment.content?.splitMapJoin(
        _regex,
        onMatch: (s) {
          pattern = comment.content!.trim().substring(s.start, s.end);
          inLineSpan.add(
            TextSpan(
              text: pattern,
              style: UITextStyle.text_header_16_w600,
              recognizer: TapGestureRecognizer()..onTap = () => openProfileUser(getUser(pattern)),
            ),
          );
          return pattern;
        },
        onNonMatch: (s) {
          inLineSpan.add(
            TextSpan(
              text: s,
              style: UITextStyle.text_body_14_w400,
            ),
          );
          return s;
        },
      );
    } else {
      inLineSpan.add(
        TextSpan(
          text: comment.content,
          style: UITextStyle.text_body_14_w400,
        ),
      );
    }

    return inLineSpan;
  }

  User? getUser(String useName) {
    try {
      return comment.commentTagUser?.singleWhere(
        (element) => element.name == useName,
      );
    } catch (e) {
      return null;
    }
  }

  void openProfileUser(User? user) {
    if (user == null) return;
    Get.to(
      () => UserProfile(
        user: user,
      ),
    );
  }
}
