import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';

class PetItemWidget extends StatelessWidget {
  final Pet pet;
  const PetItemWidget({
    Key? key,
    required this.pet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165.w,
      height: 157.h,
      child: Stack(
        children: [ImageWithPlaceHolderWidget(imageUrl: pet.avatar!)],
      ),
    );
  }
}
