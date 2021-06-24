import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/datasources/pet_datasource.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_breed.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_type.dart';

@lazySingleton
class AddPetRepository {
  final PetDatasource _addPetDatasource;

  AddPetRepository(this._addPetDatasource);

  Future<List<PetType>> getPetTypes() {
    return _addPetDatasource.getPetTypes();
  }

  Future<List<PetBreed>> getPetBreeds(int petTypeId) {
    return _addPetDatasource.getPetBreeds(petTypeId);
  }

  Future<Pet> addPet(Pet pet) {
    return _addPetDatasource.addPet(pet);
  }
}
