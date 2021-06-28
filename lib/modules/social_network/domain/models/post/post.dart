import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meowoof/modules/social_network/domain/models/aggregate/object_aggregate.dart';
import 'package:meowoof/modules/social_network/domain/models/location.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

part 'post.g.dart';

@JsonSerializable(explicitToJson: true)
class Post {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "content")
  String? content;
  @JsonKey(name: "is_closed")
  bool? isClosed;
  @JsonKey(name: "created_at")
  DateTime? createdAt;
  @JsonKey(name: "creator_uuid")
  String? creatorUUID;
  @JsonKey(name: "type")
  PostType type;
  @JsonKey(name: "user")
  User? creator;
  @JsonKey(name: "is_liked")
  bool? isLiked;
  @JsonKey(name: "comments")
  List<Comment>? comments;
  @JsonKey(name: "post_pets", fromJson: allPetsFromJson)
  List<Pet>? pets;
  @JsonKey(name: "medias")
  List<Media>? medias;
  @JsonKey(name: "location_post")
  Location? location;
  @JsonKey(name: "post_reacts_aggregate")
  ObjectAggregate? postReactsAggregate;
  Post({
    required this.id,
    this.creator,
    required this.type,
    this.creatorUUID,
    this.content,
    this.isClosed,
    this.createdAt,
    this.isLiked,
    this.comments,
    this.pets,
    this.location,
  });
  static List<Pet>? allPetsFromJson(List<dynamic>? list) {
    return list?.map((e) => Pet.fromJson(e["pet"] as Map<String, dynamic>)).toList();
  }

  @JsonKey(name: "comments_aggregate")
  ObjectAggregate? commentsAggregate;

  @JsonKey(name: "medias_aggregate")
  ObjectAggregate? mediasAggregate;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  factory Post.fromJsonString(String jsonString) => Post.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$PostToJson(this);

  String toJsonString() => json.encode(toJson());
}

enum PostType {
  @JsonValue(0)
  activity,
  @JsonValue(1)
  adop,
  @JsonValue(2)
  mating,
  @JsonValue(3)
  lose,
}
