// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      id: json['id'] as int,
      actorId: json['actor_id'] as int?,
      actor: json['actor'] == null
          ? null
          : User.fromJson(json['actor'] as Map<String, dynamic>),
      postId: json['post_id'] as int?,
      post: json['post'] == null
          ? null
          : Post.fromJson(json['post'] as Map<String, dynamic>),
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      petId: json['pet_id'] as int?,
      pet: json['pet'] == null
          ? null
          : Pet.fromJson(json['pet'] as Map<String, dynamic>),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      isRead: json['is_read'] as bool?,
      owner: json['owner'] == null
          ? null
          : User.fromJson(json['owner'] as Map<String, dynamic>),
      ownerId: json['owner_id'] as int?,
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'actor_id': instance.actorId,
      'actor': instance.actor?.toJson(),
      'owner_id': instance.ownerId,
      'owner': instance.owner?.toJson(),
      'post_id': instance.postId,
      'post': instance.post?.toJson(),
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'pet_id': instance.petId,
      'pet': instance.pet?.toJson(),
      'is_read': instance.isRead,
      'created_at': instance.createdAt?.toIso8601String(),
    };

const _$NotificationTypeEnumMap = {
  NotificationType.react: 0,
  NotificationType.follow: 1,
  NotificationType.comment: 2,
  NotificationType.adoption: 3,
  NotificationType.matting: 4,
  NotificationType.lose: 5,
  NotificationType.commentTagUser: 6,
  NotificationType.reactComment: 7,
  NotificationType.requestMessage: 8,
};
