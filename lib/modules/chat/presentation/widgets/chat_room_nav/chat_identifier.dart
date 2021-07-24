import 'package:flutter/material.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';
import 'package:meowoof/modules/chat/presentation/widgets/chat_room_nav/group_chat_identifier.dart';
import 'package:meowoof/modules/chat/presentation/widgets/chat_room_nav/private_chat_identifier.dart';

class ChatIndentifierWidget extends StatelessWidget {
  final ChatRoom chatRoom;

  const ChatIndentifierWidget({Key? key, required this.chatRoom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !chatRoom.isGroup
        ? PrivateChatIdentifier(chatUser: chatRoom.privateChatPartner)
        : const GroupChatIndentifier();
  }
}
