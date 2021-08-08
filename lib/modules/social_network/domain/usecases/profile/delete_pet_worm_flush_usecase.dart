import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';

@lazySingleton
class DeletePetWormFlushUsecase {
  final ProfileRepository _profileRepository;

  DeletePetWormFlushUsecase(this._profileRepository);

  Future<bool> run(int petWormFlushId) {
    return _profileRepository.deletePetWormFlush(petWormFlushId);
  }
}
