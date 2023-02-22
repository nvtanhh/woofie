// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Media _$MediaFromJson(Map<String, dynamic> json) => Media(
      id: json['id'] as int,
      url: Media._parseAvatarUrl(json['url'] as String),
      type: $enumDecodeNullable(_$MediaTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$MediaToJson(Media instance) {
  final val = <String, dynamic>{
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('url', instance.url);
  writeNotNull('type', _$MediaTypeEnumMap[instance.type]);
  return val;
}

const _$MediaTypeEnumMap = {
  MediaType.image: 0,
  MediaType.video: 1,
  MediaType.gif: 2,
};
