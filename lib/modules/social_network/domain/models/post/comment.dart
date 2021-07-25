import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment_tag_user.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

part 'comment.g.dart';

@JsonSerializable(explicitToJson: true)
class Comment {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "content")
  String? content;
  @JsonKey(name: "post_id")
  int? postId;
  @JsonKey(name: "creator_uuid")
  String? creatorUUID;
  @JsonKey(name: "is_liked")
  bool? isLiked;
  @JsonKey(name: "is_my_comment")
  bool? isMyComment;
  @JsonKey(name: "user")
  User? creator;
  @JsonKey(name: "comment_reacts_aggregate", fromJson: Post.aggregateCountFromJson)
  int? commentReactsAggregate;
  @JsonKey(name: "comment_tag_users", fromJson: allUsersFromJson)
  List<User>? commentTagUser;
  @JsonKey(name: "created_at")
  DateTime? createdAt;

  Comment({
    required this.id,
    this.content,
    this.postId,
    this.creatorUUID,
    this.isLiked,
    this.creator,
    this.commentReactsAggregate,
    this.commentTagUser,
    this.createdAt,
  });

  static List<User>? allUsersFromJson(List<dynamic>? list) {
    return list?.map((e) => CommentTagUser.fromJson(e as Map<String, dynamic>).user!).toList();
  }

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  factory Comment.fromJsonString(String jsonString) => Comment.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$CommentToJson(this);

  String toJsonString() => json.encode(toJson());

  @override
  bool operator ==(Object other) => identical(this, other) || other is Comment && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
