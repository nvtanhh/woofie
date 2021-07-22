import 'package:flutter/material.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class ChatRoomItem extends StatelessWidget {
  final ChatRoom room;

  const ChatRoomItem({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: MWAvatar(
        avatarUrl: '',
        borderRadius: 10.r,
      ),
      title: Text(
        room.name,
        style: UITextStyle.heading_16_semiBold,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: Text(
        room.lastMessage,
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
                room.lastSeenTime(),
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
}
