import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'pet_worm_flushed.g.dart';

@JsonSerializable(explicitToJson: true)
class PetWormFlushed {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "pet_id")
  int? petId;
  @JsonKey(name: "description")
  String? description;
  @JsonKey(name: "date")
  DateTime? date;
  @JsonKey(name: "created_at")
  DateTime? createdAt;
  @JsonKey(name: "updated_at")
  DateTime? updatedAt;

  PetWormFlushed({
    required this.id,
    this.description,
    this.createdAt,
    this.petId,
    this.date,
    this.updatedAt,
  });

  factory PetWormFlushed.fromJson(Map<String, dynamic> json) => _$PetWormFlushedFromJson(json);

  factory PetWormFlushed.fromJsonString(String jsonString) => PetWormFlushed.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$PetWormFlushedToJson(this);

  String toJsonString() => json.encode(toJson());
}
