import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/gender.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_breed.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_owner_history.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_type.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_vaccinated.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_weight.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_worm_flushed.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

import '../updatable_model.dart';

part 'pet.g.dart';

@JsonSerializable(explicitToJson: true)
class Pet extends UpdatableModel<Pet> {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "uuid")
  String? uuid;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "bio")
  String? bio;
  @JsonKey(name: "pet_type_id")
  int? petTypeId;
  @JsonKey(name: "pet_type")
  PetType? petType;
  @JsonKey(name: "gender")
  Gender? gender;
  @JsonKey(name: "dob")
  DateTime? dob;
  @JsonKey(name: "avatar")
  Media? avatar;
  @JsonKey(name: "current_owner_uuid")
  String? currentOwnerUuid;
  @JsonKey(name: "current_owner")
  User? currentOwner;
  @JsonKey(name: "pet_owners", fromJson: allOwnersFromJson)
  List<PetOwnerHistory>? allOwners;
  @JsonKey(name: "pet_breed_id")
  int? petBreedId;
  @JsonKey(name: "pet_breed")
  PetBreed? petBreed;
  @JsonKey(name: "is_following")
  bool? isFollowing;
  @JsonKey(name: "pet_worm_flusheds")
  List<PetWormFlushed>? petWormFlushes;
  @JsonKey(name: "pet_vaccinateds")
  List<PetVaccinated>? petVaccinates;
  @JsonKey(name: "pet_weights")
  List<PetWeight>? petWeights;
  @JsonKey(name: "avatar_url")
  String? avatarUrl;
  Pet(
      {required this.id,
      this.name,
      this.petTypeId,
      this.gender,
      this.dob,
      this.avatar,
      this.currentOwnerUuid,
      this.currentOwner,
      this.allOwners,
      this.petType,
      this.petBreed,
      this.petBreedId,
      this.bio,
      this.isFollowing,
      this.petVaccinates,
      this.petWormFlushes,
      this.petWeights,
      this.avatarUrl})
      : super(id);

  factory Pet.fromJson(Map<String, dynamic> json) {
    return factory.fromJson(json);
  }

  factory Pet.fromJsonPure(Map<String, dynamic> json) => _$PetFromJson(json);

  factory Pet.fromJsonString(String jsonString) =>
      Pet.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$PetToJson(this);

  String toJsonString() => json.encode(toJson());
  void followPet() {
    isFollowing = true;
    notifyUpdate();
  }

  void unFollowPet() {
    isFollowing = false;
    notifyUpdate();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pet && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  static List<PetOwnerHistory>? allOwnersFromJson(List<dynamic>? list) {
    return list
        ?.map((e) => PetOwnerHistory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static final factory = PetFactory();

  @override
  void updateFromJson(Map json) {
    if (json['name'] != null) {
      name = json['name'] as String;
    }
    if (json['uuid'] != null) {
      uuid = json['uuid'] as String;
    }
    if (json['pet_type_id'] != null) petTypeId = json['pet_type_id'] as int;
    if (json['gender'] != null) {
      gender = _$enumDecodeNullable(_$GenderEnumMap, json['gender']);
    }
    if (json['dob'] != null) {
      dob = json['dob'] == null ? null : DateTime.parse(json['dob'] as String);
    }
    if (json['avatar'] != null) {
      avatar = Media.fromJson(json['avatar'] as Map<String, dynamic>);
    }
    if (json['current_owner_id'] != null) {
      currentOwnerUuid = json['current_owner_id'] as String;
    }
    if (json['current_owner'] != null) {
      currentOwner =
          User.fromJson(json['current_owner'] as Map<String, dynamic>);
    }
    if (json['pet_owners'] != null) {
      allOwners = allOwnersFromJson(json['pet_owners'] as List<dynamic>);
    }
    if (json['pet_type'] != null) {
      petType = PetType.fromJson(json['pet_type'] as Map<String, dynamic>);
    }
    if (json['pet_breed'] != null) {
      petBreed = PetBreed.fromJson(json['pet_breed'] as Map<String, dynamic>);
    }
    if (json['pet_breed_id'] != null) {
      petBreedId = json['pet_breed_id'] as int;
    }
    if (json['bio'] != null) {
      bio = json['bio'] as String;
    }
    if (json['is_following'] != null) {
      isFollowing = json['is_following'] as bool;
    }
    if (json['pet_vaccinateds'] != null) {
      petVaccinates = (json['pet_vaccinateds'] as List<dynamic>?)
          ?.map((e) => PetVaccinated.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (json['pet_worm_flusheds'] != null) {
      petWormFlushes = (json['pet_worm_flusheds'] as List<dynamic>?)
          ?.map((e) => PetWormFlushed.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (json['pet_weights'] != null) {
      petWeights = (json['pet_weights'] as List<dynamic>?)
          ?.map((e) => PetWeight.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (json['avatar_url'] != null) {
      avatarUrl = json['avatar_url'] as String;
    }
  }
}

class PetFactory extends UpdatableModelFactory<Pet> {
  @override
  Pet makeFromJson(Map<String, dynamic> json) => _$PetFromJson(json);
}
