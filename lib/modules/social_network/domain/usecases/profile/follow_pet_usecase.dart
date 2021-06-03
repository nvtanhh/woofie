import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';

@lazySingleton
class FollowPetUsecase {
  final ProfileRepository _profileRepository;

  FollowPetUsecase(this._profileRepository);

  Future call(int petID) {
    return _profileRepository.followPet(petID);
  }
}
