import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/save_post_repository.dart';

@lazySingleton
class GetPresignedUrlUsecase {
  final SavePostRepository _savePostRepository;

  GetPresignedUrlUsecase(this._savePostRepository);

  Future<String?> call(String fileName, String postUuid) async {
    return _savePostRepository.getPresignedUrl(fileName, postUuid);
  }
}
