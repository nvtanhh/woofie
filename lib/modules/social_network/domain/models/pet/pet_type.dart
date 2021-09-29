import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'pet_type.g.dart';

@JsonSerializable(explicitToJson: true)
class PetType extends Equatable {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "descriptions")
  String? descriptions;
  @JsonKey(name: "avatar")
  String? avatar;

  PetType({
    required this.id,
    this.name,
    this.descriptions,
    this.avatar,
  });

  @override
  List<Object> get props => [id];

  factory PetType.fromJson(Map<String, dynamic> json) =>
      _$PetTypeFromJson(json);

  factory PetType.fromJsonString(String jsonString) =>
      PetType.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$PetTypeToJson(this);

  String toJsonString() => json.encode(toJson());
}
