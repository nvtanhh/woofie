import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/newfeed_repository.dart';

@lazySingleton
class LikeCommentUsecase {
  final NewFeedRepository _newFeedRepository;

  LikeCommentUsecase(this._newFeedRepository);

  Future<bool> run({required int idComment, required int idPost}) {
    return _newFeedRepository.likeComment(idComment, idPost);
  }
}
