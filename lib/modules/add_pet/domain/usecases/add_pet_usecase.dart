import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/add_pet/data/repositories/add_pet_repositories.dart';
import 'package:meowoof/modules/add_pet/domain/models/pet.dart';

@lazySingleton
class AddPetUsecase{
  final AddPetRepository _addPetRepository;

  AddPetUsecase(this._addPetRepository);

  Future<bool> call(Pet pet){
    return _addPetRepository.addPet(pet);
  }
}