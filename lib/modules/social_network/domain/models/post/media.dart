import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meowoof/configs/backend_config.dart';

part 'media.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Media {
  @JsonKey(name: "id")
  int id;
  @JsonKey(
    name: "url",
    fromJson: _parseAvatarUrl,
    includeIfNull: false,
  )
  String? url;
  @JsonKey(name: "type")
  MediaType? type;

  Media({
    required this.id,
    this.url,
    this.type,
  });

  static String _parseAvatarUrl(String url) {
    if (url.startsWith("http")) {
      return url;
    }
    var finalUrl = url;
    if (!url.startsWith('/')) {
      finalUrl = '/$url';
    }
    return BackendConfig.S3_URL + finalUrl;
  }

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);

  factory Media.fromJsonString(String jsonString) =>
      Media.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$MediaToJson(this);

  String toJsonString() => json.encode(toJson());

  bool get isVideo => type == MediaType.video;

  bool get isImage => type == MediaType.image;
}

enum MediaType {
  @JsonValue(0)
  image,
  @JsonValue(1)
  video,
  @JsonValue(2)
  gif
}
