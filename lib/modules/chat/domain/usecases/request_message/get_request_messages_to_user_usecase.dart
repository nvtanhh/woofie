import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/chat/data/repositories/chat_repository.dart';
import 'package:meowoof/modules/chat/domain/models/request_contact.dart';

@lazySingleton
class GetRequestMessagesFromUserUsecase{
  final ChatRepository _chatRepository;

  GetRequestMessagesFromUserUsecase(this._chatRepository);
  Future<List<RequestContact>> run(){
    return _chatRepository.getRequestMessagesFromUser();
  }
}