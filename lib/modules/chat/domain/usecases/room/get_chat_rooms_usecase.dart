import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/chat/data/repositories/chat_repository.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';

@lazySingleton
class GetChatRoomsUseCase {
  final ChatRepository _chatRoomRepository;

  GetChatRoomsUseCase(this._chatRoomRepository);

  Future<List<ChatRoom>> call() {
    return _chatRoomRepository.getChatRooms();
  }
}
