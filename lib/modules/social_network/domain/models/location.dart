import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Location {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "long")
  double? long;
  @JsonKey(name: "lat")
  double? lat;

  Location({
    this.id,
    this.name,
    this.long,
    this.lat,
  });

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

  factory Location.fromJsonString(String jsonString) => Location.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$LocationToJson(this);

  String toJsonString() => json.encode(toJson());
}
