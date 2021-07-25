import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/chat/data/repositories/chat_repository.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';

@lazySingleton
class GetMessagesUseCase {
  final ChatRepository _chatRepository;

  GetMessagesUseCase(this._chatRepository);

  Future<List<Message>> call({int limit = 10, int skip = 0}) {
    return _chatRepository.getMessages(limit, skip);
  }
}
