import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/newfeed/data/repositories/newfeed_repository.dart';
import 'package:meowoof/modules/newfeed/domain/models/comment.dart';

@lazySingleton
class GetCommentInPostUsecase {
  final NewFeedRepository _newFeedRepository;

  GetCommentInPostUsecase(this._newFeedRepository);
  Future<List<Comment>> call(int postId) {
    return _newFeedRepository.getCommentInPost(postId);
  }
}
