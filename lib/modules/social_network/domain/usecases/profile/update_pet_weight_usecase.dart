import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_weight.dart';

@lazySingleton
class UpdatePetWeightUsecase {
  final ProfileRepository _profileRepository;

  UpdatePetWeightUsecase(this._profileRepository);

  Future<PetWeight> run(PetWeight petWeight) {
    return _profileRepository.updatePetWeight(petWeight);
  }
}
