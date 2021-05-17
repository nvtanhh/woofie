import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

class LoggedUser {
  late User _loggedUser;

  Future<void> setLoggedUser(User user) async {
    _loggedUser = user;
  }

  bool isMyPost(Post post) {
    return post.creatorId == _loggedUser.id;
  }
}
