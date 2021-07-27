import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/chat/data/datasources/chat_datasource.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:meowoof/modules/social_network/data/datasources/storage_datasource.dart';

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

  Future<List<Message>> getMessages(int limit, int skip) {
    return _datasource.getMessages(limit, skip);
  }

  Future<Message> sendMessages({
    required String roomId,
    required String content,
    required MessageType type,
    String? description,
  }) {
    return _datasource.sendMessages(roomId: roomId, content: content, type: type, description: description);
  }
}
