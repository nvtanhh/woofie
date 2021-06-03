import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'pet_weight.g.dart';

@JsonSerializable(explicitToJson: true)
class PetWeight {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "pet_id")
  int? petId;
  @JsonKey(name: "weight")
  double? weight;
  @JsonKey(name: "description")
  String? description;
  @JsonKey(name: "created_at")
  DateTime? createdAt;

  PetWeight({
    required this.id,
    this.weight,
    this.description,
    this.createdAt,
  });

  factory PetWeight.fromJson(Map<String, dynamic> json) => _$PetWeightFromJson(json);

  factory PetWeight.fromJsonString(String jsonString) => PetWeight.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$PetWeightToJson(this);

  String toJsonString() => json.encode(toJson());
}
