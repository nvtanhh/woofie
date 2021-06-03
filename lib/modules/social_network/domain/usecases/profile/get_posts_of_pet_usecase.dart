import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

@lazySingleton
class GetPostsOfPetUsecase {
  final ProfileRepository _profileRepository;

  GetPostsOfPetUsecase(this._profileRepository);
  Future<List<Post>> call(int petId, {int offset = 0, int limit = 10}) async {
    return _profileRepository.getPostsOfPet(petId, offset, limit);
  }
}
