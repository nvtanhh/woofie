import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pet_breed.g.dart';

@JsonSerializable(explicitToJson: true)
class PetBreed extends Equatable {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "id_pet_type")
  int? petTypeId;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "avatar")
  String? avatar;

  PetBreed({
    required this.id,
    this.petTypeId,
    this.name,
    this.avatar,
  });

  factory PetBreed.fromJson(Map<String, dynamic> json) =>
      _$PetBreedFromJson(json);

  factory PetBreed.fromJsonString(String jsonString) =>
      PetBreed.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$PetBreedToJson(this);

  String toJsonString() => json.encode(toJson());

  @override
  bool operator ==(Object other) => other is PetBreed && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
