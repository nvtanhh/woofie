import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/modules/chat/app/widgets/chat_room_nav/chat_identifier.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatRoomNav extends StatelessWidget {
  final ChatRoom room;

  const ChatRoomNav(this.room, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const MWIcon(
          MWIcons.back,
          color: UIColor.black,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      title: Transform.translate(
        offset: Offset(-16.w, 0),
        child: ChatIndentifierWidget(chatRoom: room),
      ),
      actions: <Widget>[
        IconButton(
          icon: const MWIcon(
            MWIcons.info,
          ),
          onPressed: () {},
        )
      ],
    );
  }
}
