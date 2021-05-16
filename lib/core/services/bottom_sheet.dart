import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meowoof/modules/newfeed/app/ui/widgets/comment/comment_bottom_sheet_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomSheetService {
  void onCommentClick(int idPost) {
    showMaterialModalBottomSheet(
      context: Get.context!,
      builder: (context) => CommentBottomSheetWidget(
        postId: idPost,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.r),
          topLeft: Radius.circular(30.r),
        ),
      ),
    );
  }
}
