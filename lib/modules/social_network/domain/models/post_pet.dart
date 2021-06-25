import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
part 'post_pet.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class PostPet {
  int? id;
  int? postId;
  int? petId;
  List<Post>? posts;
  List<Pet>? pets;

  PostPet({
    this.id,
    this.postId,
    this.petId,
    this.posts,
    this.pets,
  });
  factory PostPet.fromJson(Map<String, dynamic> json) => _$PostPetFromJson(json);

  factory PostPet.fromJsonString(String jsonString) => PostPet.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$PostPetToJson(this);

  String toJsonString() => json.encode(toJson());
}
