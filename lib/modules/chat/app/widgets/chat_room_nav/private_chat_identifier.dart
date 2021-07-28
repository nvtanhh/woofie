import 'package:flutter/material.dart';
import 'package:meowoof/modules/chat/app/widgets/active_status_avatar.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class PrivateChatIdentifier extends StatelessWidget {
  final User? chatUser;

  const PrivateChatIdentifier({Key? key, required this.chatUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: ActiveStatusAvatar(
        avatarUrl: chatUser?.avatarUrl ?? '',
        isActive: false,
      ),
      title: Text(
        chatUser?.name ?? '',
        style: UITextStyle.heading_16_semiBold,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: Text(chatUser?.bio ?? ''),
    );
  }
}
