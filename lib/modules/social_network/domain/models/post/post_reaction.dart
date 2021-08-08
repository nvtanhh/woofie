import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

part 'post_reaction.g.dart';

@JsonSerializable()
class PostReaction {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "reactor_uuid")
  String? creatorUuid;
  @JsonKey(name: "reactor")
  User reactor;
  @JsonKey(name: "post_id")
  int? postId;
  @JsonKey(name: "post")
  Post? post;
  @JsonKey(name: "mating_pet_id")
  int? matingPetId;
  @JsonKey(name: "mating_pet")
  Pet? matingPet;

  PostReaction(
    this.creatorUuid,
    this.reactor,
    this.postId,
    this.post,
    this.matingPetId,
    this.matingPet,
  );

  factory PostReaction.fromJson(Map<String, dynamic> json) =>
      _$PostReactionFromJson(json);

  factory PostReaction.fromJsonString(String jsonString) =>
      PostReaction.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$PostReactionToJson(this);

  String toJsonString() => json.encode(toJson());
}
