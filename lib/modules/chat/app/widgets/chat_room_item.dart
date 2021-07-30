import 'package:flutter/material.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class ChatRoomItem extends StatelessWidget {
  final ChatRoom room;
  final VoidCallback onChatRoomPressed;

  const ChatRoomItem(
      {Key? key, required this.room, required this.onChatRoomPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onChatRoomPressed,
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: MWAvatar(
        avatarUrl: room.privateChatPartner?.avatarUrl ?? '',
        borderRadius: 10.r,
      ),
      title: Text(
        room.privateChatPartner?.name ?? '',
        style: UITextStyle.heading_16_semiBold,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: Text(
        _getSubTitle(room),
        style: UITextStyle.body_12_reg,
        maxLines: 1,
      ),
      trailing: Column(
        children: [
          Flexible(
            child: Container(
              width: 50.w,
              padding: EdgeInsets.only(top: 5.h),
              child: Text(
                room.lastActiveTime(),
                style: UITextStyle.body_14_medium,
                textAlign: TextAlign.right,
                overflow: TextOverflow.clip,
                softWrap: false,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSubTitle(ChatRoom room) {
    if (room.messages.isEmpty) return '';
    final lastMessage = room.messages.first;
    String subTitle;
    switch (lastMessage.type) {
      case MessageType.text:
        subTitle = lastMessage.content;
        break;
      case MessageType.image:
        subTitle = 'Đã gửi 1 ảnh';
        break;
      case MessageType.video:
        subTitle = 'Đã gửi 1 video';
        break;
      default:
        subTitle = lastMessage.content;
    }

    if (lastMessage.isSentByMe) {
      return 'Bạn • $subTitle';
    } else {
      final String partnerName = room.privateChatPartner?.name ?? '';
      return '$partnerName • $subTitle';
    }
  }
}
