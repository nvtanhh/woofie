import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/newfeed_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';

@lazySingleton
class EditCommentUsecase {
  final NewFeedRepository _newFeedRepository;

  EditCommentUsecase(this._newFeedRepository);
  Future<Comment> run(Comment oldComment, Comment newComment) {
    return _newFeedRepository.editComment(oldComment, newComment);
  }
}
