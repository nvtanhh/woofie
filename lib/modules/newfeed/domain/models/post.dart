import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meowoof/modules/add_pet/domain/models/pet.dart';
import 'package:meowoof/modules/auth/domain/models/user.dart';
import 'package:meowoof/modules/home_menu/domain/models/medias.dart';
import 'package:meowoof/modules/home_menu/domain/models/object_aggregate.dart';
import 'package:meowoof/modules/newfeed/domain/enums/post_type.dart';
import 'package:meowoof/modules/newfeed/domain/models/comment.dart';

part 'post.g.dart';

@JsonSerializable(explicitToJson: true)
class Post {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "content")
  String content;
  @JsonKey(name: "is_closed")
  bool isClosed;
  @JsonKey(name: "created_at")
  DateTime createdAt;
  @JsonKey(name: "creator_id")
  int creatorId;
  @JsonKey(name: "type")
  PostType type;
  @JsonKey(name: "user")
  User creator;
  @JsonKey(name: "is_liked")
  bool isLiked;
  @JsonKey(name: "comments")
  List<Comment> comments;
  @JsonKey(name: "post_pets")
  List<Pet> pets;
  @JsonKey(name: "medias")
  List<Medias> medias;
  @JsonKey(name: "post_reacts_aggregate")
  ObjectAggregate postReactsAggregate;
  @JsonKey(name: "comments_aggregate")
  ObjectAggregate commentsAggregate;
  @JsonKey(name: "medias_aggregate")
  ObjectAggregate mediasAggregate;

  Post({this.id, this.content, this.isClosed, this.createdAt, this.creatorId, this.type, this.creator, this.isLiked, this.comments, this.pets});

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  factory Post.fromJsonString(String jsonString) => Post.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$PostToJson(this);

  String toJsonString() => json.encode(toJson());
}
