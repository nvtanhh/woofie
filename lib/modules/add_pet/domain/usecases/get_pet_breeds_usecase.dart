import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/add_pet/data/repositories/add_pet_repositories.dart';
import 'package:meowoof/modules/add_pet/domain/models/pet_breed.dart';

@lazySingleton
class GetPetBreedUsecase {
  final AddPetRepository _addPetRepository;

  GetPetBreedUsecase(this._addPetRepository);

  Future<List<PetBreed>> call(int petTypeId) {
    return _addPetRepository.getPetBreeds(petTypeId);
  }
}
