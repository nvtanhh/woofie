import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/add_pet/domain/models/pet.dart';
import 'package:meowoof/modules/auth/domain/models/user.dart';
import 'package:meowoof/modules/home_menu/domain/enums/media_type.dart';
import 'package:meowoof/modules/home_menu/domain/models/aggregate.dart';
import 'package:meowoof/modules/home_menu/domain/models/medias.dart';
import 'package:meowoof/modules/home_menu/domain/models/object_aggregate.dart';
import 'package:meowoof/modules/newfeed/domain/models/comment.dart';
import 'package:meowoof/modules/newfeed/domain/models/post.dart';

@lazySingleton
class NewFeedDatasource {
  final HasuraConnect _hasuraConnect;
  NewFeedDatasource(this._hasuraConnect);
  Future<List<Post>> getPosts() async {
    final Post post = Post(
      id: 1,
      createdAt: DateTime.now(),
      content:
          "Một năm rồi cơ. Bây giờ xịn hơn rồi. Cũng có mấy ngàn người xài cơ mà  vẫn không như mong muốn. Mà cay cái là làm cho sinh viên trường mà đăng bài giới thiệu trên mấy trang trường thì bị từ chối.",
      creator: User(name: "Bảo Nguyễn", avatar: Medias(url: "https://i.pinimg.com/564x/5b/eb/0d/5beb0d404c196e15b2882fb55a8554d6.jpg")),
      isLiked: false,
      pets: [
        Pet(name: "Vàng"),
        Pet(name: "Đỏ"),
      ],
    );
    post.medias = <Medias>[
      Medias(
        type: MediaType.image,
        url: "https://i.pinimg.com/564x/5b/eb/0d/5beb0d404c196e15b2882fb55a8554d6.jpg",
      ),
      Medias(
        type: MediaType.image,
        url: "https://i.pinimg.com/564x/6c/f4/34/6cf434d87d710e4aee8f82624b697aef.jpg",
      ),
      Medias(
        type: MediaType.video,
        url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
      ),
    ];
    post.postReactsAggregate = ObjectAggregate(aggregate: Aggregate(count: 11));
    post.commentsAggregate = ObjectAggregate(aggregate: Aggregate(count: 11));
    return <Post>[post];
  }

  Future<List<Comment>> getCommentsInProject(int postId) async {
    await Future.delayed(const Duration(seconds: 2));
    Comment comment = Comment(id: 1);
    comment.creator = User(
      avatar: Medias(
        type: MediaType.image,
        url: "https://i.pinimg.com/564x/5b/eb/0d/5beb0d404c196e15b2882fb55a8554d6.jpg",
      ),
      name: "Bao Nguyen",
    );
    comment.content =
        "Một năm rồi cơ. Bây giờ xịn hơn rồi. Cũng có mấy ngàn người xài cơ mà  vẫn không như mong muốn. Mà cay cái là làm cho sinh viên trường mà đăng bài giới thiệu trên mấy trang trường thì bị từ chối.";
    comment.createdAt = DateTime.now().subtract(
      const Duration(seconds: 120),
    );
    comment.isLiked = true;
    Comment comment2 = Comment(id: 1);
    comment2.creator = User(
      avatar: Medias(
        type: MediaType.image,
        url: "https://i.pinimg.com/564x/5b/eb/0d/5beb0d404c196e15b2882fb55a8554d6.jpg",
      ),
      name: "Bao Nguyen",
    );
    comment2.content =
        "Một năm rồi cơ. Bây giờ xịn hơn rồi.";
    comment2.createdAt = DateTime.now().subtract(
      const Duration(seconds: 120),
    );
    comment2.isLiked = false;
    return <Comment>[comment, comment2];
  }

  Future<bool> likePost(int idPost) async {
    return true;
  }
}
