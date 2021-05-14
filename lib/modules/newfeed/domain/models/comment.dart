import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meowoof/modules/auth/domain/models/user.dart';
import 'package:meowoof/modules/home_menu/domain/models/object_aggregate.dart';
import 'package:meowoof/modules/newfeed/domain/models/comment_tag_user.dart';

part 'comment.g.dart';

@JsonSerializable(explicitToJson: true)
class Comment {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "content")
  String? content;
  @JsonKey(name: "post_id")
  int? postId;
  @JsonKey(name: "creator_id")
  int? creatorId;
  @JsonKey(name: "is_liked")
  bool? isLiked;
  @JsonKey(name: "user")
  User? creator;
  @JsonKey(name: "comment_reacts_aggregate")
  ObjectAggregate? commentReactsAggregate;
  @JsonKey(name: "comment_tag_users")
  List<CommentTagUser>? commentTagUser;
  @JsonKey(name: "created_at")
  DateTime? createdAt;

  Comment({
    this.id,
    this.content,
    this.postId,
    this.creatorId,
    this.isLiked,
    this.creator,
    this.commentReactsAggregate,
    this.commentTagUser,
    this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  factory Comment.fromJsonString(String jsonString) => Comment.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$CommentToJson(this);

  String toJsonString() => json.encode(toJson());
}
