// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PetType _$PetTypeFromJson(Map<String, dynamic> json) => PetType(
      id: json['id'] as int,
      name: json['name'] as String?,
      descriptions: json['descriptions'] as String?,
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$PetTypeToJson(PetType instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'descriptions': instance.descriptions,
      'avatar': instance.avatar,
    };
