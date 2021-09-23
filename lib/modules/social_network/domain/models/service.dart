import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meowoof/modules/social_network/domain/models/location.dart';

part 'service.g.dart';

@JsonSerializable(explicitToJson: true)
class Service {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "logo")
  String? logo;
  @JsonKey(name: "phone_number")
  String? phoneNumber;
  @JsonKey(name: "social_contact")
  String? socialContact;
  @JsonKey(name: "website")
  String? website;
  @JsonKey(name: "location_id")
  int? locationId;
  @JsonKey(name: "description")
  String? description;
  @JsonKey(name: "google_map_link")
  String? googleMapLink;
  @JsonKey(name: "location")
  UserLocation? location;

  Service({
    required this.id,
    this.name,
    this.logo,
    this.phoneNumber,
    this.socialContact,
    this.website,
    this.locationId,
    this.googleMapLink,
    this.location,
    this.description
  });
  factory Service.fromJson(Map<String, dynamic> json) => _$ServiceFromJson(json);

  factory Service.fromJsonString(String jsonString) => Service.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$ServiceToJson(this);

  String toJsonString() => json.encode(toJson());
}
