import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/save_post_repository.dart';

@lazySingleton
class GetPresignedAvatarPetUrlUsecase {
  final SavePostRepository _savePostRepository;

  GetPresignedAvatarPetUrlUsecase(this._savePostRepository);

  Future<String?> run(String fileName, String petUUID) async {
    return _savePostRepository.getPresignedAvatarPetUrl(fileName, petUUID);
  }
}
