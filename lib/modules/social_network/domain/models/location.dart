import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class UserLocation {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "long")
  double? long;
  @JsonKey(name: "lat")
  double? lat;
  @JsonKey(name: "updated_at")
  DateTime? updatedAt;

  UserLocation({
    this.id,
    this.name,
    this.long,
    this.lat,
  });

  factory UserLocation.fromJson(Map<String, dynamic> json) => _$UserLocationFromJson(json);

  factory UserLocation.fromJsonString(String jsonString) => UserLocation.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$UserLocationToJson(this);

  String toJsonString() => json.encode(toJson());

  String toPresent() {
    return name ?? "${lat.toString()}, ${lat.toString()}";
  }
}
