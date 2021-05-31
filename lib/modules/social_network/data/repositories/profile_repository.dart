import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/datasources/user_datasource.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class ProfileRepository {
  final UserDatasource _userDatasource;

  ProfileRepository(this._userDatasource);

  Future likePost(int postId) async {
    return;
  }

  Future<User> getUserProfile(int userId) async {
    return User(id: 0);
  }

  Future<List<Post>> getPostOfUser(int useId, int offset, int limit) async {
    return [];
  }
}
