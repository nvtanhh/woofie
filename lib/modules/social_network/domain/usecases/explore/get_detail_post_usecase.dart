import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/explore_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

@lazySingleton
class GetDetailPostUsecase {
  final ExploreRepository _exploreRepository;

  GetDetailPostUsecase(this._exploreRepository);

  Future<Post> call(int postId) {
    return _exploreRepository.getDetailPost(postId);
  }
}
