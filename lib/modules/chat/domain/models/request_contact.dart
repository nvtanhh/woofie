import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'request_contact.g.dart';

@JsonSerializable()
class RequestContact {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "from_user_uuid")
  String? fromUserUUID;
  @JsonKey(name: "to_user_uuid")
  String? toUserUUID;
  @JsonKey(name: "accept")
  bool? accept;
  @JsonKey(name: "created_at")
  DateTime? createdAt;
  @JsonKey(name: "updated_at")
  DateTime? updatedAt;

  RequestContact({
    required this.id,
    this.fromUserUUID,
    this.toUserUUID,
    this.accept,
    this.createdAt,
    this.updatedAt,
  });

  factory RequestContact.fromJson(Map<String, dynamic> json) => _$RequestContactFromJson(json);

  factory RequestContact.fromJsonString(String jsonString) => RequestContact.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$RequestContactToJson(this);

  String toJsonString() => json.encode(toJson());
}
