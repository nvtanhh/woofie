import 'package:flutter/material.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/modules/chat/app/widgets/message/message_body_media.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class MessageBody extends StatelessWidget {
  final Message message;
  final bool isMyMessage;

  const MessageBody(this.message, {Key? key, required this.isMyMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (message.type == MessageType.text) {
      body = Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isMyMessage ? UIColor.primary : UIColor.holder,
          borderRadius: BorderRadius.circular(10),
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
      body = ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: MessageBodyMedia(message),
      );
    } else {
      body = Text(message.content);
    }

    return Column(
      crossAxisAlignment:
          !isMyMessage ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [body],
    );
  }
}
