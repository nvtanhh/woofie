import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'aggregate.dart';

part 'object_aggregate.g.dart';

@JsonSerializable(explicitToJson: true)
class ObjectAggregate {
  @JsonKey(name: "aggregate")
  Aggregate aggregate;

  ObjectAggregate({
    required this.aggregate,
  });

  factory ObjectAggregate.fromJson(Map<String, dynamic> json) =>
      _$ObjectAggregateFromJson(json);

  factory ObjectAggregate.fromJsonString(String jsonString) =>
      ObjectAggregate.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$ObjectAggregateToJson(this);

  String toJsonString() => json.encode(toJson());
}
