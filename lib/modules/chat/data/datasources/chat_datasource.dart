import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';

@lazySingleton
class ChatDatasource {
  Future<List<ChatRoom>> getChatRooms() async {
    const String rawJson =
        '{"rooms":[{"members":["MOxLhXDRguSO5KviPlawgQNy3Js1","XOkLTmnJZues17rA1tqNfOZmYHJ2"],"isGroup":false,"name":"XOkLTmnJZues17rA1tqNfOZmYHJ2_MOxLhXDRguSO5KviPlawgQNy3Js1","creator":"XOkLTmnJZues17rA1tqNfOZmYHJ2","createdAt":"2021-07-21T09:58:48.263Z","updatedAt":"2021-07-21T09:58:48.263Z","id":"60f7efd891b2721decc36521","messages":[{"type":"I","content":"https://cdn.pixabay.com/photo/2021/07/19/20/11/kitten-6479019_960_720.jpg","sender":"XOkLTmnJZues17rA1tqNfOZmYHJ2","createdAt":"2021-07-21T12:10:00.030Z","id":"60f80e989a2e9921c8333fdb"},{"type":"T","content":"New message 3","sender":"XOkLTmnJZues17rA1tqNfOZmYHJ2","createdAt":"2021-07-21T11:32:37.778Z","id":"60f805d5b113352f541cdbc7"},{"type":"T","content":"New message 2","sender":"XOkLTmnJZues17rA1tqNfOZmYHJ2","createdAt":"2021-07-21T11:32:34.424Z","id":"60f805d2b113352f541cdbc3"},{"type":"T","content":"New message 1","sender":"XOkLTmnJZues17rA1tqNfOZmYHJ2","createdAt":"2021-07-21T11:32:31.273Z","id":"60f805cfb113352f541cdbbf"}]}]}';
    final list = json.decode(rawJson)['rooms'] as List;
    return list
        .map((room) => ChatRoom.fromJson(room as Map<String, dynamic>))
        .toList();
  }

  Future<List<Message>> getMessages(int limit, int skip) async {
    return [];
  }
}
