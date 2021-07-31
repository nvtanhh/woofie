import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/chat/data/repositories/chat_repository.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class InitChatRoomsUseCase {
  final ChatRepository _chatRoomRepository;

  InitChatRoomsUseCase(this._chatRoomRepository);

  Future<ChatRoom> call(User user) {
    return _chatRoomRepository.initPrivateChatRoom(user);
  }
}
