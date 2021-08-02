import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/chat/data/repositories/chat_repository.dart';
import 'package:meowoof/modules/chat/domain/models/request_contact.dart';

@lazySingleton
class AcceptRequestMessagesUsecase {
  final ChatRepository _chatRepository;

  AcceptRequestMessagesUsecase(this._chatRepository);
  Future<RequestContact> run(RequestContact requestContact) {
    return _chatRepository.acceptRequestMessages(requestContact);
  }
}
