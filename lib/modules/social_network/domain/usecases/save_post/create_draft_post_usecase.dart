import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/save_post_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/post/new_post_data.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

@lazySingleton
class CreateDraftPostUsecase {
  final SavePostRepository _savePostRepository;

  CreateDraftPostUsecase(this._savePostRepository);

  Future<Post?> call(NewPostData postData) async {
    return _savePostRepository.createDraftPost(postData);
  }
}
