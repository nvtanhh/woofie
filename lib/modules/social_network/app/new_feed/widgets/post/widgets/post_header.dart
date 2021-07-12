import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/widgets/post_locatior.dart';
import 'package:meowoof/modules/social_network/app/profile/pet_profile/pet_profile.dart';
import 'package:meowoof/modules/social_network/app/profile/user_profile/user_profile.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:timeago/timeago.dart' as time_ago;

import './post_actions_popup.dart';

class PostHeader extends StatelessWidget {
  final Post post;
  final VoidCallback onDeletePost;
  final VoidCallback onEditPost;
  final VoidCallback? onReportPost;

  const PostHeader({
    Key? key,
    required this.post,
    required this.onDeletePost,
    required this.onEditPost,
    this.onReportPost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = post.creator!;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: MWAvatar(
        avatarUrl: user.avatarUrl,
        borderRadius: 10.r,
      ),
      title: Text.rich(
        TextSpan(
            text: user.name,
            children: createTagPet(),
            style: UITextStyle.heading_16_semiBold,
            recognizer: TapGestureRecognizer()..onTap = () => openProfileUser(user)),
        maxLines: 2,
      ),
      subtitle: Row(
        children: [
          Text(
            time_ago.format(post.createdAt!, locale: 'vi'),
            style: UITextStyle.second_12_medium,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: PostLocator(
                location: post.location,
                iconSize: 16,
              ),
            ),
          ),
        ],
      ),
      trailing: PostActionsTrailing(
        post: post,
        onDeletePost: onDeletePost,
        onEditPost: onEditPost,
        onReportPost: onReportPost ?? () {},
      ),
    );
  }

  List<InlineSpan> createTagPet() {
    final List<Pet> pets = post.taggegPets!;
    if (pets.isEmpty) return [];
    final List<InlineSpan> inLineSpan = [];
    inLineSpan.add(
      TextSpan(text: " ${LocaleKeys.new_feed_with.trans()} ", style: UITextStyle.heading_16_reg),
    );
    for (var i = 0; i < pets.length; i++) {
      inLineSpan.add(
        TextSpan(
          text: "${pets[i].name}${i != pets.length - 1 ? ", " : " "}",
          style: UITextStyle.heading_16_semiBold,
          recognizer: TapGestureRecognizer()..onTap = () => openProfilePet(pets[i]),
        ),
      );
    }
    return inLineSpan;
  }

  void openProfilePet(Pet pet) {
    Get.to(() => PetProfile(pet: pet));
  }

  void openProfileUser(User user) {
    Get.to(() => UserProfile(
          user: user,
        ));
  }
}
