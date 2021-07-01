import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/newfeed_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

@lazySingleton
class CreatePostUsecase {
  final NewFeedRepository _newFeedRepository;

  CreatePostUsecase(this._newFeedRepository);

  Future<Post> call(Post post) {
    return _newFeedRepository.createPost(post);
  }
}
