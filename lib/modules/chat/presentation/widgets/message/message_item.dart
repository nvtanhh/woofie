import 'package:flutter/material.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:meowoof/modules/chat/presentation/widgets/active_status_avatar.dart';
import 'package:meowoof/modules/chat/presentation/widgets/message/message_body.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final User? chatPartner;
  final bool isDisplayAvatar;

  const MessageWidget(this.message, {this.chatPartner, Key? key, this.isDisplayAvatar = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 0.15.sw, bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isDisplayAvatar)
            ActiveStatusAvatar(
              avatarUrl: chatPartner?.avatarUrl ?? '',
              isSmallSize: true,
              borderRadius: 8,
              isActive: true,
            )
          else
            const SizedBox(
              width: MWAvatar.AVATAR_SIZE_SMALL + 3,
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: MessageBody(message),
            ),
          ),
        ],
      ),
    );
  }
}
