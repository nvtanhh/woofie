import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/newfeed_repository.dart';

@lazySingleton
class LikeCommentUsecase {
  final NewFeedRepository _newFeedRepository;

  LikeCommentUsecase(this._newFeedRepository);

  Future<bool> call(int idComment) {
    return _newFeedRepository.likeComment(idComment);
  }
}
