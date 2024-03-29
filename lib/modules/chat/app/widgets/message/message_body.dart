import 'package:flutter/material.dart';
import 'package:meowoof/modules/chat/app/widgets/message/message_body_media.dart';
import 'package:meowoof/modules/chat/app/widgets/message/message_body_post_previewer.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class MessageBody extends StatelessWidget {
  final Message message;
  final bool isMyMessage;

  final User? partner;

  const MessageBody(this.message,
      {super.key, required this.isMyMessage, this.partner,});

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (message.type == MessageType.text) {
      body = Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        child: Text(
          message.content,
          style: isMyMessage
              ? UITextStyle.body_14_medium.apply(color: Colors.white)
              : UITextStyle.body_14_medium,
        ),
      );
    } else if (message.type == MessageType.image ||
        message.type == MessageType.video) {
      body = MessageBodyMedia(
        message,
        partner: partner,
      );
    } else if (message.type == MessageType.post) {
      body = MessageBodyPostPreviewer(message);
    } else {
      body = Text(message.content);
    }

    return body;

    // return Column(
    //   crossAxisAlignment:
    //       !isMyMessage ? CrossAxisAlignment.start : CrossAxisAlignment.end,
    //   children: [body],
    // );
  }
}
