// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_tag_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentTagUser _$CommentTagUserFromJson(Map<String, dynamic> json) =>
    CommentTagUser(
      id: json['id'] as int?,
      commentId: json['comment_id'] as int?,
      userId: json['user_id'] as int?,
      comment: json['comment'] == null
          ? null
          : Comment.fromJson(json['comment'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CommentTagUserToJson(CommentTagUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'comment_id': instance.commentId,
      'user_id': instance.userId,
      'comment': instance.comment?.toJson(),
      'user': instance.user?.toJson(),
    };
