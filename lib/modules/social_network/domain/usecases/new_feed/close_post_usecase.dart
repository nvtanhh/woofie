import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/newfeed_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

@lazySingleton
class ClosePostUsecase {
  final NewFeedRepository _newFeedRepository;

  ClosePostUsecase(this._newFeedRepository);

  Future run(Post post, {String? additionalData}) {
    return _newFeedRepository.closePost(post, additionalData: additionalData);
  }
}
