import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_worm_flushed.dart';

@lazySingleton
class GetWormFlushesUsecase {
  final ProfileRepository _profileRepository;

  GetWormFlushesUsecase(this._profileRepository);

  Future<List<PetWormFlushed>> call(int idPet, {int limit = 10, int offset = 0}) {
    return _profileRepository.getWormFlushes(idPet, limit, offset);
  }
}
