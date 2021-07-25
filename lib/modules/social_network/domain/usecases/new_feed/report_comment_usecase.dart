import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/newfeed_repository.dart';

@lazySingleton
class ReportCommentUsecase {
  final NewFeedRepository _newFeedRepository;

  ReportCommentUsecase(this._newFeedRepository);
  Future run(int commentId, String content) {
    return _newFeedRepository.reportComment(commentId, content);
  }
}
