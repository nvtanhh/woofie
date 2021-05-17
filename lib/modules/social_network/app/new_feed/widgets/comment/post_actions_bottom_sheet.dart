import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/icon.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/core/extensions/string_ext.dart';

class PostActionsBottomSheet extends StatelessWidget {
  final Post post;
  final ValueChanged<Post> onPostDeleted;
  final ValueChanged<Post> onPostEdited;
  const PostActionsBottomSheet({Key? key, required this.post, required this.onPostDeleted, required this.onPostEdited}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const MWIcon(MWIcons.edit),
            title: Text(
              LocaleKeys.new_feed_edit_post.trans(),
              style: GoogleFonts.montserrat(textStyle: UITextStyle.text_body_16_w500),
            ),
          ),
          ListTile(
            leading: const MWIcon(MWIcons.delete),
            title: Text(
              LocaleKeys.new_feed_delete_post.trans(),
              style: GoogleFonts.montserrat(textStyle: UITextStyle.text_body_16_w500),
            ),
          )
        ],
      ),
    );
  }
}
