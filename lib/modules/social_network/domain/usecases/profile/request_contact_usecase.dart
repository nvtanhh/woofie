import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/chat/domain/models/request_contact.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';

@lazySingleton
class RequestContactUsecase {
  final ProfileRepository _profileRepository;

  RequestContactUsecase(this._profileRepository);

  Future<RequestContact> run({
    required String toUserUUID,
  }) {
    return _profileRepository.requestContact(toUserUUID);
  }
}
