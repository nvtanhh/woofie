// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: json['id'] as int,
      uuid: json['uuid'] as String,
      type: $enumDecode(_$PostTypeEnumMap, json['type']),
      creator: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      creatorUUID: json['creator_uuid'] as String?,
      content: json['content'] as String?,
      isClosed: json['is_closed'] as bool?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      isLiked: json['is_liked'] as bool?,
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
      taggegPets: json['post_pets'] == null
          ? const []
          : Post.allPetsFromJson(json['post_pets'] as List?),
      location: json['location'] == null
          ? null
          : UserLocation.fromJson(json['location'] as Map<String, dynamic>),
      additionalData: json['additional_data'] as String?,
    )
      ..reactionsCounts = json['reactions_counts'] as int?
      ..medias = (json['medias'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList()
      ..status = $enumDecodeNullable(_$PostStatusEnumMap, json['status'])
      ..distanceUserToPost = (json['distance_user_to_post'] as num?)?.toDouble()
      ..postReactsCount =
          Post.aggregateCountFromJson(json['post_reacts_aggregate'] as Map?)
      ..postCommentsCount =
          Post.aggregateCountFromJson(json['comments_aggregate'] as Map?)
      ..postMediasCount =
          Post.aggregateCountFromJson(json['medias_aggregate'] as Map?)
      ..reactors = Post.reactorsFromJson(json['post_reacts'] as List?);

Map<String, dynamic> _$PostToJson(Post instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'uuid': instance.uuid,
    'content': instance.content,
    'is_closed': instance.isClosed,
    'created_at': instance.createdAt?.toIso8601String(),
    'creator_uuid': instance.creatorUUID,
    'type': _$PostTypeEnumMap[instance.type]!,
    'user': instance.creator?.toJson(),
    'is_liked': instance.isLiked,
    'reactions_counts': instance.reactionsCounts,
    'comments': instance.comments?.map((e) => e.toJson()).toList(),
    'post_pets': Post.allPetsToJson(instance.taggegPets),
    'medias': instance.medias?.map((e) => e.toJson()).toList(),
    'location': instance.location?.toJson(),
    'status': _$PostStatusEnumMap[instance.status],
    'distance_user_to_post': instance.distanceUserToPost,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('post_reacts_aggregate', instance.postReactsCount);
  writeNotNull('comments_aggregate', instance.postCommentsCount);
  writeNotNull('medias_aggregate', instance.postMediasCount);
  writeNotNull(
      'post_reacts', instance.reactors?.map((e) => e.toJson()).toList());
  val['additional_data'] = instance.additionalData;
  return val;
}

const _$PostTypeEnumMap = {
  PostType.activity: 0,
  PostType.adop: 1,
  PostType.mating: 2,
  PostType.lose: 3,
};

const _$PostStatusEnumMap = {
  PostStatus.draft: 0,
  PostStatus.published: 1,
};
