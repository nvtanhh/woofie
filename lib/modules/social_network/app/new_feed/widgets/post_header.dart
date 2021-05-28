import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/services/bottom_sheet.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/theme/icon.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:timeago/timeago.dart' as time_ago;

import './post/post_actions_popup.dart';

class PostHeader extends StatelessWidget {
  final Post post;
  final ValueChanged<Post> onPostDeleted;
  final ValueChanged<Post> onPostEdited;

  const PostHeader({
    Key? key,
    required this.post,
    required this.onPostDeleted,
    required this.onPostEdited,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = post.creator!;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: MWAvatar(
        avatarUrl: user.avatarUrl,
        borderRadius: 10.r,
      ),
      title: Text.rich(
        TextSpan(
          text: user.name,
          children: createTagPet(),
          style: UITextStyle.heading_16_semiBold,
        ),
        maxLines: 2,
      ),
      subtitle: Text(
        time_ago.format(post.createdAt!, locale: 'vi'),
        style: UITextStyle.second_12_medium,
      ),
      trailing: PostActionsTrailing(
        post: post,
        onPostDeleted: onPostDeleted,
        onPostEdited: onPostEdited,
      ),
    );
  }

  List<InlineSpan> createTagPet() {
    final List<Pet> pets = post.pets!;
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
        ),
      );
    }
    return inLineSpan;
  }
}
