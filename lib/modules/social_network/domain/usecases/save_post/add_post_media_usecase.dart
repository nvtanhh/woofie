import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/save_post_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';

@lazySingleton
class AddPostMediaUsecase {
  final SavePostRepository _savePostRepository;

  AddPostMediaUsecase(this._savePostRepository);

  Future call(List<UploadedMedia> medias, int id) async {
    return _savePostRepository.addMediaToPost(medias, id);
  }
}
