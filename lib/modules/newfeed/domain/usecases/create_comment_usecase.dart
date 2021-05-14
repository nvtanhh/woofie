import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/newfeed/data/repositories/newfeed_repository.dart';

@lazySingleton
class CreateCommentUsecase {
  final NewFeedRepository _newFeedRepository;

  CreateCommentUsecase(this._newFeedRepository);

  // Future<Comment?> createComment(int postId, String content) {
  // }
}
