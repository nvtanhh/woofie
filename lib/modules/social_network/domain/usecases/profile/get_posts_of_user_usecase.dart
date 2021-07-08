import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

@lazySingleton
class GetPostOfUserUsecase {
  final ProfileRepository _profileRepository;

  GetPostOfUserUsecase(this._profileRepository);

  Future<List<Post>> call({int offset = 0, int limit = 10, String? userUUID}) async {
    return _profileRepository.getPostsTimeline(
      offset,
      limit,
      userUUID: userUUID,
    );
  }
}
