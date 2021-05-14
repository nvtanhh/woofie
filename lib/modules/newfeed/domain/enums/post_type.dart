import 'package:json_annotation/json_annotation.dart';

enum PostType {
  @JsonValue(0)
  activity,
  @JsonValue(1)
  adop,
  @JsonValue(2)
  mating,
  @JsonValue(3)
  lose,
}
