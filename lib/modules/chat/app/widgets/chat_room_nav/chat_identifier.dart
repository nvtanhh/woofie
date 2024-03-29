import 'package:flutter/material.dart';
import 'package:meowoof/modules/chat/app/widgets/chat_room_nav/group_chat_identifier.dart';
import 'package:meowoof/modules/chat/app/widgets/chat_room_nav/private_chat_identifier.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';

class ChatIndentifierWidget extends StatelessWidget {
  final ChatRoom chatRoom;

  const ChatIndentifierWidget({super.key, required this.chatRoom});

  @override
  Widget build(BuildContext context) {
    return !chatRoom.isGroup
        ? PrivateChatIdentifier(chatUser: chatRoom.privateChatPartner)
        : const GroupChatIndentifier();
  }
}
