import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

part 'comment_tag_user.g.dart';

@JsonSerializable(explicitToJson: true)
class CommentTagUser {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "comment_id")
  int? commentId;
  @JsonKey(name: "user_id")
  int? userId;
  @JsonKey(name: "comment")
  Comment? comment;
  @JsonKey(name: "user")
  User? user;

  CommentTagUser({
    this.id,
    this.commentId,
    this.userId,
    this.comment,
    this.user,
  });

  factory CommentTagUser.fromJson(Map<String, dynamic> json) => _$CommentTagUserFromJson(json);

  factory CommentTagUser.fromJsonString(String jsonString) => CommentTagUser.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$CommentTagUserToJson(this);

  String toJsonString() => json.encode(toJson());
}
