import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/aggregate/aggregate.dart';
import 'package:meowoof/modules/social_network/domain/models/aggregate/object_aggregate.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class GetPostsOfPetUsecase {
  final ProfileRepository _profileRepository;

  GetPostsOfPetUsecase(this._profileRepository);
  Future<List<Post>> call(int petId, {int offset = 0, int limit = 10}) async {
    await Future.delayed(const Duration(seconds: 2));
    final Post post = Post(
      id: 1,
      type: PostType.activity,
      createdAt: DateTime.now(),
      content:
          "Một năm rồi cơ. Bây giờ xịn hơn rồi. Cũng có mấy ngàn người xài cơ mà  vẫn không như mong muốn. Mà cay cái là làm cho sinh viên trường mà đăng bài giới thiệu trên mấy trang trường thì bị từ chối.",
      creator: User(
          id: 0,
          avatarUrl: "https://i.pinimg.com/564x/5b/eb/0d/5beb0d404c196e15b2882fb55a8554d6.jpg",
          name: "Bao Nguyen",
          pets: [
            Pet(
                id: petId,
                name: "Vàng",
                avatar: "http://thucanhviet.com/wp-content/uploads/2018/03/Pom-2-thang-mat-cuc-xinh-696x528.jpg",
                bio: "Siêu ngu"),
            Pet(
                id: 0,
                name: "Đỏ",
                avatar: "http://thucanhviet.com/wp-content/uploads/2018/03/Pom-2-thang-mat-cuc-xinh-696x528.jpg",
                bio: "Siêu ngốc"),
          ],
          bio: "Người chơi hệ lười"),
      isLiked: false,
      pets: [
        Pet(id: petId, name: "Vàng", avatar: "http://thucanhviet.com/wp-content/uploads/2018/03/Pom-2-thang-mat-cuc-xinh-696x528.jpg"),
        Pet(id: 0, name: "Đỏ", avatar: "http://thucanhviet.com/wp-content/uploads/2018/03/Pom-2-thang-mat-cuc-xinh-696x528.jpg"),
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
    post.postReactsAggregate = ObjectAggregate(
      aggregate: Aggregate(count: 11),
    );
    post.commentsAggregate = ObjectAggregate(
      aggregate: Aggregate(count: 11),
    );
    return <Post>[post];
  }
}
