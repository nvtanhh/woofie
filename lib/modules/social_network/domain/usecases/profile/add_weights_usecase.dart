import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_weight.dart';

@lazySingleton
class AddWeightUsecase {
  final ProfileRepository _profileRepository;

  AddWeightUsecase(this._profileRepository);

  Future<PetWeight> call(PetWeight petWeight) {
    return _profileRepository.addWeight(petWeight);
  }
}
