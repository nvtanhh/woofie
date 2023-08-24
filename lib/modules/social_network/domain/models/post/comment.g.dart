// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as int,
      content: json['content'] as String?,
      postId: json['post_id'] as int?,
      creatorUUID: json['creator_uuid'] as String?,
      isLiked: json['is_liked'] as bool?,
      creator: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      commentReactsAggregate:
          Post.aggregateCountFromJson(json['comment_reacts_aggregate'] as Map?),
      commentTagUser:
          Comment.allUsersFromJson(json['comment_tag_users'] as List?),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    )..isMyComment = json['is_my_comment'] as bool?;

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'post_id': instance.postId,
      'creator_uuid': instance.creatorUUID,
      'is_liked': instance.isLiked,
      'is_my_comment': instance.isMyComment,
      'user': instance.creator?.toJson(),
      'comment_reacts_aggregate': instance.commentReactsAggregate,
      'comment_tag_users':
          instance.commentTagUser?.map((e) => e.toJson()).toList(),
      'created_at': instance.createdAt?.toIso8601String(),
    };
