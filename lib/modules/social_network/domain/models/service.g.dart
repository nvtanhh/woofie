// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Service _$ServiceFromJson(Map<String, dynamic> json) => Service(
      id: json['id'] as int,
      name: json['name'] as String?,
      logo: json['logo'] as String?,
      phoneNumber: json['phone_number'] as String?,
      socialContact: json['social_contact'] as String?,
      website: json['website'] as String?,
      locationId: json['location_id'] as int?,
      googleMapLink: json['google_map_link'] as String?,
      location: json['location'] == null
          ? null
          : UserLocation.fromJson(json['location'] as Map<String, dynamic>),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$ServiceToJson(Service instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logo': instance.logo,
      'phone_number': instance.phoneNumber,
      'social_contact': instance.socialContact,
      'website': instance.website,
      'location_id': instance.locationId,
      'description': instance.description,
      'google_map_link': instance.googleMapLink,
      'location': instance.location?.toJson(),
    };
