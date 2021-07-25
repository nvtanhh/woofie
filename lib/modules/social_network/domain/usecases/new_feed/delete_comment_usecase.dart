import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/newfeed_repository.dart';

@lazySingleton
class DeleteCommentUsecase {
  final NewFeedRepository _newFeedRepository;

  DeleteCommentUsecase(this._newFeedRepository);
  Future run(int commentId) {
    return _newFeedRepository.deleteComment(commentId);
  }
}
