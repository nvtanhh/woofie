import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/newfeed_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

@lazySingleton
class RefreshPostsUsecase {
  final NewFeedRepository _newFeedRepository;

  RefreshPostsUsecase(this._newFeedRepository);

  Future<Post> call(int postId) {
    return _newFeedRepository.refreshPost(postId);
  }
}
