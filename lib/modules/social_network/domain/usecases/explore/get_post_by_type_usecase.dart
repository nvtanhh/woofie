import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/explore_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

@lazySingleton
class GetPostByTypeUsecase {
  final ExploreRepository _exploreRepository;

  GetPostByTypeUsecase(this._exploreRepository);

  Future<List<Post>> call({required PostType postType, int distance = 5, int limit = 10, int offset = 0}) {
    return _exploreRepository.getPostsByType(postType, distance, limit, offset);
  }
}
