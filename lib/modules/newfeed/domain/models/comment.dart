import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meowoof/modules/auth/domain/models/user.dart';
import 'package:meowoof/modules/home_menu/domain/models/object_aggregate.dart';

part 'comment.g.dart';

@JsonSerializable(explicitToJson: true)
class Comment {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "content")
  String content;
  @JsonKey(name: "post_id")
  int postId;
  @JsonKey(name: "creator_id")
  int creatorId;
  @JsonKey(name: "ilike")
  bool ilike;
  @JsonKey(name: "user")
  User creator;
  @JsonKey(name: "comment_reacts_aggregate")
  ObjectAggregate commentReactsAggregate;
  Comment(this.id);

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  factory Comment.fromJsonString(String jsonString) => Comment.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$CommentToJson(this);

  String toJsonString() => json.encode(toJson());
}
