// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_breed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PetBreed _$PetBreedFromJson(Map<String, dynamic> json) => PetBreed(
      id: json['id'] as int,
      petTypeId: json['id_pet_type'] as int?,
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$PetBreedToJson(PetBreed instance) => <String, dynamic>{
      'id': instance.id,
      'id_pet_type': instance.petTypeId,
      'name': instance.name,
      'avatar': instance.avatar,
    };
