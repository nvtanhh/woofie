import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_vaccinated.dart';

@lazySingleton
class GetVaccinatesUsecase {
  final ProfileRepository _profileRepository;

  GetVaccinatesUsecase(this._profileRepository);

  Future<List<PetVaccinated>> call(int idPet,
      {int limit = 10, int offset = 0}) {
    return _profileRepository.getVaccinates(idPet, limit, offset);
  }
}
