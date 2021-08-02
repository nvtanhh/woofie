import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/chat/data/repositories/chat_repository.dart';
import 'package:meowoof/modules/chat/domain/models/request_contact.dart';

@lazySingleton
class UpdateContentRequestMessagesUsecase {
  final ChatRepository _chatRepository;

  UpdateContentRequestMessagesUsecase(this._chatRepository);
  Future run({required RequestContact requestContact, required String content}) {
    return _chatRepository.updateContentRequestMessages(requestContact, content);
  }
}
