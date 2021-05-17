import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meowoof/modules/social_network/domain/models/aggregate/object_aggregate.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/post/medias.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

part 'post.g.dart';

@JsonSerializable(explicitToJson: true)
class Post {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "content")
  String? content;
  @JsonKey(name: "is_closed")
  bool? isClosed;
  @JsonKey(name: "created_at")
  DateTime? createdAt;
  @JsonKey(name: "creator_id")
  int? creatorId;
  @JsonKey(name: "type")
  PostType? type;
  @JsonKey(name: "user")
  User? creator;
  @JsonKey(name: "is_liked")
  bool? isLiked;
  @JsonKey(name: "comments")
  List<Comment>? comments;
  @JsonKey(name: "post_pets")
  List<Pet>? pets;
  @JsonKey(name: "medias")
  List<Media>? medias;
  @JsonKey(name: "post_reacts_aggregate")
  ObjectAggregate? postReactsAggregate;
  @JsonKey(name: "comments_aggregate")
  ObjectAggregate? commentsAggregate;
  @JsonKey(name: "medias_aggregate")
  ObjectAggregate? mediasAggregate;

  Post({
    this.id,
    this.content,
    this.isClosed,
    this.createdAt,
    this.creatorId,
    this.type,
    this.creator,
    this.isLiked,
    this.comments,
    this.pets,
  });

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
