import 'package:json_annotation/json_annotation.dart';

enum NotificationType {
  @JsonValue(0)
  react,
  @JsonValue(1)
  follow,
  @JsonValue(2)
  comment,
  @JsonValue(3)
  adoption,
  @JsonValue(4)
  matting,
  @JsonValue(5)
  lose
}
