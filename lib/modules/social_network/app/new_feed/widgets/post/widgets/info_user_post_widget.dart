import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/profile/pet_profile/pet_profile.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:timeago/timeago.dart' as time_ago;

class InfoUserPostWidget extends StatelessWidget {
  final User user;
  final List<Pet> pets;
  final DateTime postCreatedAt;

  const InfoUserPostWidget({
    Key? key,
    required this.user,
    required this.pets,
    required this.postCreatedAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.w,
      child: Row(
        children: [
          ImageWithPlaceHolderWidget(
            width: 45.w,
            height: 45.w,
            fit: BoxFit.fill,
            imageUrl: user.avatar?.url ?? "",
            radius: 10.r,
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Column(
              children: [
                Text.rich(
                  TextSpan(
                    text: user.name,
                    children: createTagPet(),
                    style: UITextStyle.text_header_16_w600,
                  ),
                  maxLines: 2,
                ),
                Text(
                  time_ago.format(postCreatedAt, locale: 'vi'),
                  style: UITextStyle.text_secondary_12_w500,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert_sharp,
              size: 24.w,
            ),
            onPressed: () => null,
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  List<InlineSpan> createTagPet() {
    if (pets.isEmpty) return [];
    final List<InlineSpan> inLineSpan = [];
    inLineSpan.add(
      TextSpan(
        text: " ${LocaleKeys.new_feed_with.trans()} ",
        style: UITextStyle.text_header_16_w400,
      ),
    );
    for (var i = 0; i < pets.length; i++) {
      inLineSpan.add(
        TextSpan(
          text: "${pets[i].name}${i != pets.length - 1 ? ", " : " "}",
          style: UITextStyle.text_header_16_w600,
          recognizer: TapGestureRecognizer()..onTap = () => openProfilePet(pets[i]),
        ),
      );
    }
    return inLineSpan;
  }

  ImageProvider defineAvatar() {
    if (user.avatar == null) {
      return Assets.resources.icons.icPerson;
    } else {
      return NetworkImage(
        user.avatar?.url ?? "",
      );
    }
  }

  void openProfilePet(Pet pet) {
    Get.to(() => PetProfile(pet: pet));
  }
}
