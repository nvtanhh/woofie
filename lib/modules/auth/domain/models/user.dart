import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meowoof/modules/add_pet/domain/models/pet.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  @JsonKey(name: "uid")
  final String uid;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "phone_number")
  final String phoneNumber;
  @JsonKey(name: "email")
  final String email;
  @JsonKey(name: "pets")
  final List<Pet> pets;

  User(
    this.uid,
    this.name,
    this.phoneNumber,
    this.email,
    this.pets,
  );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromJsonString(String jsonString) => User.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String toJsonString() => json.encode(toJson());
}
