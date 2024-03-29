import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/get_map_from_hasura.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/gender.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_breed.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_type.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_vaccinated.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_weight.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_worm_flushed.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class PetDatasource {
  final HasuraConnect _hasuraConnect;
  final LoggedInUser _loggedInUser;

  PetDatasource(
    this._hasuraConnect,
    this._loggedInUser,
  );

  Future<List<PetType>> getPetTypes() async {
    const queryGetPetTypes = """
    query get_pet_type {
      pet_types(order_by: {order: asc}) {
        id
        name
        descriptions
        avatar
      }
    }
    """;
    final data = await _hasuraConnect.query(queryGetPetTypes);
    final listPetType =
        GetMapFromHasura.getMap(data as Map)["pet_types"] as List;
    return listPetType
        .map((e) => PetType.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<User>> getAllUserInPost(int postId, int limit, int offset) async {
    final query = """
    query getPostDetail {
  get_all_user_in_post(post_id: $postId) {
    avatar_url
    id
    name
    uuid
  }
  }
""";
    final data = await _hasuraConnect.query(query);
    final petWormFlushes =
        GetMapFromHasura.getMap(data as Map)["get_all_user_in_post"] as List;
    return petWormFlushes
        .map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
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
    final listPetType =
        GetMapFromHasura.getMap(data as Map)["pet_breeds"] as List;
    return listPetType
        .map((e) => PetBreed.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Pet> addPet(Pet pet) async {
    final userUUID = _loggedInUser.user!.uuid;
    String petType = "", petBreed = "";
    if (pet.petTypeId != null) {
      petType = "pet_type_id: ${pet.petTypeId ?? 0},";
      if (pet.petBreedId != null) {
        petBreed = "pet_breed_id: ${pet.petBreedId ?? 0},";
      }
    }
    final mutationInsertPet = """
    mutation MyMutation {
    insert_pets_one(object: {bio: "${pet.bio ?? ""}",uuid:"${pet.uuid}" ,dob: "${(pet.dob ?? "").toString()}", gender: "${pet.gender?.index ?? 0}", name: "${pet.name ?? ""}", $petType $petBreed pet_owners: {data: {owner_uuid: "$userUUID"}}, avatar: {data: {url: "${pet.avatarUrl ?? ""}"}},avatar_url:"${pet.avatarUrl ?? ""}"}) {
    id
    uuid
    name
    dob
    bio
    avatar_url
    pet_breed_id
    pet_type_id
  }}
    """;
    final data = await _hasuraConnect.mutation(mutationInsertPet);
    final affectedRows =
        GetMapFromHasura.getMap(data as Map)["insert_pets_one"] as Map;
    return Pet.fromJson(affectedRows as Map<String, dynamic>);
  }

  Future<List<PetVaccinated>> getVaccinates(
      int idPet, int limit, int offset,) async {
    final query = """
    query MyQuery {
  pet_vaccinateds(limit: $limit, offset: $offset, where: {pet_id: {_eq: $idPet}}, order_by: {date: desc}) {
     created_at
    description
    date
    id
    vaccine_name
  }}
""";
    final data = await _hasuraConnect.query(query);
    final petVaccinates =
        GetMapFromHasura.getMap(data as Map)["pet_vaccinateds"] as List;
    return petVaccinates
        .map((e) => PetVaccinated.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<PetWeight>> getWeights(int idPet, int limit, int offset) async {
    final query = """
    query MyQuery {
  pet_weights(limit: $limit, offset: $offset, where: {pet_id: {_eq: $idPet}}, order_by: {date: desc}) {
    id
    description
    date
    created_at
    weight
  }}
""";
    final data = await _hasuraConnect.query(query);
    final petWeights =
        GetMapFromHasura.getMap(data as Map)["pet_weights"] as List;
    return petWeights
        .map((e) => PetWeight.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<PetWormFlushed>> getWormFlushes(
      int idPet, int limit, int offset,) async {
    final query = """
    query MyQuery {
  pet_worm_flusheds(limit: $limit, offset: $offset, where: {pet_id: {_eq: $idPet}}, order_by: {date: desc}) {
    created_at
    date
    description
    id}}
""";
    final data = await _hasuraConnect.query(query);
    final petWormFlushes =
        GetMapFromHasura.getMap(data as Map)["pet_worm_flusheds"] as List;
    return petWormFlushes
        .map((e) => PetWormFlushed.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> getDetailInfoPet(int idPet) async {
    final query = """
    query MyQuery {
      pets_by_pk(id: $idPet) {
        avatar_url
        uuid
        bio
        dob
        gender
        id
        name
        is_following
        pet_type_id
        pet_vaccinateds(limit: 2, order_by: {date: desc}) {
          description
          id
          vaccine_name
          date
        }
        pet_weights(limit: 6, order_by: {date: desc}) {
          id
          weight
          description
          date
        }
        pet_worm_flusheds(limit: 2, order_by: {date: desc}) {
          description
          id
          date
        }
        pet_breed {
          name
          id
        }
        current_owner {
          id
          uuid
          name
          avatar_url
          bio
        }
        pet_owners(order_by: {created_at: desc}) {
          owner {
            id
            uuid
            name
            bio
            avatar_url
          }
          give_time
          created_at
        }
      }
    }
    """;
    final data = await _hasuraConnect.query(query);
    return GetMapFromHasura.getMap(data as Map)["pets_by_pk"]
        as Map<String, dynamic>;
  }

  Future<List<Pet>> getPetsOfUser(String userUUID) async {
    final query = """
query MyQuery {
  pets(where: {current_owner_uuid: {_eq: "$userUUID"}}) {
    bio
    name
    id
    avatar_url
  }
}
    """;
    final data = await _hasuraConnect.query(query);
    final list = GetMapFromHasura.getMap(data as Map)["pets"] as List;
    return list.map((e) => Pet.fromJson(e as Map<String, dynamic>)).toList();
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
    final affectedRows =
        GetMapFromHasura.getMap(data as Map)["insert_pet_vaccinateds_one"]
            as Map;
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
    final affectedRows =
        GetMapFromHasura.getMap(data as Map)["insert_pet_worm_flusheds_one"]
            as Map;
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
    final affectedRows =
        GetMapFromHasura.getMap(data as Map)["insert_pet_weights_one"] as Map;
    petWeight.id = affectedRows["id"] as int;
    return petWeight;
  }

  Future<List<Pet>> searchPet(String keyWord, int offset, int limit) async {
    final query = """
    query MyQuery {
      pets(where: {name: {_ilike: "$keyWord%"}}, limit: $limit, offset: $offset, order_by: {name: desc}) {
        id
        avatar_url
        name
        bio
        is_following
      }
    }
    """;
    final data = await _hasuraConnect.query(query);
    final list = GetMapFromHasura.getMap(data as Map)["pets"] as List;
    return list.map((e) => Pet.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<bool> deletePet(int petId) async {
    final manution = """
mutation MyMutation {
  delete_pets_by_pk(id: $petId) {
    id
  }
}
    """;
    await _hasuraConnect.mutation(manution);
    return true;
  }

  Future<bool> deletePetVaccinated(int petVaccinatedId) async {
    final manution = """
mutation MyMutation {
  delete_pet_vaccinateds_by_pk(id: $petVaccinatedId) {
    id
  }
}
    """;
    await _hasuraConnect.mutation(manution);
    return true;
  }

  Future<bool> deletePetWeight(int petWeightId) async {
    final manution = """
mutation MyMutation {
  delete_pet_weights_by_pk(id: $petWeightId) {
    id
  }
}
    """;
    await _hasuraConnect.mutation(manution);
    return true;
  }

  Future<bool> deletePetWormFlush(int petWormFlushId) async {
    final manution = """
mutation MyMutation {
  delete_pet_worm_flusheds_by_pk(id: $petWormFlushId) {
    id
  }
}
    """;
    await _hasuraConnect.mutation(manution);
    return true;
  }

  Future<Map<String, dynamic>> updatePetInformation(
    int petId,
    String? name,
    String? bio,
    int? breedId,
    String? avatarUrl,
    String? uuid,
    DateTime? dob,
    Gender? gender,
  ) async {
    final nName = name == null ? "" : 'name: "$name",';
    final nBio = bio == null ? "" : 'bio: "$bio",';
    final nDob = dob == null ? "" : 'dob: "${dob.toString()}"';
    final nPetBreedId = breedId == null ? "" : 'pet_breed_id: "$breedId",';
    final nGender = gender == null ? "" : 'gender: "${gender.index}",';
    final nUuid = uuid == null ? "" : 'uuid: "$uuid",';
    final nAvatarUrl = avatarUrl == null ? "" : 'avatar_url: "$avatarUrl"';
    final manution = """
mutation MyMutation {
  update_pets_by_pk(pk_columns: {id: $petId}, _set: {$nName $nBio $nDob $nPetBreedId $nGender $nUuid $nAvatarUrl}) {
    avatar_url
    bio
    dob
    gender
    name
    uuid
    pet_breed_id
  }
}

""";
    final data = await _hasuraConnect.mutation(manution);
    return GetMapFromHasura.getMap(data as Map)["update_pets_by_pk"]
        as Map<String, dynamic>;
  }

  Future<PetVaccinated> updatePetVaccinated(PetVaccinated petVaccinated) async {
    final manution = """
mutation MyMutation {
  update_pet_vaccinateds_by_pk(pk_columns: {id: ${petVaccinated.id}},_set: {date: "${petVaccinated.date.toString()}", vaccine_name: "${petVaccinated.name}", description: "${petVaccinated.description}"}) {
    vaccine_name
    pet_id
    description
    date
    id
    updated_at
    created_at
  }
}

""";
    final data = await _hasuraConnect.mutation(manution);
    return PetVaccinated.fromJson(
        GetMapFromHasura.getMap(data as Map)["update_pet_vaccinateds_by_pk"]
            as Map<String, dynamic>,);
  }

  Future<PetWeight> updatePetWeight(PetWeight petWeight) async {
    final manution = """
mutation MyMutation {
  update_pet_weights_by_pk(pk_columns: {id: ${petWeight.id}}, _set: {date: "${petWeight.date.toString()}", description: "${petWeight.description}", weight: "${petWeight.weight}"}) {
    id
    description
    date
    weight
    updated_at
    created_at
    pet_id
  }
}
""";
    final data = await _hasuraConnect.mutation(manution);
    return PetWeight.fromJson(
        GetMapFromHasura.getMap(data as Map)["update_pet_weights_by_pk"]
            as Map<String, dynamic>,);
  }

  Future<PetWormFlushed> updatePetWormFlush(
      PetWormFlushed petWormFlushed,) async {
    final manution = """
mutation MyMutation {
  update_pet_worm_flusheds_by_pk(pk_columns: {id: ${petWormFlushed.id}}, _set: {date: "${petWormFlushed.date.toString()}", description: "${petWormFlushed.description}"}) {
    id
    description
    date
    created_at
    pet_id
    updated_at
  }
}

""";
    final data = await _hasuraConnect.mutation(manution);
    return PetWormFlushed.fromJson(
        GetMapFromHasura.getMap(data as Map)["update_pet_worm_flusheds_by_pk"]
            as Map<String, dynamic>,);
  }

  Future<bool> changePetOwner(User user, Pet pet) async {
    final String addNewOwner = """
    mutation MyMutation {
      insert_pet_owners_one(object: {owner_uuid: "${user.uuid}", pet_id: ${pet.id}}) {
        id
      }
    }
    """;
    await _hasuraConnect.mutation(addNewOwner);

    final String updateGiveTime = """
    mutation MyMutation {
      update_pet_owners(where: {owner_uuid: {_eq: "${_loggedInUser.user!.uuid}"}, pet_id: {_eq: ${pet.id}}}, _set: {give_time: "${DateTime.now().toString()}"}) {
        affected_rows
      }
    }
    """;
    await _hasuraConnect.mutation(updateGiveTime);
    // Update current pet owner
    final String updateCurrentOwner = """
    mutation MyMutation {
      update_pets_by_pk(pk_columns: {id: ${pet.id}}, _set: {current_owner_uuid: "${user.uuid}"}){
        id
      }
    }
    """;
    await _hasuraConnect.mutation(updateCurrentOwner);
    return true;
  }
}
