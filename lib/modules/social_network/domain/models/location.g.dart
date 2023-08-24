// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLocation _$UserLocationFromJson(Map<String, dynamic> json) => UserLocation(
      id: json['id'] as int?,
      name: json['name'] as String?,
      long: (json['long'] as num?)?.toDouble(),
      lat: (json['lat'] as num?)?.toDouble(),
    )..updatedAt = json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String);

Map<String, dynamic> _$UserLocationToJson(UserLocation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('long', instance.long);
  writeNotNull('lat', instance.lat);
  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  return val;
}
