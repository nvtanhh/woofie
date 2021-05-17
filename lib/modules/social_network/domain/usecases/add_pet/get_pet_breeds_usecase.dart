import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/add_pet_repositories.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_breed.dart';

@lazySingleton
class GetPetBreedUsecase {
  final AddPetRepository _addPetRepository;

  GetPetBreedUsecase(this._addPetRepository);

  Future<List<PetBreed>> call(int petTypeId) {
    return _addPetRepository.getPetBreeds(petTypeId);
  }
}
