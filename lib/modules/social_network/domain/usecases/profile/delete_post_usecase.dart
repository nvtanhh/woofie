import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';

@lazySingleton
class DeletePostUsecase {
  final ProfileRepository _profileRepository;

  DeletePostUsecase(this._profileRepository);

  Future<bool> call(int postId) {
    return _profileRepository.deletePost(postId);
  }
}
