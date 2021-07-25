import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/chat/data/datasources/chat_datasource.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';

@lazySingleton
class ChatRoomRepository {
  final ChatDatasource _datasource;

  ChatRoomRepository(this._datasource);

  Future<List<ChatRoom>> getChatRooms() {
    return _datasource.getChatRooms();
  }
}
