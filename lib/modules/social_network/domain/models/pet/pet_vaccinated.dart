import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'pet_vaccinated.g.dart';

@JsonSerializable(explicitToJson: true)
class PetVaccinated {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "pet_id")
  int? petId;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "description")
  String? description;
  @JsonKey(name: "created_at")
  DateTime? createdAt;

  PetVaccinated({required this.id, this.description,this.name, this.createdAt, this.petId});

  factory PetVaccinated.fromJson(Map<String, dynamic> json) => _$PetVaccinatedFromJson(json);

  factory PetVaccinated.fromJsonString(String jsonString) => PetVaccinated.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$PetVaccinatedToJson(this);

  String toJsonString() => json.encode(toJson());
}
