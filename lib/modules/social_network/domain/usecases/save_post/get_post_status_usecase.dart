import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/save_post_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

@lazySingleton
class GetPostStatusUsecase {
  final SavePostRepository _savePostRepository;

  GetPostStatusUsecase(this._savePostRepository);

  Future<PostStatus?> call(int postId) async {
    return _savePostRepository.getPostStatus(postId);
  }
}
