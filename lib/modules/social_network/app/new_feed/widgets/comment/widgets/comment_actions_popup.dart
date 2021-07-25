import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class CommentActionsTrailing extends StatelessWidget {
  final Comment comment;
  final VoidCallback? onDeleteComment;
  final VoidCallback? onEditComment;
  final VoidCallback? onReportComment;
  final Widget widget;

  const CommentActionsTrailing({
    Key? key,
    required this.comment,
    required this.onDeleteComment,
    required this.onEditComment,
    required this.onReportComment,
    required this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<CommentTrailingAction>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      padding: EdgeInsets.zero,
      onSelected: (CommentTrailingAction action) {
        switch (action) {
          case CommentTrailingAction.edit:
            onEditComment?.call();
            break;
          case CommentTrailingAction.delete:
            onDeleteComment?.call();
            break;
          case CommentTrailingAction.report:
            onReportComment?.call();
            break;
          default:
        }
      },
      itemBuilder: (BuildContext context) => [
        if (comment.isMyComment!)
          PopupMenuItem<CommentTrailingAction>(
            value: CommentTrailingAction.edit,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const MWIcon(
                  MWIcons.edit,
                  customSize: 20,
                ),
                SizedBox(width: 10.w),
                Text(
                  LocaleKeys.new_feed_edit_comment.trans(),
                  style: UITextStyle.body_14_medium,
                ),
              ],
            ),
          ),
        if (comment.isMyComment!)
          PopupMenuItem<CommentTrailingAction>(
            value: CommentTrailingAction.delete,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const MWIcon(
                  MWIcons.delete,
                  customSize: 20,
                ),
                SizedBox(width: 10.w),
                Text(
                  LocaleKeys.new_feed_delete_comment.trans(),
                  style: UITextStyle.body_14_medium,
                ),
              ],
            ),
          ),
        if (!comment.isMyComment!)
          PopupMenuItem<CommentTrailingAction>(
            value: CommentTrailingAction.report,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const MWIcon(
                  MWIcons.report,
                  customSize: 20,
                ),
                SizedBox(width: 10.w),
                Text(
                  LocaleKeys.new_feed_report_comment.trans(),
                  style: UITextStyle.body_14_medium,
                ),
              ],
            ),
          ),
      ],
      child: widget,
    );
  }
}

enum CommentTrailingAction { delete, edit, report }
