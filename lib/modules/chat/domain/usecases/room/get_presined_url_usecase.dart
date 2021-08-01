import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/chat/data/repositories/chat_repository.dart';

@lazySingleton
class GetPresignedUrlForChatUsecase {
  final ChatRepository _chatRoomRepository;

  GetPresignedUrlForChatUsecase(this._chatRoomRepository);

  Future<String> call(String fileName, String chatRoomId) async {
    return _chatRoomRepository.getPresignedChatMediaUrl(fileName, chatRoomId);
  }
}
