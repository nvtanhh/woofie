import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/chat/data/repositories/chat_repository.dart';
import 'package:meowoof/modules/chat/domain/models/request_contact.dart';

@lazySingleton
class DenyRequestMessagesUsecase {
  final ChatRepository _chatRepository;

  DenyRequestMessagesUsecase(this._chatRepository);
  Future<RequestContact> run(RequestContact requestContact) {
    return _chatRepository.denyRequestMessages(requestContact);
  }
}
