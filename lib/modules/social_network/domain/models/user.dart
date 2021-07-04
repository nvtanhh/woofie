import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';
import 'package:meowoof/modules/social_network/domain/models/updatable_model.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User extends UpdatableModel<User> {
  @override
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "uuid")
  String? uuid;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "bio")
  String? bio;
  @JsonKey(name: "phone_number")
  String? phoneNumber;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "current_pets")
  List<Pet>? currentPets;
  @JsonKey(name: "all_pets", fromJson: allPetsFromJson)
  List<Pet>? allPets;
  @JsonKey(name: "avatar")
  Media? avatar;
  @JsonKey(name: "dob")
  DateTime? dob;

  User({required this.id, this.uuid, this.name, this.phoneNumber, this.email, this.currentPets, this.avatar, this.bio, this.dob});

  factory User.fromJson(Map<String, dynamic> json) {
    return factory.fromJson(json);
  }

  factory User.fromJsonString(String jsonString) => User.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String toJsonString() => json.encode(toJson());

  static List<Pet>? allPetsFromJson(List<dynamic>? list) {
    return list?.map((e) => Pet.fromJson(e["pet"] as Map<String, dynamic>)).toList();
  }

  @override
  void updateFromJson(Map json) {
    if (json['name'] != null) {
      name = json['name'] as String;
    }
    if (json['phone_number'] != null) {
      phoneNumber = json['phone_number'] as String;
    }
    if (json['email'] != null) {
      email = json['email'] as String;
    }
    if (json['current_pets'] != null) {
      currentPets = (json['current_pets'] as List<dynamic>?)?.map((e) => Pet.fromJson(e as Map<String, dynamic>)).toList();
    }
    if (json['all_pet'] != null) {
      currentPets = allPetsFromJson(json['current_pets'] as List?);
    }
    if (json['avatar'] != null) {
      avatar = Media.fromJson(json['avatar'] as Map<String, dynamic>);
    }
    if (json['bio'] != null) {
      bio = json['bio'] as String;
    }
    if (json['dob'] != null) {
      dob = json['dob'] == null ? null : DateTime.parse(json['dob'] as String);
    }
  }

  static final factory = UserFactory();

  bool get isHavePets => currentPets != null && currentPets!.isNotEmpty;
}

class UserFactory extends UpdatableModelFactory<User> {
  @override
  User makeFromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
