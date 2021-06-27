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
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';

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
    final userUUID = _userStorage.get()?.uuid;
    if (userUUID == null) {
      throw "Error";
    }
    final mutationInsertPet = """
    mutation MyMutation {
  insert_pets_one(object: {bio: "${pet.bio ?? ""}", dob: "${(pet.dob ?? "").toString()}", gender: "${pet.gender?.index ?? 0}", name: "${pet.name ?? ""}", pet_breed_id: ${pet.petBreedId ?? 0}, pet_type_id: ${pet.petTypeId ?? 0}, pet_owners: {data: {owner_uuid: "$userUUID"}}, avatar: {data: {url: "${pet.avatar?.url ?? ""}"}}}) {
    id
    name
    dob
    bio
    avatar {
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
    final manution = """
mutation MyMutation {
  insert_pet_vaccinateds_one(object: {vaccine_name: "${petVaccinated.name}", pet_id: ${petVaccinated.petId}, date: "${petVaccinated.date.toString()}", description: "${petVaccinated.description ?? ""}"}) {
    id
  }
}
""";
    final data = await _hasuraConnect.mutation(manution);
    final affectedRows = GetMapFromHasura.getMap(data as Map)["insert_pet_vaccinateds_one"] as Map;
    petVaccinated.id = affectedRows["id"] as int;
    return petVaccinated;
  }

  Future<PetWormFlushed> addWormFlushed(PetWormFlushed petWormFlushed) async {
    final manution = """
    mutation MyMutation {
  insert_pet_worm_flusheds_one(object: {date: "${petWormFlushed.date.toString()}", description: "${petWormFlushed.description}", pet_id: ${petWormFlushed.petId!}}) {
    id
  }}
""";
    final data = await _hasuraConnect.mutation(manution);
    final affectedRows = GetMapFromHasura.getMap(data as Map)["insert_pet_worm_flusheds_one"] as Map;
    petWormFlushed.id = affectedRows["id"] as int;
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
    avatar {
      url
      id
    }
    bio
    dob
    gender
    id
    name
    is_following
    pet_vaccinateds(limit: 2, order_by: {created_at: desc, date: desc}) {
      description
      id
      vaccine_name
      date
    }
    pet_weights(limit: 6, order_by: {created_at: desc, date: desc}) {
      id
      weight
      description
      date
    }
    pet_worm_flusheds(limit: 2, order_by: {created_at: desc, date: desc}) {
      description
      id
      date
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

  Future<List<Pet>> searchPet(String keyWord, int offset, int limit) async {
    await Future.delayed(const Duration(seconds: 1));
    if (keyWord.isEmpty) {
      return const <Pet>[];
    } else {
      return <Pet>[
        Pet(
          id: 0,
          name: "Vàng",
          avatar: Media(
            id: 0,
            url: "http://thucanhviet.com/wp-content/uploads/2018/03/Pom-2-thang-mat-cuc-xinh-696x528.jpg",
            type: MediaType.image,
          ),
        ),
        Pet(
          id: 1,
          name: "Đỏ",
          avatar: Media(
            id: 0,
            url: "http://thucanhviet.com/wp-content/uploads/2018/03/Pom-2-thang-mat-cuc-xinh-696x528.jpg",
            type: MediaType.image,
          ),
        ),
      ];
    }
  }

  Future<List<Pet>> getPetsOfUser(String userUUID) async {
    final query = """
    query MyQuery {
  pets(where: {pet_owners: {owner_uuid: {_eq: "$userUUID"}}}) {
    avatar {
      type
      url
      id
    }
    bio
    id
    name
  }
}
    """;
    final data = await _hasuraConnect.query(query);
    final list = GetMapFromHasura.getMap(data as Map)["pets"] as List;
    return list.map((e) => Pet.fromJson(e as Map<String, dynamic>)).toList();
  }
}
