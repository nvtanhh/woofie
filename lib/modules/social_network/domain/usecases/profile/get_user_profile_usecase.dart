import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class GetUseProfileUseacse {
  final ProfileRepository _profileRepository;

  GetUseProfileUseacse(this._profileRepository);

  Future<User> call(int userId) async {
    return User(
        id: userId,
        avatarUrl: "https://i.pinimg.com/564x/5b/eb/0d/5beb0d404c196e15b2882fb55a8554d6.jpg",
        name: "Bao Nguyen",
        pets: [
          Pet(
              id: 0,
              name: "Vàng",
              avatar: "http://thucanhviet.com/wp-content/uploads/2018/03/Pom-2-thang-mat-cuc-xinh-696x528.jpg",
              bio: "Thích chơi ngu lấy tiếng"),
          Pet(id: 1, name: "Đỏ", avatar: "http://thucanhviet.com/wp-content/uploads/2018/03/Pom-2-thang-mat-cuc-xinh-696x528.jpg", bio: "Siêu ngốc"),
        ],
        bio: "Người chơi hệ lười");
  }
}
