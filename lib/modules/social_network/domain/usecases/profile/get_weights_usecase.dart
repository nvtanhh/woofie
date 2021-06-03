import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_weight.dart';

@lazySingleton
class GetWeightsUsecase {
  final ProfileRepository _profileRepository;

  GetWeightsUsecase(this._profileRepository);

  Future<List<PetWeight>> call(int idPet, {int limit = 10, int offset = 0}) {
    return _profileRepository.getWeights(idPet, limit, offset);
  }
}
