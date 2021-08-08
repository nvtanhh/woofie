import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';

@lazySingleton
class DeletePetVaccinatedUsecase {
  final ProfileRepository _profileRepository;

  DeletePetVaccinatedUsecase(this._profileRepository);

  Future<bool> run(int petVaccinatedId) {
    return _profileRepository.deletePetVaccinated(petVaccinatedId);
  }
}
