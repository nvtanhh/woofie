import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/explore_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

@lazySingleton
class GetPostAdoptionUsecase {
  final ExploreRepository _exploreRepository;

  GetPostAdoptionUsecase(this._exploreRepository);

  Future<List<Post>> call() {
    return _exploreRepository.getPostsAdoption();
  }
}
