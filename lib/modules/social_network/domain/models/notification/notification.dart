import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meowoof/modules/social_network/domain/models/notification/notification_type.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

part 'notification.g.dart';

@JsonSerializable(explicitToJson: true)
class Notification {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "actor_id")
  int? actorId;
  @JsonKey(name: "actor")
  User? actor;
  @JsonKey(name: "owner_id")
  int? ownerId;
  @JsonKey(name: "owner")
  User? owner;
  @JsonKey(name: "post_id")
  int? postId;
  @JsonKey(name: "post")
  Post? post;
  @JsonKey(name: "type")
  NotificationType type;
  @JsonKey(name: "pet_id")
  int? petId;
  @JsonKey(name: "pet")
  Pet? pet;
  @JsonKey(name: "is_read")
  bool? isRead;
  @JsonKey(name: "created_at")
  DateTime? createdAt;

  Notification(
      {required this.id,
      this.actorId,
      this.actor,
      this.postId,
      this.post,
      required this.type,
      this.petId,
      this.pet,
      this.createdAt,
      this.isRead,
      this.owner,
      this.ownerId});

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);

  factory Notification.fromJsonString(String jsonString) => Notification.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);

  String toJsonString() => json.encode(toJson());
}
