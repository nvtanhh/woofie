import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/newfeed/data/repositories/newfeed_repository.dart';
import 'package:meowoof/modules/newfeed/domain/models/post.dart';

@lazySingleton
class GetPostsUsecase {
  final NewFeedRepository _newFeedRepository;

  GetPostsUsecase(this._newFeedRepository);

  Future<List<Post>> call() {
    return _newFeedRepository.getPosts();
  }
}
