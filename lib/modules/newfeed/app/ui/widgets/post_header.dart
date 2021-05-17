import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/services/bottom_sheet.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/add_pet/domain/models/pet.dart';
import 'package:meowoof/modules/auth/domain/models/user.dart';
import 'package:meowoof/modules/newfeed/domain/models/post.dart';
import 'package:meowoof/theme/icon.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:timeago/timeago.dart' as time_ago;

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
          style: GoogleFonts.montserrat(textStyle: UITextStyle.text_header_16_w600),
        ),
        maxLines: 2,
      ),
      subtitle: Text(
        time_ago.format(post.createdAt!, locale: 'vi'),
        style: GoogleFonts.montserrat(textStyle: UITextStyle.text_secondary_12_w500),
      ),
      trailing: IconButton(
        icon: const MWIcon(
          MWIcons.moreVerical,
          themeColor: MWIconThemeColor.secondaryText,
        ),
        constraints: const BoxConstraints(),
        alignment: Alignment.topRight,
        padding: EdgeInsets.zero,
        onPressed: () => _showPostActions(context),
      ),
    );
  }

  List<InlineSpan> createTagPet() {
    final List<Pet> pets = post.pets!;
    if (pets.isEmpty) return [];
    final List<InlineSpan> inLineSpan = [];
    inLineSpan.add(
      TextSpan(
        text: " ${LocaleKeys.new_feed_with.trans()} ",
        style: GoogleFonts.montserrat(textStyle: UITextStyle.text_header_16_w400),
      ),
    );
    for (var i = 0; i < pets.length; i++) {
      inLineSpan.add(
        TextSpan(
          text: "${pets[i].name}${i != pets.length - 1 ? ", " : " "}",
          style: GoogleFonts.montserrat(textStyle: UITextStyle.text_header_16_w600),
        ),
      );
    }
    return inLineSpan;
  }

  ImageProvider defineAvatar() {
    if (post.creator!.avatar == null) {
      return Assets.resources.icons.icPerson;
    } else {
      return NetworkImage(
        post.creator!.avatar?.url ?? "",
      );
    }
  }

  void _showPostActions(BuildContext context) {
    injector<BottomSheetService>().showPostActions(
      post: post,
      onPostDeleted: onPostDeleted,
      onPostEdited: onPostEdited,
    );
  }
}
