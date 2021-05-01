import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'pet_breed.g.dart';

@JsonSerializable(explicitToJson: true)
class PetBreed {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "id_pet_type")
  final int petTypeId;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "avatar")
  final String avatar;

  PetBreed(
    this.id,
    this.petTypeId,
    this.name,
    this.avatar,
  );
  factory PetBreed.fromJson(Map<String, dynamic> json) => _$PetBreedFromJson(json);

  factory PetBreed.fromJsonString(String jsonString) => PetBreed.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$PetBreedToJson(this);

  String toJsonString() => json.encode(toJson());
}
