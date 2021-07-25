import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/newfeed_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

@lazySingleton
class ReportPostUsecase {
  final NewFeedRepository _newFeedRepository;

  ReportPostUsecase(this._newFeedRepository);

  Future run(Post post, String content) {
    return _newFeedRepository.reportPost(post, content);
  }
}
