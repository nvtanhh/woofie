import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/comment/comment_bottom_sheet_widget.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/post_actions_popup.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomSheetService {
  final defaultBottomSheetShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(30.r),
      topLeft: Radius.circular(30.r),
    ),
  );
  void showComments(int idPost) {
    showMaterialModalBottomSheet(
      context: Get.context!,
      builder: (context) => CommentBottomSheetWidget(
        postId: idPost,
      ),
      shape: defaultBottomSheetShape,
    );
  }
}
