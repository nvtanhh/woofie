// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestContact _$RequestContactFromJson(Map<String, dynamic> json) =>
    RequestContact(
      id: json['id'] as int,
      fromUserUUID: json['from_user_uuid'] as String?,
      fromUser: json['from_user'] == null
          ? null
          : User.fromJson(json['from_user'] as Map<String, dynamic>),
      toUserUUID: json['to_user_uuid'] as String?,
      toUser: json['to_user'] == null
          ? null
          : User.fromJson(json['to_user'] as Map<String, dynamic>),
      status:
          $enumDecodeNullable(_$RequestContactStatusEnumMap, json['status']),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    )..content = json['content'] as String?;

Map<String, dynamic> _$RequestContactToJson(RequestContact instance) =>
    <String, dynamic>{
      'id': instance.id,
      'from_user_uuid': instance.fromUserUUID,
      'from_user': instance.fromUser,
      'to_user_uuid': instance.toUserUUID,
      'to_user': instance.toUser,
      'content': instance.content,
      'status': _$RequestContactStatusEnumMap[instance.status],
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$RequestContactStatusEnumMap = {
  RequestContactStatus.waiting: 0,
  RequestContactStatus.accept: 1,
  RequestContactStatus.deny: 2,
};
