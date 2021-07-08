import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/get_map_from_hasura.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/post/new_post_data.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

@lazySingleton
class PostDatasource {
  final HasuraConnect _hasuraConnect;

  PostDatasource(this._hasuraConnect);

  Future<List<Post>> getPosts({int limit = 10, int offset = 0, DateTime? lastValue}) async {
    await Future.delayed(const Duration(seconds: 1));
    return <Post>[];
  }

  Future<List<Comment>> getPostComments(int postId, int limit, int offset) async {
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
    uuid
    is_liked
    created_at
    user {
      avatar {
        url
        type
        id
      }
      id
      name
      uuid
    }
  }
}
    """;
    final data = await _hasuraConnect.query(query);
    final listPost = GetMapFromHasura.getMap(data as Map)["comments"] as List;
    return listPost.map((e) => Comment.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<bool> likePost(int idPost) async {
    final mutation = """
    mutation MyMutation {
  likePost(post_id: "$idPost") {
    id
  }
  }
""";
    final data = await _hasuraConnect.mutation(mutation);
    final affectedRows = GetMapFromHasura.getMap(data as Map)["likePost"] as Map;
    return int.tryParse("${affectedRows["id"]}") != null;
  }

  Future<List<Post>> getPostsTimeline(int offset, int limit, {String? userUUID}) async {
    final String userFilter = (userUUID != null) ? 'where: {creator_uuid: {_eq: "$userUUID"}}, ' : '';

    final query = """
    query MyQuery {
      posts(limit: $limit, offset: $offset, $userFilter order_by: {created_at: desc}) {
        content
        created_at
        creator_uuid
        id
        uuid
        is_liked
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
            bio
          }
        }
        user {
          bio
          id
          name
          avatar {
            type
            url
          }
          uuid
        }
      }
    }
    """;
    final data = await _hasuraConnect.query(query);
    final listPost = GetMapFromHasura.getMap(data as Map)["posts"] as List;
    return listPost.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Post>> getPostsOfPet(int petId, int offset, int limit) async {
    final query = """
  query MyQuery {
  posts(limit: $limit, offset: $offset, where: {post_pets: {pet_id: {_eq: $petId}}}, order_by: {created_at: asc}) {
  content created_at creator_uuid id is_closed is_liked uuid
  medias { id type url }
  post_reacts_aggregate { aggregate { count } } 
  type post_pets { pet { name id } }
  comments_aggregate { aggregate { count } }
  user { uuid name id }
   } }
    """;
    final data = await _hasuraConnect.query(query);
    final listPost = GetMapFromHasura.getMap(data as Map)["posts"] as List;
    return listPost.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Post> createPost(Post post) async {
    final listPetTag = post.taggegPets?.map((e) => {"pet_id": e.id}).toList() ?? [];
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
  }}
""";
    final data = await _hasuraConnect.mutation(manution);
    final affectedRows = GetMapFromHasura.getMap(data as Map)["insert_posts_one"] as Map;
    return Post.fromJson(affectedRows as Map<String, dynamic>);
  }

  Future<bool> deletePost(int idPost) async {
    final manution = """
    mutation MyMutation {
      delete_posts(where: {id: {_eq: $idPost}}) {
        affected_rows
      }
    }
    """;
    final data = await _hasuraConnect.mutation(manution);
    final deletePosts = GetMapFromHasura.getMap(data as Map)["delete_posts"] as Map;
    final affectedRows = deletePosts["affected_rows"] as int;
    return affectedRows >= 1;
  }

  Future<List<Post>> getPostByType(PostType postType, int distance, int limit, int offset) async {
    final query = """
query MyQuery {
  get_posts_by_type(args: {post_type: ${postType.index}, distance_kms: $distance }, order_by: {created_at: desc}, limit: $limit, offset: $offset) {
    id
    type
    uuid
    post_pets {
      pet {
        avatar {
          type
          url
          id
        }
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
    distance_user_to_post
  }
}
    """;
    final data = await _hasuraConnect.query(query);
    final listPost = GetMapFromHasura.getMap(data as Map)["get_posts_by_type"] as List;
    return listPost.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Post> getDetailPost(int postId) async {
    final query = """
    query MyQuery {
  posts_by_pk(id: $postId) {
    content
    created_at
    distance_user_to_post
    id
    uuid
    medias {
      id
      type
      url
    }
    status
    type
    location {
      id
      name
    }
  }
}
    """;
    final data = await _hasuraConnect.query(query);
    final post = GetMapFromHasura.getMap(data as Map)["posts_by_pk"] as Map<String, dynamic>;
    return Post.fromJson(post);
  }

  Future<Post> createDraftPost(NewPostData newPostData) async {
    const draftPostStatus = 0;

    final listPetTag = newPostData.taggegPets?.map((e) => {"pet_id": e.id}).toList() ?? [];

    final location = newPostData.location == null
        ? ""
        : 'location: {data: {long: "${newPostData.location?.long}", lat: "${newPostData.location?.lat}", name: "${newPostData.location?.name}"}},';

    final String manution = """
    mutation MyMutation {
      insert_posts_one(object: {uuid: "${newPostData.newPostUuid}", content: "${newPostData.content}", type: ${newPostData.type.index}, $location status: $draftPostStatus, post_pets: {data: $listPetTag}}) {
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
    final jsonBody = GetMapFromHasura.getMap(data as Map)["insert_posts_one"] as Map;
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
          name
          avatar {
            id
            url
            type
          }
        }
        post_pets {
          pet {
            id
            name
            avatar {
              id
              url
              type
            }
          }
        }
        location {
          id
          lat
          long
          name
        }
        created_at
      }
    }
    """;
    final data = await _hasuraConnect.mutation(query);
    final postJson = GetMapFromHasura.getMap(data as Map)["update_posts_by_pk"] as Map;
    return Post.fromJson(postJson as Map<String, dynamic>);
  }

  Future<PostStatus?> getPostStatusWithId(int postId) async {}

  Future<Post?> getPostWithId(int postId) async {}
}
