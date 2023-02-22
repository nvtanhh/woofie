// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_pet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostPet _$PostPetFromJson(Map<String, dynamic> json) => PostPet(
      id: json['id'] as int?,
      postId: json['postId'] as int?,
      petId: json['petId'] as int?,
      post: json['post'] == null
          ? null
          : Post.fromJson(json['post'] as Map<String, dynamic>),
      pet: json['pet'] == null
          ? null
          : Pet.fromJson(json['pet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PostPetToJson(PostPet instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('postId', instance.postId);
  writeNotNull('petId', instance.petId);
  writeNotNull('post', instance.post?.toJson());
  writeNotNull('pet', instance.pet?.toJson());
  return val;
}
