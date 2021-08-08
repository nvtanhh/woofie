import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';

@lazySingleton
class DeletePetWeightUsecase {
  final ProfileRepository _profileRepository;

  DeletePetWeightUsecase(this._profileRepository);

  Future<bool> run(int petWeightId) {
    return _profileRepository.deletePetWeight(petWeightId);
  }
}
