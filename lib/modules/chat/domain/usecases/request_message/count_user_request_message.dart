import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/chat/data/repositories/chat_repository.dart';

@lazySingleton
class CountUserRequestMessagesUsecase {
  final ChatRepository _chatRepository;

  CountUserRequestMessagesUsecase(this._chatRepository);
  Future<int> run() {
    return _chatRepository.countUserRequestMessages();
  }
}
