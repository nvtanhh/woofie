import 'package:flutter/material.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class MessageBody extends StatelessWidget {
  final Message message;
  const MessageBody(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (message.type) {
      case MessageType.text:
        body = Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: UIColor.holder,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            message.content,
            style: UITextStyle.body_14_medium,
          ),
        );
        break;
      case MessageType.image:
        body = ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: ImageWithPlaceHolderWidget(
            imageUrl: message.content,
          ),
        );
        break;
      default:
        body = Text(message.content);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        body,
      ],
    );
  }
}
