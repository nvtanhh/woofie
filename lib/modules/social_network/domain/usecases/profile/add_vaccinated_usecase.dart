import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_vaccinated.dart';

@lazySingleton
class AddVaccinatedUsecase {
  final ProfileRepository _profileRepository;

  AddVaccinatedUsecase(this._profileRepository);

  Future<PetVaccinated> call(PetVaccinated petVaccinated) {
    return _profileRepository.addVaccinated(petVaccinated);
  }
}
