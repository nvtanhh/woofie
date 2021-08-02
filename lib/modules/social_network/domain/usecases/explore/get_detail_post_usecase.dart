import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/explore_repository.dart';

@lazySingleton
class GetDetailPostUsecase {
  final ExploreRepository _exploreRepository;

  GetDetailPostUsecase(this._exploreRepository);

  Future<Map<String, dynamic>> call(int postId) {
    return _exploreRepository.getDetailPost(postId);
  }
}
