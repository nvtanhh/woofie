import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/get_map_from_hasura.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post_reaction.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:meowoof/modules/social_network/domain/models/post/new_post_data.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/post/updated_post_data.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class PostDatasource {
  final HasuraConnect _hasuraConnect;
  final LoggedInUser _loggedInUser;
  User? user;

  PostDatasource(this._hasuraConnect, this._loggedInUser);

  Future<List<Post>> getPosts(
      {int limit = 10, int offset = 0, DateTime? lastValue}) async {
    await Future.delayed(const Duration(seconds: 1));
    return <Post>[];
  }

  Future<List<Comment>> getCommentsInPost(
      int postId, int limit, int offset) async {
    user = _loggedInUser.user;
    final query = """
    query MyQuery {
      comments(where: {post_id: {_eq: $postId}}, order_by: {created_at: desc}, offset: $offset, limit: $limit) {
        comment_reacts_aggregate {
          aggregate {
            count
          }
        }
        comment_tag_users {
          user {
            name
            uuid
            id
          }
        }
        content
        id
        is_liked
        created_at
        post_id
        user {
          avatar_url
          id
          name
          uuid
        }
      }
    }
    """;
    final data = await _hasuraConnect.query(query);
    final listPost = GetMapFromHasura.getMap(data as Map)["comments"] as List;
    Comment comment;
    return listPost.map((e) {
      comment = Comment.fromJson(e as Map<String, dynamic>);
      comment.isMyComment = comment.creator!.uuid == user!.uuid;
      return comment;
    }).toList();
  }

  Future<bool> likePost(int idPost) async {
    final mutation = """
    mutation MyMutation {
      likePost(post_id: $idPost) {
        id
      }
    }
    """;
    final data = await _hasuraConnect.mutation(mutation);
    final affectedRows =
        GetMapFromHasura.getMap(data as Map)["likePost"] as Map;
    return int.tryParse("${affectedRows["id"]}") != null;
  }

  Future<List<Post>> getPostsTimeline(int offset, int limit,
      {String? userUUID}) async {
    final String userFilter =
        (userUUID != null) ? 'where: {creator_uuid: {_eq: "$userUUID"}}, ' : '';

    final query = """
    query MyQuery {
      posts(limit: $limit, offset: $offset, $userFilter order_by: {created_at: desc}) {
        content
        created_at
        creator_uuid
        id
        uuid
        is_liked
        reactions_counts
        medias {
          id
          type
          url
        }
        type
        post_reacts_aggregate {
          aggregate {
            count
          }
        }
        comments_aggregate {
          aggregate {
            count
          }
        }
        post_pets {
          pet {
            id
            name
            avatar_url
            bio
            dob
            gender
          }
        }
        user {
          bio
          id
          name
          avatar_url
          uuid
        }
        location {
          id
          lat
          long
          name
        }
      }
    }
    """;
    final data = await _hasuraConnect.query(query);
    final listPost = GetMapFromHasura.getMap(data as Map)["posts"] as List;
    return listPost
        .map((e) => Post.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Post>> getPostsOfPet(int petId, int offset, int limit) async {
    final query = """
  query MyQuery {
  posts(limit: $limit, offset: $offset, where: {post_pets: {pet_id: {_eq: $petId}}}, order_by: {created_at: asc}) {
  content created_at creator_uuid id is_closed is_liked is_my_post reactions_counts uuid
  medias { id type url }
  post_reacts_aggregate { aggregate { count } } 
  type post_pets { pet { name id dob gender } }
  comments_aggregate { aggregate { count } }
  user { uuid name id }
   } }
    """;
    final data = await _hasuraConnect.query(query);
    final listPost = GetMapFromHasura.getMap(data as Map)["posts"] as List;
    return listPost
        .map((e) => Post.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Post> createPost(Post post) async {
    final listPetTag =
        post.taggegPets?.map((e) => {"pet_id": e.id}).toList() ?? [];
    final location = post.location == null
        ? ""
        : 'location: {data: {long: "${post.location?.long}", lat: "${post.location?.lat}", name: "${post.location?.name ?? ""}"}},';
    final manution = """
    mutation MyMutation {
      insert_posts_one(object: {content: "${post.content?.trim()}",$location medias: {data: ${post.medias?.toString() ?? "[]"}}, type: "${post.type.index}", post_pets: {data: $listPetTag}}) {
        content
        created_at
        distance_user_to_post
        id
        medias {
          id
          type
          url
        }
        status
        type
      }
    }
    """;
    final data = await _hasuraConnect.mutation(manution);
    final affectedRows =
        GetMapFromHasura.getMap(data as Map)["insert_posts_one"] as Map;
    return Post.fromJson(affectedRows as Map<String, dynamic>);
  }

  Future<bool> deletePost(int idPost) async {
    final manution = """
    mutation MyMutation {
      delete_posts_by_pk(id: $idPost) {
        id
      }
    }
    """;
    await _hasuraConnect.mutation(manution);
    return true;
  }

  Future<List<Post>> getPostByType(
    PostType postType,
    double longUser,
    double latUser,
    int limit,
    int offset,
  ) async {
    final query = """
    query MyQuery {
  posts(limit: $limit, offset: $offset,  where: {_and: {type: {_eq: "${postType.index}"}, is_closed: {_eq: false}}}, order_by: {created_at: desc}) {
    id
    type
    uuid
    location {
      id
      lat
      long
    }
    post_pets {
      pet {
        avatar_url
        pet_breed {
          name
          id
        }
        id
        name
        dob
        gender
      }
    }
    is_closed
  }
}

    """;
    // final query = """
    // query MyQuery {
    //   get_posts_by_type(args: {post_type: ${postType.index},long_user: $longUser,lat_user: $latUser , mlimit: $limit, moffset: $offset }, order_by: {created_at: desc},) {
    //     id
    //     type
    //     uuid
    //     location {
    //       id
    //       lat
    //       long
    //     }
    //     post_pets {
    //       pet {
    //         avatar_url
    //         pet_breed {
    //           name
    //           id
    //         }
    //         id
    //         dob
    //         gender
    //         name
    //       }
    //     }
    //     is_closed
    //   }
    // }
    // """;

    final data = await _hasuraConnect.query(query);
    final listPost = GetMapFromHasura.getMap(data as Map)["posts"] as List;
    return listPost
        .map((e) => Post.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> getDetailPost(int postId) async {
    final query = """
    query getPostDetail {
      posts_by_pk(id: $postId) {
        id
        uuid
        content
        type
        medias {
          id
          url
          type
        }
        user {
          id
          uuid
          name
          avatar_url
        }
        post_pets {
          pet {
            id
            name
            avatar_url
            dob
            pet_type {
              id
              name
            }
            pet_breed{
              id
              name
            }
          }
        }
        location {
          id
          lat
          long
          name
        }
        post_reacts_aggregate {
          aggregate {
            count
          }
        }
        comments_aggregate {
          aggregate {
            count
          }
        }
        created_at
        is_closed
        additional_data
      }
    }
    """;
    final data = await _hasuraConnect.query(query);
    return GetMapFromHasura.getMap(data as Map)["posts_by_pk"]
        as Map<String, dynamic>;
  }

  Future<Post> createDraftPost(NewPostData newPostData) async {
    const draftPostStatus = 0;

    final taggedPets =
        newPostData.taggegPets?.map((e) => {"pet_id": e.id}).toList() ?? [];

    final location = newPostData.location == null
        ? ""
        : 'location: {data: {long: "${newPostData.location?.long}", lat: "${newPostData.location?.lat}", name: "${newPostData.location?.name}"}},';

    final String manution = """
    mutation MyMutation {
      insert_posts_one(object: {uuid: "${newPostData.newPostUuid}", content: "${newPostData.content}", type: ${newPostData.type.index}, $location status: $draftPostStatus, post_pets: {data: $taggedPets}}) {
        id
        uuid
        content
        type
        status
        creator_uuid 
        location {
          id
          lat
          long
          name
        }
      }
    }
    """;

    final data = await _hasuraConnect.mutation(manution);
    final jsonBody =
        GetMapFromHasura.getMap(data as Map)["insert_posts_one"] as Map;
    return Post.fromJson(jsonBody as Map<String, dynamic>);
  }

  Future<Post?> publishPost(int postId) async {
    final String query = """
    mutation MyMutation {
      update_posts_by_pk(pk_columns: {id: $postId}, _set: {status: 1}) {
        id
        uuid
        content
        type
        medias {
          id
          url
          type
        }
        user {
          id
          uuid
          name
          avatar_url
        }
        post_pets {
          pet {
            id
            name
            dob
            gender
            avatar_url
          }
        }
        location {
          id
          lat
          long
          name
        }
        created_at
        is_closed
      }
    }
    """;
    final data = await _hasuraConnect.mutation(query);
    final postJson =
        GetMapFromHasura.getMap(data as Map)["update_posts_by_pk"] as Map;
    return Post.fromJson(postJson as Map<String, dynamic>);
  }

  Future<PostStatus?> getPostStatusWithId(int postId) async {}

  Future<Post?> getPostWithId(int postId) async {}

  Future<bool> editPost(EditedPostData editedPostData) async {
    final mediasData = editedPostData.newAddedMedias
            ?.map((e) => _mediaToJson(e))
            .toList()
            .toString() ??
        "[]";

    final location = editedPostData.location == null
        ? ""
        : 'location: {long: "${editedPostData.location?.long}", lat: "${editedPostData.location?.lat}", name: "${editedPostData.location?.name}"},';

    final String query = """
    mutation EditPost {
      editPost(originPostId: ${editedPostData.originPost.id}, newContent: "${editedPostData.newContent}", newTaggedPetIds: ${editedPostData.newTaggedPetIds.toString()}, deletedTaggedPetIds: ${editedPostData.deletedTaggedPetIds.toString()}, deletedMediaIds: ${editedPostData.deletedMediaIds.toString()}, newAddedMedias: $mediasData, $location) {
          status
      }
    }
    """;

    await _hasuraConnect.mutation(query);
    return true;
  }

  String _mediaToJson(UploadedMedia e) {
    return '{url: "${e.uploadedUrl}", type: ${e.type}}';
  }

  Future reportPost(Post post, String content) async {
    final manution = """
    mutation MyMutation {
    insert_report_post(objects: {content: "$content", post_id: ${post.id}, type: 0}) {
    affected_rows
    }
    }
    """;
    final data = await _hasuraConnect.mutation(manution);
    GetMapFromHasura.getMap(data as Map)["insert_report_post"] as Map;
    return;
  }

  Future<bool> reactFunctionalPost(int postId, int? matingPetId) async {
    final String mating =
        matingPetId == null ? "" : ", mating_pet_id: $matingPetId,";
    final String mutation = """
    mutation MyMutation {
      insert_post_reacts_one(object: {post_id: $postId$mating}, on_conflict: {constraint: post_reacts_reactor_uuid_post_id_mating_pet_id_key, update_columns: []}) {
        id
      }
    }
    """;
    await _hasuraConnect.mutation(mutation);
    return true;
  }

  Future<List<PostReaction>> getPostFunctionalPostReact(int postId) async {
    final String query = """
    query MyQuery {
      post_reacts(where: {post_id: {_eq: $postId }}) {
        reactor {
          id
          uuid
          name
          avatar_url
        }
        mating_pet {
          id
          name
          bio
          avatar_url
          dob
          gender
        }
      }
    }
    """;
    final data = await _hasuraConnect.query(query);
    final json = GetMapFromHasura.getMap(data as Map)["post_reacts"] as List;
    return json
        .map((e) => PostReaction.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Post> closePost(Post post, {String? additionalData}) async {
    final String additonal =
        additionalData == null ? '' : ', additional_data: "$additionalData"';
    final String query = """
    mutation MyMutation {
      update_posts_by_pk(pk_columns: {id: ${post.id}}, _set: {is_closed: true$additonal}) {
        id
        uuid
        content
        type
        medias {
          id
          url
          type
        }
        user {
          id
          uuid
          name
          avatar_url
        }
        post_pets {
          pet {
            id
            name
            dob
            gender
            avatar_url
          }
        }
        location {
          id
          lat
          long
          name
        }
        created_at
        is_closed
      }
    }
    """;
    final data = await _hasuraConnect.mutation(query);
    final postJson =
        GetMapFromHasura.getMap(data as Map)["update_posts_by_pk"] as Map;
    return Post.fromJson(postJson as Map<String, dynamic>);
  }

  Future<List<Post>> getPostsByLocation(
      double lat, double long, int radius) async {
    final query = """
    query MyQuery {
      get_functional_posts_by_location(args: {long_user: $long, lat_user: $lat, kilomiters: $radius}) {
        id
        type
        uuid
        medias {
          id
          url
          type
        }
        location {
          id
          name
          lat
          long
        }
        post_pets {
          pet {
            avatar_url
            pet_breed {
              name
              id
            }
            id
            dob
            gender
            name
          }
        }
        is_closed
      }
    }
    """;
    final data = await _hasuraConnect.query(query);
    final listPost =
        GetMapFromHasura.getMap(data as Map)["get_functional_posts_by_location"]
            as List;
    return listPost
        .map((e) => Post.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
