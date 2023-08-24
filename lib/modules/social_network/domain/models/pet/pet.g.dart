// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pet _$PetFromJson(Map<String, dynamic> json) => Pet(
      id: json['id'] as int,
      name: json['name'] as String?,
      petTypeId: json['pet_type_id'] as int?,
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
      dob: json['dob'] == null ? null : DateTime.parse(json['dob'] as String),
      avatar: json['avatar'] == null
          ? null
          : Media.fromJson(json['avatar'] as Map<String, dynamic>),
      currentOwnerUuid: json['current_owner_uuid'] as String?,
      currentOwner: json['current_owner'] == null
          ? null
          : User.fromJson(json['current_owner'] as Map<String, dynamic>),
      allOwners: Pet.allOwnersFromJson(json['pet_owners'] as List?),
      petType: json['pet_type'] == null
          ? null
          : PetType.fromJson(json['pet_type'] as Map<String, dynamic>),
      petBreed: json['pet_breed'] == null
          ? null
          : PetBreed.fromJson(json['pet_breed'] as Map<String, dynamic>),
      petBreedId: json['pet_breed_id'] as int?,
      bio: json['bio'] as String?,
      isFollowing: json['is_following'] as bool?,
      petVaccinates: (json['pet_vaccinateds'] as List<dynamic>?)
          ?.map((e) => PetVaccinated.fromJson(e as Map<String, dynamic>))
          .toList(),
      petWormFlushes: (json['pet_worm_flusheds'] as List<dynamic>?)
          ?.map((e) => PetWormFlushed.fromJson(e as Map<String, dynamic>))
          .toList(),
      petWeights: (json['pet_weights'] as List<dynamic>?)
          ?.map((e) => PetWeight.fromJson(e as Map<String, dynamic>))
          .toList(),
      avatarUrl: json['avatar_url'] as String?,
    )..uuid = json['uuid'] as String?;

Map<String, dynamic> _$PetToJson(Pet instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'uuid': instance.uuid,
    'name': instance.name,
    'bio': instance.bio,
    'pet_type_id': instance.petTypeId,
    'pet_type': instance.petType?.toJson(),
    'gender': _$GenderEnumMap[instance.gender],
    'dob': instance.dob?.toIso8601String(),
    'avatar': instance.avatar?.toJson(),
    'current_owner_uuid': instance.currentOwnerUuid,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('current_owner', instance.currentOwner?.toJson());
  writeNotNull(
      'pet_owners', instance.allOwners?.map((e) => e.toJson()).toList());
  val['pet_breed_id'] = instance.petBreedId;
  val['pet_breed'] = instance.petBreed?.toJson();
  val['is_following'] = instance.isFollowing;
  val['pet_worm_flusheds'] =
      instance.petWormFlushes?.map((e) => e.toJson()).toList();
  val['pet_vaccinateds'] =
      instance.petVaccinates?.map((e) => e.toJson()).toList();
  val['pet_weights'] = instance.petWeights?.map((e) => e.toJson()).toList();
  val['avatar_url'] = instance.avatarUrl;
  return val;
}

const _$GenderEnumMap = {
  Gender.male: 0,
  Gender.female: 1,
  Gender.unknown: 2,
};
