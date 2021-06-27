import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/newfeed_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class CreateCommentUsecase {
  final NewFeedRepository _newFeedRepository;

  CreateCommentUsecase(this._newFeedRepository);

  Future<Comment?> call(int postId, String content,List<User> userTag) {
    return _newFeedRepository.createComment(postId, content,userTag);
  }
}
