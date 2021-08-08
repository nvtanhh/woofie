import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/explore_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post_reaction.dart';

@lazySingleton
class GetFunctionalPostReactions {
  final ExploreRepository _exploreRepository;

  GetFunctionalPostReactions(this._exploreRepository);

  Future<List<PostReaction>> call({required int postId}) {
    return _exploreRepository.getPostFunctionalPostReact(postId);
  }
}
