import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/newfeed_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';

@lazySingleton
class ReportCommentUsecase {
  final NewFeedRepository _newFeedRepository;

  ReportCommentUsecase(this._newFeedRepository);
  Future run(Comment comment, String content) {
    return _newFeedRepository.reportComment(comment, content);
  }
}
