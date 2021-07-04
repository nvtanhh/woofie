import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/save_post_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

@lazySingleton
class PublishUsecase {
  final SavePostRepository _savePostRepository;
  PublishUsecase(this._savePostRepository);

  Future<Post?> call(int postId) async {
    return _savePostRepository.publishPost(postId);
  }
}
