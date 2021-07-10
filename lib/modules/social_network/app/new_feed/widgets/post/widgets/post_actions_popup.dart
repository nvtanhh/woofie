import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class PostActionsTrailing extends StatelessWidget {
  final Post post;
  final VoidCallback onDeletePost;
  final VoidCallback onEditPost;
  final VoidCallback onReportPost;

  const PostActionsTrailing({
    Key? key,
    required this.post,
    required this.onDeletePost,
    required this.onEditPost,
    required this.onReportPost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PostTrailingAction>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      padding: EdgeInsets.zero,
      onSelected: (PostTrailingAction action) {
        switch (action) {
          case PostTrailingAction.edit:
            onEditPost();
            break;
          case PostTrailingAction.delete:
            onDeletePost();
            break;
          case PostTrailingAction.report:
            onReportPost();
            break;
          default:
        }
      },
      itemBuilder: (BuildContext context) => [
        if (post.isMyPost)
          PopupMenuItem<PostTrailingAction>(
            value: PostTrailingAction.edit,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const MWIcon(
                  MWIcons.edit,
                  customSize: 20,
                ),
                SizedBox(width: 10.w),
                Text(
                  LocaleKeys.new_feed_edit_post.trans(),
                  style: UITextStyle.body_14_medium,
                ),
              ],
            ),
          ),
        if (post.isMyPost)
          PopupMenuItem<PostTrailingAction>(
            value: PostTrailingAction.delete,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const MWIcon(
                  MWIcons.delete,
                  customSize: 20,
                ),
                SizedBox(width: 10.w),
                Text(
                  LocaleKeys.new_feed_delete_post.trans(),
                  style: UITextStyle.body_14_medium,
                ),
              ],
            ),
          ),
        if (!post.isMyPost)
          PopupMenuItem<PostTrailingAction>(
            value: PostTrailingAction.report,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const MWIcon(
                  MWIcons.report,
                  customSize: 20,
                ),
                SizedBox(width: 10.w),
                Text(
                  LocaleKeys.new_feed_report_post.trans(),
                  style: UITextStyle.body_14_medium,
                ),
              ],
            ),
          ),
      ],
      child: Container(
        width: 20.w,
        alignment: Alignment.topRight,
        padding: EdgeInsets.only(top: 5.h),
        child: const MWIcon(
          MWIcons.moreVerical,
          themeColor: MWIconThemeColor.secondaryText,
        ),
      ),
    );
  }
}

enum PostTrailingAction { delete, edit, report }
