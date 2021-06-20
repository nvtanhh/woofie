import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/add_pet_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';

@lazySingleton
class AddPetUsecase {
  final AddPetRepository _addPetRepository;

  AddPetUsecase(this._addPetRepository);

  Future<Pet> call(Pet pet) {
    return _addPetRepository.addPet(pet);
  }
}
