import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'service.g.dart';

@JsonSerializable(explicitToJson: true)
class Service {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "logo")
  String? logo;

  Service({
    required this.id,
    this.name,
    this.logo,
  });

  factory Service.fromJson(Map<String, dynamic> json) => _$ServiceFromJson(json);

  factory Service.fromJsonString(String jsonString) => Service.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$ServiceToJson(this);

  String toJsonString() => json.encode(toJson());
}
