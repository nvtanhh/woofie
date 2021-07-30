import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/chat/data/datasources/chat_datasource.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:meowoof/modules/social_network/data/datasources/storage_datasource.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class ChatRepository {
  final ChatDatasource _datasource;
  final StorageDatasource _storageDatasource;

  ChatRepository(this._datasource, this._storageDatasource);

  Future<List<ChatRoom>> getChatRooms(int limit, int skip) {
    return _datasource.getChatRooms(limit, skip);
  }

  Future<String> getPresignedChatMediaUrl(String fileName, String chatRoomId) {
    return _storageDatasource.getPresignedChatMediaUrl(fileName, chatRoomId);
  }

  Future<List<Message>> getMessagesWithRoomId(int limit, int skip, String roomId) {
    return _datasource.getMessagesWithRoomId(limit, skip, roomId);
  }

  Future<Message> sendMessages({
    required String roomId,
    required String content,
    required MessageType type,
    String? description,
  }) {
    return _datasource.sendMessages(roomId: roomId, content: content, type: type, description: description);
  }

  Future<ChatRoom> initPrivateChatRoom(User user) {
    return _datasource.initPrivateChatRoom(user);
  }
}
