import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/explore_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

@lazySingleton
class HadFoundPetUsecase {
  final ExploreRepository _exploreRepository;

  HadFoundPetUsecase(this._exploreRepository);

  Future<Post> call(Post post) {
    return _exploreRepository.hadFoundPet(post);
  }
}
