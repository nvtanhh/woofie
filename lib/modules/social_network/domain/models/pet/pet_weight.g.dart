// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_weight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PetWeight _$PetWeightFromJson(Map<String, dynamic> json) => PetWeight(
      id: json['id'] as int,
      weight: (json['weight'] as num?)?.toDouble(),
      description: json['description'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    )..petId = json['pet_id'] as int?;

Map<String, dynamic> _$PetWeightToJson(PetWeight instance) => <String, dynamic>{
      'id': instance.id,
      'pet_id': instance.petId,
      'weight': instance.weight,
      'description': instance.description,
      'date': instance.date?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
