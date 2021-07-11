import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/save_post_repository.dart';

@lazySingleton
class GetPresignedAvatarUrlUsecase {
  final SavePostRepository _savePostRepository;

  GetPresignedAvatarUrlUsecase(this._savePostRepository);

  Future<String?> run(String fileName) async {
    return _savePostRepository.getPresignedAvatarUserUrl(fileName);
  }
}
