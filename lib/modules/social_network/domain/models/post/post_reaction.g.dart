// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostReaction _$PostReactionFromJson(Map<String, dynamic> json) => PostReaction(
      json['reactor_uuid'] as String?,
      User.fromJson(json['reactor'] as Map<String, dynamic>),
      json['post_id'] as int?,
      json['post'] == null
          ? null
          : Post.fromJson(json['post'] as Map<String, dynamic>),
      json['mating_pet_id'] as int?,
      json['mating_pet'] == null
          ? null
          : Pet.fromJson(json['mating_pet'] as Map<String, dynamic>),
    )..id = json['id'] as int?;

Map<String, dynamic> _$PostReactionToJson(PostReaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reactor_uuid': instance.creatorUuid,
      'reactor': instance.reactor,
      'post_id': instance.postId,
      'post': instance.post,
      'mating_pet_id': instance.matingPetId,
      'mating_pet': instance.matingPet,
    };
