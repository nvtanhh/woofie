import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meowoof/modules/social_network/domain/models/aggregate/object_aggregate.dart';
import 'package:meowoof/modules/social_network/domain/models/location.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';
import 'package:meowoof/modules/social_network/domain/models/updatable_model.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

part 'post.g.dart';

@JsonSerializable(explicitToJson: true)
class Post extends UpdatableModel<Post> {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "uuid")
  final String uuid;
  @JsonKey(name: "content")
  String? content;
  @JsonKey(name: "is_closed")
  bool? isClosed;
  @JsonKey(name: "created_at")
  DateTime? createdAt;
  @JsonKey(name: "creator_uuid")
  String? creatorUUID;
  @JsonKey(name: "type")
  PostType type;
  @JsonKey(name: "user")
  User? creator;
  @JsonKey(name: "is_liked")
  bool? isLiked;
  @JsonKey(name: "comments")
  List<Comment>? comments;
  @JsonKey(name: "post_pets", fromJson: allPetsFromJson)
  List<Pet>? taggegPets;
  @JsonKey(name: "medias")
  List<Media>? medias;
  @JsonKey(name: "location")
  Location? location;
  @JsonKey(name: "status")
  PostStatus? status;
  @JsonKey(name: "distance_user_to_post")
  double? distanceUserToPost;
  @JsonKey(name: "post_reacts_aggregate", fromJson: aggregateCountFromJson)
  int? postReactsCount;
  @JsonKey(name: "comments_aggregate", fromJson: aggregateCountFromJson)
  int? postCommentsCount;
  @JsonKey(name: "medias_aggregate", fromJson: aggregateCountFromJson)
  int? postMediasCount;

  Post({
    required this.id,
    required this.uuid,
    this.creator,
    required this.type,
    this.creatorUUID,
    this.content,
    this.isClosed,
    this.createdAt,
    this.isLiked,
    this.comments,
    this.taggegPets,
    this.location,
  });

  static List<Pet>? allPetsFromJson(List<dynamic>? list) {
    return list?.map((e) => Pet.fromJson(e["pet"] as Map<String, dynamic>)).toList();
  }

  static int? aggregateCountFromJson(Map? json) {
    if (json == null) return null;
    return ObjectAggregate.fromJson(json as Map<String, dynamic>).aggregate.count;
  }

  void increasePostReactsCount({int value = 1}) {
    postReactsCount = (postReactsCount ?? 0) + value;
  }
  void increasePostCommentsCount({int value = 1}) {
    postCommentsCount = (postCommentsCount ?? 0) + value;
  }
  void increasePostMediasCount({int value = 1}) {
    postMediasCount = (postMediasCount ?? 0) + value;
  }
  void decreasePostReactsCount({int value = 1}) {
    postReactsCount = (postReactsCount ?? 1) - value;
  }
  void decreasePostCommentsCount({int value = 1}) {
    postCommentsCount = (postCommentsCount ?? 1) - value;
  }
  void decreasePostMediasCount({int value = 1}) {
    postMediasCount = (postMediasCount ?? 1) - value;
  }
  factory Post.fromJsonString(String jsonString) => Post.fromJson(json.decode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$PostToJson(this);

  String toJsonString() => json.encode(toJson());

  static final factory = PostFactory();

  factory Post.fromJson(Map<String, dynamic> json) {
    return factory.fromJson(json);
  }

  @override
  void updateFromJson(Map json) {
    if (json['user'] != null) {
      creator = User.fromJson(json['user'] as Map<String, dynamic>);
    }
    if (json['type'] != null) {
      type = _$enumDecode(_$PostTypeEnumMap, json['type']);
    }
    if (json['uuid'] != null) {
      creatorUUID = json['uuid'] as String;
    }
    if (json['creator_uuid'] != null) {
      creatorUUID = json['creator_uuid'] as String;
    }
    if (json['content'] != null) {
      content = json['content'] as String;
    }
    if (json['is_closed'] != null) {
      isClosed = json['is_closed'] as bool;
    }
    if (json['created_at'] != null) {
      createdAt = DateTime.parse(json['created_at'] as String);
    }
    if (json['is_liked'] != null) {
      isLiked = json['is_liked'] as bool;
    }
    if (json['comments'] != null) {
      comments = (json['comments'] as List<dynamic>?)?.map((e) => Comment.fromJson(e as Map<String, dynamic>)).toList();
    }
    if (json['post_pets'] != null) {
      taggegPets = allPetsFromJson(json['post_pets'] as List?);
    }
    if (json['status'] != null) {
      status = _$enumDecodeNullable(_$PostStatusEnumMap, json['status']);
    }
    if (json['location'] != null) {
      location = Location.fromJson(json['location'] as Map<String, dynamic>);
    }
    if (json['medias'] != null) {
      medias = (json['medias'] as List<dynamic>?)?.map((e) => Media.fromJson(e as Map<String, dynamic>)).toList();
    }
    if (json['distance_user_to_post'] != null) {
      distanceUserToPost = json['distance_user_to_post'] as double;
    }
    if (json['post_reacts_aggregate'] != null) {
      postReactsCount = aggregateCountFromJson(json["post_reacts_aggregate"] as Map<String, dynamic>);
    }
    if (json['comments_aggregate'] != null) {
      postCommentsCount = aggregateCountFromJson(json["comments_aggregate"] as Map<String, dynamic>);
    }
    if (json['medias_aggregate'] != null) {
      postMediasCount = aggregateCountFromJson(json["medias_aggregate"] as Map<String, dynamic>);
    }
  }
}

class PostFactory extends UpdatableModelFactory<Post> {
  @override
  Post makeFromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}

enum PostType {
  @JsonValue(0)
  activity,
  @JsonValue(1)
  adop,
  @JsonValue(2)
  mating,
  @JsonValue(3)
  lose,
}

enum PostStatus {
  @JsonValue(0)
  draft,
  @JsonValue(1)
  published,
}

// class PostStatus {
//   final String code;

//   const PostStatus._internal(this.code);

//   @override
//   String toString() => code;

//   static const draft = PostStatus._internal('D');
//   static const published = PostStatus._internal('P');

//   static const _values = <PostStatus>[draft, published];

//   static List<PostStatus> values() => _values;

//   static PostStatus? parse(String? code) {
//     if (code == null) return null;

//     PostStatus? postStatus;
//     for (final type in _values) {
//       if (code == type.code) {
//         postStatus = type;
//         break;
//       }
//     }

//     if (postStatus == null) {
//       // ignore: avoid_print
//       print('Unsupported post status type: $code');
//     }

//     return postStatus;
//   }
// }
