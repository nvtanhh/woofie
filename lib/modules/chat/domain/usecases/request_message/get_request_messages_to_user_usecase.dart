import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/chat/data/repositories/chat_repository.dart';
import 'package:meowoof/modules/chat/domain/models/request_contact.dart';

@lazySingleton
class GetRequestMessagesToUserUsecase {
  final ChatRepository _chatRepository;

  GetRequestMessagesToUserUsecase(this._chatRepository);
  Future<List<RequestContact>> run() {
    return _chatRepository.getRequestMessagesToUser();
  }
}
