import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable(explicitToJson: true)
class Comment {
  @JsonKey(name: "id")
  int id;

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  factory Comment.fromJsonString(String jsonString) => Comment.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$CommentToJson(this);

  String toJsonString() => json.encode(toJson());
}
