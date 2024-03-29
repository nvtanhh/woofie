import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meowoof/modules/social_network/domain/models/location.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';
import 'package:meowoof/modules/social_network/domain/models/setting.dart';
import 'package:meowoof/modules/social_network/domain/models/updatable_model.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User extends UpdatableModel<User> {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "uuid")
  String uuid;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "bio")
  String? bio;
  @JsonKey(name: "phone_number")
  String? phoneNumber;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "current_pets", includeIfNull: false)
  List<Pet>? currentPets;
  @JsonKey(
    name: "all_pets",
    fromJson: allPetsFromJson,
    includeIfNull: false,
  )
  List<Pet>? allPets;
  @JsonKey(name: "avatar")
  Media? avatar;
  @JsonKey(name: "avatar_url")
  String? avatarUrl;
  @JsonKey(name: "dob")
  DateTime? dob;
  @JsonKey(name: "location_id")
  int? locationId;
  @JsonKey(name: "location")
  UserLocation? location;
  @JsonKey(name: "setting")
  Setting? setting;
  @JsonKey(name: "active")
  int? active;

  User({
    required this.id,
    required this.uuid,
    this.name,
    this.phoneNumber,
    this.email,
    this.currentPets,
    this.avatar,
    this.bio,
    this.dob,
    this.avatarUrl,
    this.active,
  }) : super(uuid);

  factory User.fromJson(Map<String, dynamic> json) {
    return factory.fromJson(json);
  }

  factory User.fromJsonPure(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromJsonString(String jsonString) =>
      User.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String toJsonString() => json.encode(toJson());

  static List<Pet>? allPetsFromJson(List<dynamic>? list) {
    return list
        ?.map((e) => Pet.fromJson(e["pet"] as Map<String, dynamic>))
        .toList();
  }

  bool get isHavePet => (currentPets ?? []).isNotEmpty;

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
      currentPets = (json['current_pets'] as List<dynamic>?)
          ?.map((e) => Pet.fromJson(e as Map<String, dynamic>))
          .toList();
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
    if (json['avatar_url'] != null) {
      avatarUrl = json['avatar_url'] as String;
    }
    if (json['location_id'] != null) {
      locationId = json['location_id'] as int;
    }
    if (json['location'] != null) {
      location =
          UserLocation.fromJson(json['location'] as Map<String, dynamic>);
    }
    if (json['active'] != null) {
      active = json['active'] as int;
    }
  }

  static final factory = UserFactory(key: 'uuid');

  bool get isHavePets => currentPets != null && currentPets!.isNotEmpty;

  static User? getUserFromCache({dynamic key}) {
    return factory.getItemWithIdFromCache(key);
  }
}

class UserFactory extends UpdatableModelFactory<User> {
  UserFactory({super.key});

  @override
  User makeFromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
