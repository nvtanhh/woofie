import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/newfeed_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class GetAllUserInPostUsecase {
  final NewFeedRepository _newFeedRepository;

  GetAllUserInPostUsecase(this._newFeedRepository);

  Future<List<User>> run(int postId, {int limit = 10, int offset = 0}) {
    return _newFeedRepository.getAllUserInPost(postId, limit, offset);
  }
}
