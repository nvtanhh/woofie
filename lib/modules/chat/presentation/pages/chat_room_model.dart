import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class ChatRoomPageModel extends BaseViewModel {
  late ChatRoom room;
  late List<Message> messages;
  ScrollController scrollController = ScrollController();
  final TextEditingController messageSenderTextController = TextEditingController();

  bool checkIsDisplayAvatar(int index) {
    return index == messages.length - 1 || messages[index].senderId != messages[index + 1].senderId;
  }
}
