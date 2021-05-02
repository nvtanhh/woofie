import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/get_map_from_hasura.dart';
import 'package:meowoof/modules/add_pet/domain/models/pet.dart';
import 'package:meowoof/modules/add_pet/domain/models/pet_breed.dart';
import 'package:meowoof/modules/add_pet/domain/models/pet_type.dart';

@lazySingleton
class AddPetDatasource {
  final HasuraConnect _hasuraConnect;

  AddPetDatasource(this._hasuraConnect);

  Future<List<PetType>> getPetTypes() async {
    const queryGetPetTypes = """
    query get_pet_type {
      pet_types {
      id
      name
      descriptions
      avatar}}
    """;
    final data = await _hasuraConnect.query(queryGetPetTypes);
    final listPetType = GetMapFromHasura.getMap(data as Map)["pet_types"] as List;
    return listPetType.map((e) => PetType.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<PetBreed>> getPetBreeds(int petTypeId) async {
    final queryGetPetBreeds = """
    query getpet {
    pet_breeds(where: {id_pet_type: {_eq: $petTypeId}}) {
    avatar
    id
    id_pet_type
    name
    }
    }
    """;
    final data = await _hasuraConnect.query(queryGetPetBreeds);
    final listPetType = GetMapFromHasura.getMap(data as Map)["pet_breeds"] as List;
    return listPetType.map((e) => PetBreed.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<bool> addPet(Pet pet) async {
    final mutationInsertPet = """
    mutation insert_pet {
    insert_pets(objects: {avatar: "${pet.avatar}", gender: ${pet.gender.index}, id_pet_breed: ${pet.petBreedId}, id_pet_type: ${pet.petTypeId}, name: "${pet.name}"}) {
    affected_rows
    }
    }
    """;
    final data = await _hasuraConnect.mutation(mutationInsertPet);
    final affectedRows = GetMapFromHasura.getMap(data as Map)["insert_pets"] as Map;
    if ((affectedRows["affected_rows"] as int) >= 1) {
      return true;
    } else {
      return false;
    }
  }
}
