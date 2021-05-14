import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meowoof/modules/home_menu/domain/enums/media_type.dart';

part 'medias.g.dart';

@JsonSerializable(explicitToJson: true)
class Medias {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "url")
  String url;
  @JsonKey(name: "type")
  MediaType type;
  @JsonKey(name: "id_post")
  int postId;

  Medias({this.id, this.url, this.type, this.postId});

  factory Medias.fromJson(Map<String, dynamic> json) => _$MediasFromJson(json);

  factory Medias.fromJsonString(String jsonString) => Medias.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$MediasToJson(this);

  String toJsonString() => json.encode(toJson());
}
