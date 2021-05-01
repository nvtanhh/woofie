import 'package:json_annotation/json_annotation.dart';

enum Gender {
  @JsonValue(1)
  male,
  @JsonValue(2)
  female,
  @JsonValue(3)
  unknown,
}
