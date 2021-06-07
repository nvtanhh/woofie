import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/get_map_from_hasura.dart';
import 'package:meowoof/modules/auth/data/storages/user_storage.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_breed.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_type.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_vaccinated.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_weight.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_worm_flushed.dart';

@lazySingleton
class PetDatasource {
  final HasuraConnect _hasuraConnect;
  final UserStorage _userStorage;

  PetDatasource(
    this._hasuraConnect,
    @Named("current_user_storage") this._userStorage,
  );

  Future<List<PetType>> getPetTypes() async {
    const queryGetPetTypes = """
    query get_pet_type {
      pet_types {
      id
      name
      descriptions
      avatar
      }}
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
    }}
    """;
    final data = await _hasuraConnect.query(queryGetPetBreeds);
    final listPetType = GetMapFromHasura.getMap(data as Map)["pet_breeds"] as List;
    return listPetType.map((e) => PetBreed.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Pet> addPet(Pet pet) async {
    final userId = _userStorage.get()?.id;
    if (userId == null) {
      throw "Error";
    }
    final mutationInsertPet = """
    mutation MyMutation {
  insert_pets_one(object: {bio: "${pet.bio ?? ""}", dob: "${(pet.dob ?? "").toString()}", gender: "${pet.gender?.index ?? 0}", name: "${pet.name ?? ""}", pet_breed_id: ${pet.petBreedId ?? 0}, pet_type_id: ${pet.petTypeId ?? 0}, pet_owners: {data: {owner_id: $userId}}, avatar_current: {data: {url: "${pet.avatar?.url ?? ""}"}}}) {
    id
    name
    dob
    bio
    avatar_current {
      id
      url
      type
    }
    pet_breed_id
    pet_type_id
  }}
    """;
    final data = await _hasuraConnect.mutation(mutationInsertPet);
    final affectedRows = GetMapFromHasura.getMap(data as Map)["insert_pets_one"] as Map;
    return Pet.fromJson(affectedRows as Map<String, dynamic>);
  }

  Future<List<PetVaccinated>> getVaccinates(int idPet, int limit, int offset) async {
    final query = """
    query MyQuery {
  pet_vaccinateds(limit: $limit, offset: $offset, where: {pet_id: {_eq: $idPet}}, order_by: {created_at: desc, date: desc}) {
     created_at
    description
    date
    id
    vaccine_name
  }}
""";
    final data = await _hasuraConnect.query(query);
    final petVaccinates = GetMapFromHasura.getMap(data as Map)["pet_vaccinateds"] as List;
    return petVaccinates.map((e) => PetVaccinated.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<PetWeight>> getWeights(int idPet, int limit, int offset) async {
    final query = """
    query MyQuery {
  pet_weights(limit: $limit, offset: $offset, where: {pet_id: {_eq: $idPet}}, order_by: {created_at: desc, date: desc}) {
    id
    description
    date
    created_at
    weight
  }}
""";
    final data = await _hasuraConnect.query(query);
    final petWeights = GetMapFromHasura.getMap(data as Map)["pet_weights"] as List;
    return petWeights.map((e) => PetWeight.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<PetWormFlushed>> getWormFlushes(int idPet, int limit, int offset) async {
    final query = """
    query MyQuery {
  pet_worm_flusheds(limit: $limit, offset: $offset, where: {pet_id: {_eq: $idPet}}, order_by: {created_at: desc, date: desc}) {
    created_at
    date
    description
    id}}
""";
    final data = await _hasuraConnect.query(query);
    final petWormFlushes = GetMapFromHasura.getMap(data as Map)["pet_worm_flusheds"] as List;
    return petWormFlushes.map((e) => PetWormFlushed.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<PetVaccinated> addVaccinated(PetVaccinated petVaccinated) async {
    return petVaccinated;
  }

  Future<PetWormFlushed> addWormFlushed(PetWormFlushed petWormFlushed) async {
    return petWormFlushed;
  }

  Future<PetWeight> addWeight(PetWeight petWeight) async {
    final manution = """
    mutation MyMutation {
  insert_pet_weights_one(object: {date: "${petWeight.date.toString()}", weight: "${petWeight.weight}", pet_id: ${petWeight.petId!}}) {
    id
  }}
""";
    final data = await _hasuraConnect.mutation(manution);
    final affectedRows = GetMapFromHasura.getMap(data as Map)["insert_pet_weights_one"] as Map;
    petWeight.id = affectedRows["id"] as int;
    return petWeight;
  }

  Future<Pet> getDetailInfoPet(int idPet) async {
    final query = """
    query MyQuery {
  pets(limit: 1, where: {id: {_eq: $idPet}}) {
    avatar_current {
      url
      id
    }
    bio
    dob
    gender
    id
    name
    pet_vaccinateds(limit: 2, order_by: {created_at: desc, date: desc}) {
      created_at
      description
      id
      vaccine_name
    }
    pet_weights(limit: 6, order_by: {created_at: desc, date: desc}) {
      created_at
      id
      weight
      description
    }
    pet_worm_flusheds(limit: 2, order_by: {created_at: desc, date: desc}) {
      created_at
      description
      id
    }
    pet_breed {
      name
      id
    }}}
    """;
    final data = await _hasuraConnect.query(query);
    final affectedRows = GetMapFromHasura.getMap(data as Map)["pets"] as List;
    return Pet.fromJson(affectedRows[0] as Map<String, dynamic>);
  }
}
