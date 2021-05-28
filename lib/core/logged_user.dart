import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

class LoggedInUser {
  late User _loggedInUser;

  Future<void> setLoggedUser(User user) async {
    _loggedInUser = user;
  }

  User get loggedInUser => _loggedInUser;

  bool isMyPost(Post post) {
    return post.creatorId == _loggedInUser.id;
  }
}
