// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int,
      uuid: json['uuid'] as String,
      name: json['name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      email: json['email'] as String?,
      currentPets: (json['current_pets'] as List<dynamic>?)
          ?.map((e) => Pet.fromJson(e as Map<String, dynamic>))
          .toList(),
      avatar: json['avatar'] == null
          ? null
          : Media.fromJson(json['avatar'] as Map<String, dynamic>),
      bio: json['bio'] as String?,
      dob: json['dob'] == null ? null : DateTime.parse(json['dob'] as String),
      avatarUrl: json['avatar_url'] as String?,
      active: json['active'] as int?,
    )
      ..allPets = User.allPetsFromJson(json['all_pets'] as List?)
      ..locationId = json['location_id'] as int?
      ..location = json['location'] == null
          ? null
          : UserLocation.fromJson(json['location'] as Map<String, dynamic>)
      ..setting = json['setting'] == null
          ? null
          : Setting.fromJson(json['setting'] as Map<String, dynamic>);

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'uuid': instance.uuid,
    'name': instance.name,
    'bio': instance.bio,
    'phone_number': instance.phoneNumber,
    'email': instance.email,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'current_pets', instance.currentPets?.map((e) => e.toJson()).toList());
  writeNotNull('all_pets', instance.allPets?.map((e) => e.toJson()).toList());
  val['avatar'] = instance.avatar?.toJson();
  val['avatar_url'] = instance.avatarUrl;
  val['dob'] = instance.dob?.toIso8601String();
  val['location_id'] = instance.locationId;
  val['location'] = instance.location?.toJson();
  val['setting'] = instance.setting?.toJson();
  val['active'] = instance.active;
  return val;
}
