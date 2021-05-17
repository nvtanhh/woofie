import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'medias.g.dart';

@JsonSerializable(explicitToJson: true)
class Media {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "url")
  String? url;
  @JsonKey(name: "type")
  MediaType? type;
  @JsonKey(name: "id_post")
  int? postId;

  Media({
    this.id,
    this.url,
    this.type,
    this.postId,
  });

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);

  factory Media.fromJsonString(String jsonString) => Media.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$MediaToJson(this);

  String toJsonString() => json.encode(toJson());
}

enum MediaType {
  @JsonValue(0)
  image,
  @JsonValue(1)
  video,
  @JsonValue(2)
  gif
}
