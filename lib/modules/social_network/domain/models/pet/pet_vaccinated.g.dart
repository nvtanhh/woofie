// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_vaccinated.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PetVaccinated _$PetVaccinatedFromJson(Map<String, dynamic> json) =>
    PetVaccinated(
      id: json['id'] as int,
      description: json['description'] as String?,
      name: json['vaccine_name'] as String?,
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

Map<String, dynamic> _$PetVaccinatedToJson(PetVaccinated instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pet_id': instance.petId,
      'vaccine_name': instance.name,
      'description': instance.description,
      'date': instance.date?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
