import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_worm_flushed.dart';

@lazySingleton
class UpdatePetWormFlushUsecase {
  final ProfileRepository _profileRepository;

  UpdatePetWormFlushUsecase(this._profileRepository);

  Future<PetWormFlushed> run(PetWormFlushed petWormFlushed) {
    return _profileRepository.updatePetWormFlush(petWormFlushed);
  }
}
