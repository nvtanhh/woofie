import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/get_map_from_hasura.dart';
import 'package:meowoof/modules/social_network/domain/models/aggregate/aggregate.dart';
import 'package:meowoof/modules/social_network/domain/models/aggregate/object_aggregate.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class PostDatasource {
  final HasuraConnect _hasuraConnect;

  PostDatasource(this._hasuraConnect);

  Future<List<Post>> getPosts() async {
    await Future.delayed(const Duration(seconds: 1));
    final Post post = Post(
      id: 1,
      type: PostType.activity,
      createdAt: DateTime.now(),
      content:
          "Một năm rồi cơ. Bây giờ xịn hơn rồi. Cũng có mấy ngàn người xài cơ mà  vẫn không như mong muốn. Mà cay cái là làm cho sinh viên trường mà đăng bài giới thiệu trên mấy trang trường thì bị từ chối.",
      creator: User(
        id: 1,
        name: "Bảo Nguyễn",
        avatar: Media(id: 1, url: "https://i.pinimg.com/564x/5b/eb/0d/5beb0d404c196e15b2882fb55a8554d6.jpg", type: MediaType.image),
        // avatarUrl:
        //     "https://i.pinimg.com/564x/5b/eb/0d/5beb0d404c196e15b2882fb55a8554d6.jpg",
      ),
      isLiked: false,
      pets: [
        Pet(
            id: 0,
            name: "Vàng",
            avatar: Media(
              id: 0,
              url: "http://thucanhviet.com/wp-content/uploads/2018/03/Pom-2-thang-mat-cuc-xinh-696x528.jpg",
              type: MediaType.image,
            )),
        Pet(
            id: 1,
            name: "Đỏ",
            avatar: Media(
              id: 0,
              url: "http://thucanhviet.com/wp-content/uploads/2018/03/Pom-2-thang-mat-cuc-xinh-696x528.jpg",
              type: MediaType.image,
            )),
      ],
    );
    post.medias = <Media>[
      Media(
        id: 2,
        type: MediaType.image,
        url: "https://i.pinimg.com/564x/5b/eb/0d/5beb0d404c196e15b2882fb55a8554d6.jpg",
      ),
      Media(
        id: 3,
        type: MediaType.image,
        url: "https://i.pinimg.com/564x/6c/f4/34/6cf434d87d710e4aee8f82624b697aef.jpg",
      ),
      Media(
        id: 4,
        type: MediaType.video,
        url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
      ),
    ];
    post.postReactsAggregate = ObjectAggregate(aggregate: Aggregate(count: 11));
    post.commentsAggregate = ObjectAggregate(aggregate: Aggregate(count: 11));
    return <Post>[post];
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
    is_liked
    created_at
    user {
      avatar
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
    return (affectedRows["id"] as String).isNotEmpty;
  }

  Future<List<Post>> getPostOfUser(String userUUID, int offset, int limit) async {
    final query = """
    query MyQuery {
  posts(limit: $limit, offset: $offset, where: {creator_uuid: {_eq: "$userUUID"}}, order_by: {created_at: asc}) {
    content
    created_at
    creator_uuid
    id
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
      }
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
    content
    created_at
    creator_uuid
    id
    is_closed
    is_liked
    medias {
      id
      type
      url
    }
    post_reacts_aggregate {
      aggregate {
        count
      }
    }
    type
    post_pets {
      pet {
        name
        id
      }
    }
    comments_aggregate {
      aggregate {
        count
      }
    }
  }
}
    """;
    final data = await _hasuraConnect.query(query);
    final listPost = GetMapFromHasura.getMap(data as Map)["posts"] as List;
    return listPost.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Post> createPost(Post post) async {
    final listPetTag = post.pets?.map((e) => {"pet_id": e.id}).toList() ?? [];
    final location = post.location == null
        ? ""
        : 'location_post: {data: {long: "${post.location?.long}", lat: "${post.location?.lat}", name: "${post.location?.name}"}},';
    final manution = """
  mutation MyMutation {
  insert_posts_one(object: {content: "${post.content}",$location medias: {data: ${post.medias?.toString() ?? "[]"}}, type: "${post.type.index}", post_pets: {data: $listPetTag}}) {
    id
  }
}
""";
    print(manution);
    final data = await _hasuraConnect.mutation(manution);
    final affectedRows = GetMapFromHasura.getMap(data as Map)["insert_posts_one"] as Map;
    post.id = affectedRows["id"] as int;
    return post;
  }

  Future<bool> deletePost(int idPost) async {
    return true;
  }
}
