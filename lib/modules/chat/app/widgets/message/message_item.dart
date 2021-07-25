import 'package:flutter/material.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:meowoof/modules/chat/app/widgets/active_status_avatar.dart';
import 'package:meowoof/modules/chat/app/widgets/message/message_body.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final User? chatPartner;
  final bool isDisplayAvatar;

  const MessageWidget(this.message, {this.chatPartner, Key? key, this.isDisplayAvatar = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMyMessage = message.isMyMessage;
    return Padding(
      padding: EdgeInsets.only(
        right: !isMyMessage ? 0.15.sw : 0,
        left: isMyMessage ? 0.15.sw : 0,
        bottom: 5,
      ),
      child: Row(
        crossAxisAlignment: isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMyMessage) _buildMessageIdentifierAvatar(isMyMessage),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: MessageBody(message, isMyMessage: isMyMessage),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageIdentifierAvatar(bool isMyMessage) {
    final avatarUrl = (!isMyMessage ? chatPartner?.avatarUrl : injector<LoggedInUser>().user?.avatarUrl) ?? '';
    return Padding(
      padding: EdgeInsets.only(
        right: !isMyMessage ? 10 : 0,
        left: isMyMessage ? 10 : 0,
      ),
      child: isDisplayAvatar
          ? ActiveStatusAvatar(
              avatarUrl: avatarUrl,
              isSmallSize: true,
              borderRadius: 8,
              isActive: true,
            )
          : const SizedBox(
              width: MWAvatar.AVATAR_SIZE_SMALL + 3,
            ),
    );
  }
}
