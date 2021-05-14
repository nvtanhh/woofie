import 'package:json_annotation/json_annotation.dart';

enum MediaType {
  @JsonValue(0)
  image,
  @JsonValue(1)
  video,
  @JsonValue(2)
  gif
}
