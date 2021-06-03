import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class UserDatasource {
  Future followPet(int petID) async {
    return;
  }

  Future blockUser(int userID) async {
    return;
  }

  Future<User> getUserProfile(int userId) async {
    return User(
      id: userId,
      avatarUrl: "https://i.pinimg.com/564x/5b/eb/0d/5beb0d404c196e15b2882fb55a8554d6.jpg",
      name: "Bao Nguyen",
      pets: [
        Pet(
          id: 0,
          name: "Vàng",
          dob: DateTime.now().subtract(Duration(days: 100)),
          avatar: "http://thucanhviet.com/wp-content/uploads/2018/03/Pom-2-thang-mat-cuc-xinh-696x528.jpg",
          bio: "Thích chơi ngu lấy tiếng",
        ),
        Pet(
          id: 1,
          dob: DateTime.now().subtract(Duration(days: 200)),
          name: "Đỏ",
          avatar: "http://thucanhviet.com/wp-content/uploads/2018/03/Pom-2-thang-mat-cuc-xinh-696x528.jpg",
          bio: "Siêu ngốc",
        ),
      ],
      bio: "Người chơi hệ lười",
    );
  }

  Future reportUser(int userID) async {
    return;
  }
}
