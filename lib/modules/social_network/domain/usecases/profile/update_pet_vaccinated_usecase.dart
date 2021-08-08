import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_vaccinated.dart';

@lazySingleton
class UpdatePetVaccinatedUsecase {
  final ProfileRepository _profileRepository;

  UpdatePetVaccinatedUsecase(this._profileRepository);

  Future<PetVaccinated> run(PetVaccinated petVaccinated) {
    return _profileRepository.updatePetVaccinated(petVaccinated);
  }
}
