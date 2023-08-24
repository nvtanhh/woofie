// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_worm_flushed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PetWormFlushed _$PetWormFlushedFromJson(Map<String, dynamic> json) =>
    PetWormFlushed(
      id: json['id'] as int,
      description: json['description'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      petId: json['pet_id'] as int?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PetWormFlushedToJson(PetWormFlushed instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pet_id': instance.petId,
      'description': instance.description,
      'date': instance.date?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
