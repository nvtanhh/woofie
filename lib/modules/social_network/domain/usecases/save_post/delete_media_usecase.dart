import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/save_post_repository.dart';

@lazySingleton
class DeleteMediaUsecase {
  final SavePostRepository _savePostRepository;

  DeleteMediaUsecase(this._savePostRepository);

  Future<bool> call(List<int> mediaIds) async {
    return _savePostRepository.deleteMedia(mediaIds);
  }
}
