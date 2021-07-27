import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/chat/data/repositories/chat_repository.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';

@lazySingleton
class SendMessagesUsecase {
  final ChatRepository _chatRoomRepository;

  SendMessagesUsecase(this._chatRoomRepository);

  Future<Message> call({
    required String roomId,
    required String content,
    required MessageType type,
    String? description,
  }) {
    return _chatRoomRepository.sendMessages(roomId: roomId, content: content, type: type, description: description);
  }
}
