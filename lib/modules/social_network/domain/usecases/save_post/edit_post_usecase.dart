import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/save_post_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/post/updated_post_data.dart';

@lazySingleton
class EditPostUsecase {
  final SavePostRepository _savePostRepository;

  EditPostUsecase(this._savePostRepository);

  Future<bool> call(EditedPostData editedPostData) async {
    return _savePostRepository.editPost(editedPostData);
  }
}
