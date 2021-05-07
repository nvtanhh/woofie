import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meowoof/modules/add_pet/domain/models/gender.dart';
import 'package:meowoof/modules/add_pet/domain/models/pet_breed.dart';
import 'package:meowoof/modules/add_pet/domain/models/pet_type.dart';
import 'package:meowoof/modules/auth/domain/models/user.dart';

part 'pet.g.dart';

@JsonSerializable(explicitToJson: true)
class Pet {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "id_pet_type")
  int petTypeId;
  @JsonKey(name: "gender")
  Gender gender;
  @JsonKey(name: "dob")
  DateTime dob;
  @JsonKey(name: "avatar")
  String avatar;
  @JsonKey(name: "id_owner")
  String ownerId;
  @JsonKey(name: "owner")
  User owner;
  @JsonKey(name: "pet_type")
  PetType petType;
  @JsonKey(name: "id_pet_breed")
  int petBreedId;
  @JsonKey(name: "pet_breed")
  PetBreed petBreed;

  Pet({
    this.id,
    this.name,
    this.petTypeId,
    this.gender,
    this.dob,
    this.avatar,
    this.ownerId,
    this.owner,
    this.petType,
    this.petBreed,
    this.petBreedId,
  });

  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);

  factory Pet.fromJsonString(String jsonString) => Pet.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$PetToJson(this);

  String toJsonString() => json.encode(toJson());
}
