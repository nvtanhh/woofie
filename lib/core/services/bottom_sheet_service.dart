import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/comment/comment_bottom_sheet_widget.dart';
import 'package:meowoof/modules/social_network/app/save_post/widgets/tag_pet_bottom_sheet.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

@lazySingleton
class BottomSheetService {
  final defaultBottomSheetShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(30.r),
      topLeft: Radius.circular(30.r),
    ),
  );
  void showComments(Post post, BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => CommentBottomSheetWidget(
        post: post,
      ),
      shape: defaultBottomSheetShape,
    );
  }

  Future showTagPetBottomSheet({
    required List<Pet> userPets,
    required ValueChanged<Pet> onPetChosen,
    List<Pet>? taggedPets,
    String? title,
    bool needConfirmButton = false
  }) {
    return showMaterialModalBottomSheet(
      context: Get.context!,
      builder: (context) => TagPetBottomSheetWidget(
        userPets: userPets,
        taggedPets: taggedPets,
        onPetChosen: onPetChosen,
        title: title,
        needConfirmButton: needConfirmButton,
      ),
      shape: defaultBottomSheetShape,
    );
  }
}
