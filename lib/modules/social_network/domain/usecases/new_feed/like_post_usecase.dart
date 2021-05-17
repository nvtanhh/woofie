import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/newfeed_repository.dart';

@lazySingleton
class LikePostUsecase {
  final NewFeedRepository _newFeedRepository;

  LikePostUsecase(this._newFeedRepository);

  Future<bool> call(int idPost) {
    return _newFeedRepository.likePost(idPost);
  }
}
