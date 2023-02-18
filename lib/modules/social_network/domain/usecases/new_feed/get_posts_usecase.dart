import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/newfeed_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

@lazySingleton
class GetPostsUsecase {
  final NewFeedRepository _newFeedRepository;

  GetPostsUsecase(this._newFeedRepository);

  Future<List<Post>> call(
      {int limit = 10, int offset = 0, DateTime? lastValue,}) {
    return _newFeedRepository.getPosts(
        limit: limit, offset: offset, lastValue: lastValue,);
  }
}
