import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/explore_repository.dart';

@lazySingleton
class SaveFunctionalPostReact {
  final ExploreRepository _exploreRepository;

  SaveFunctionalPostReact(this._exploreRepository);

  Future<bool> call({required int postId, int? matingPetId }) {
    return _exploreRepository.reactFunctionalPost(postId, matingPetId);
  }
}
