import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_worm_flushed.dart';

@lazySingleton
class AddWormFlushedUsecase {
  final ProfileRepository _profileRepository;

  AddWormFlushedUsecase(this._profileRepository);

  Future<PetWormFlushed> call(PetWormFlushed petWormFlushed) async {
    return _profileRepository.addWormFlushed(petWormFlushed);
  }
}
