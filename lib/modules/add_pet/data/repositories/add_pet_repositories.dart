import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/add_pet/data/datasources/add_pet_datasources.dart';
import 'package:meowoof/modules/add_pet/domain/models/pet.dart';
import 'package:meowoof/modules/add_pet/domain/models/pet_breed.dart';
import 'package:meowoof/modules/add_pet/domain/models/pet_type.dart';

@lazySingleton
class AddPetRepository {
  final AddPetDatasource _addPetDatasource;

  AddPetRepository(this._addPetDatasource);

  Future<List<PetType>> getPetTypes() {
    return _addPetDatasource.getPetTypes();
  }

  Future<List<PetBreed>> getPetBreeds(int petTypeId) {
    return _addPetDatasource.getPetBreeds(petTypeId);
  }

  Future<bool> addPet(Pet pet) {
    return _addPetDatasource.addPet(pet);
  }
}
