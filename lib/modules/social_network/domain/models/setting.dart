import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'setting.g.dart';

@JsonSerializable()
class Setting {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "owner_uuid")
  String? ownerUuid;
  @JsonKey(name: "setting")
  String? setting;
  @JsonKey(name: "created_at")
  DateTime? createdAt;
  @JsonKey(name: "updated_at")
  DateTime? updatedAt;

  Setting({
    required this.id,
    this.ownerUuid,
    this.setting,
    this.createdAt,
    this.updatedAt,
  });

  int statusMessage() {
    if (setting != null || setting?.isNotEmpty == true) {
      return (jsonDecode(setting!.replaceAll("'", '"'))
          as Map<String, dynamic>)["message"] as int;
    }
    return 1;
  }

  bool isEveryoneCanChatWithMe() => statusMessage() == 1;

  factory Setting.fromJson(Map<String, dynamic> json) =>
      _$SettingFromJson(json);

  factory Setting.fromJsonString(String jsonString) =>
      Setting.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$SettingToJson(this);

  String toJsonString() => json.encode(toJson());
}
