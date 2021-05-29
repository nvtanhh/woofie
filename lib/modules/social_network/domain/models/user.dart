import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "uid")
  String? uid;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "bio")
  String? bio;
  @JsonKey(name: "phone_number")
  String? phoneNumber;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "pets")
  List<Pet>? pets;
  @JsonKey(name: "avatar_current")
  Media? avatar;
  @JsonKey(name: "avatar_url")
  String? avatarUrl;
  User({
    required this.id,
    this.uid,
    this.name,
    this.phoneNumber,
    this.email,
    this.pets,
    this.avatar,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromJsonString(String jsonString) => User.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String toJsonString() => json.encode(toJson());
}
