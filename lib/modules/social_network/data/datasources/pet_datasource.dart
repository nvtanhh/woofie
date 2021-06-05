import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/get_map_from_hasura.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_breed.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_type.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_vaccinated.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_weight.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_worm_flushed.dart';

@lazySingleton
class PetDatasource {
  final HasuraConnect _hasuraConnect;

  PetDatasource(this._hasuraConnect);

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
    query get_pet {
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
    final mutationInsertPet = """mutation MyMutation {
  insert_pets_one(object: {bio: "${pet.bio ?? ""}",avatar_current: {data: {url: "${pet.avatar?.url ?? ""}"}}, dob: "${(pet.dob ?? "").toString()}", name: "${pet.name ?? ""}", pet_breed_id: ${pet.petBreedId!}, pet_type_id: ${pet.petTypeId!}}) {
    id
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

  Future<List<PetVaccinated>> getVaccinates(int idPet, int limit, int offset) async {
    return [
      PetVaccinated(
        id: 0,
        name: "Tiêm ngừa dại",
        createdAt: DateTime(2021, 5, 15),
        description: "mato",
      ),
      PetVaccinated(
        id: 1,
        name: "Tiêm ngừa uốn ván",
        createdAt: DateTime(2021, 2, 15),
        description: "mato",
      ),
      PetVaccinated(
        id: 3,
        name: "Tiêm ngừa ngừa ngu",
        createdAt: DateTime(2021, 1, 15),
        description: "Mato",
      ),
    ];
  }

  Future<List<PetWeight>> getWeights(int idPet, int limit, int offset) async {
    return [
      PetWeight(id: 0, createdAt: DateTime(2021, 5, 15), description: "ac", weight: 5),
      PetWeight(id: 1, createdAt: DateTime(2021, 4, 15), description: "ac", weight: 3),
      PetWeight(id: 2, createdAt: DateTime(2021, 3, 15), description: "ac", weight: 4),
      PetWeight(id: 3, createdAt: DateTime(2021, 4, 15), description: "ac", weight: 5),
    ];
  }

  Future<List<PetWormFlushed>> getWormFlushes(int idPet, int limit, int offset) async {
    return [
      PetWormFlushed(
        id: 0,
        description: "Sau khi xổ giun bé bị ói nhiều",
        createdAt: DateTime(2021, 5, 15),
      ),
      PetWormFlushed(
        id: 1,
        description: "Sau khi xổ giun bé bị ói nhiều",
        createdAt: DateTime(2021, 4, 15),
      ),
      PetWormFlushed(
        id: 2,
        description: "Sau khi xổ giun bé bị ói nhiều",
        createdAt: DateTime(2021, 3, 15),
      ),
      PetWormFlushed(
        id: 3,
        description: "",
        createdAt: DateTime(2021, 2, 15),
      ),
    ];
  }

  Future<PetVaccinated> addVaccinated(PetVaccinated petVaccinated) async {
    return petVaccinated;
  }

  Future<PetWormFlushed> addWormFlushed(PetWormFlushed petWormFlushed) async {
    return petWormFlushed;
  }

  Future<PetWeight> addWeight(PetWeight petWeight) async {
    return petWeight;
  }
}
