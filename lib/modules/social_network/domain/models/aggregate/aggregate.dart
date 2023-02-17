import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'aggregate.g.dart';

@JsonSerializable(explicitToJson: true)
class Aggregate {
  @JsonKey(name: "count")
  int? count;

  Aggregate({this.count});

  factory Aggregate.fromJson(Map<String, dynamic> json) =>
      _$AggregateFromJson(json);

  factory Aggregate.fromJsonString(String jsonString) =>
      Aggregate.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$AggregateToJson(this);

  String toJsonString() => json.encode(toJson());
}
