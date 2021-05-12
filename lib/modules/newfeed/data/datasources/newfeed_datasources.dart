import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/add_pet/domain/models/pet.dart';
import 'package:meowoof/modules/auth/domain/models/user.dart';
import 'package:meowoof/modules/home_menu/domain/enums/media_type.dart';
import 'package:meowoof/modules/home_menu/domain/models/aggregate.dart';
import 'package:meowoof/modules/home_menu/domain/models/medias.dart';
import 'package:meowoof/modules/home_menu/domain/models/object_aggregate.dart';
import 'package:meowoof/modules/newfeed/domain/models/post.dart';

@lazySingleton
class NewFeedDatasource {
  Future<List<Post>> getPosts() async {
    Post post = Post(
      id: 1,
      createdAt: DateTime.now(),
      content:
          "Một năm rồi cơ. Bây giờ xịn hơn rồi. Cũng có mấy ngàn người xài cơ mà  vẫn không như mong muốn. Mà cay cái là làm cho sinh viên trường mà đăng bài giới thiệu trên mấy trang trường thì bị từ chối.",
      creator: User(name: "Bảo Nguyễn", avatar: Medias(url: "https://i.pinimg.com/564x/5b/eb/0d/5beb0d404c196e15b2882fb55a8554d6.jpg")),
      ilike: false,
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
}
