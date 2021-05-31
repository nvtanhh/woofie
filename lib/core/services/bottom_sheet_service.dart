import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/comment/comment_bottom_sheet_widget.dart';
import 'package:meowoof/modules/social_network/app/save_post/widgets/tag_pet_bottom_sheet.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

@lazySingleton
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

  void showTagPetBottomSheet({
    required List<Pet> userPets,
    required RxList<Pet> taggedPets,
    required ValueChanged<Pet> onPetChosen,
  }) {
    showMaterialModalBottomSheet(
      context: Get.context!,
      builder: (context) => TagPetBottomSheetWidget(
        userPets: userPets,
        taggedPets: taggedPets,
        onPetChosen: onPetChosen,
      ),
      shape: defaultBottomSheetShape,
    );
  }
}
