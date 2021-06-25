import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/data/storages/user_storage.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class LoggedInUser {
  final UserStorage _userStorage;

  LoggedInUser(@Named("current_user_storage") this._userStorage) {
    _loggedInUser = _userStorage.get();
  }

  late User? _loggedInUser;

  Future<void> setLoggedUser(User user) async {
    _loggedInUser = user;
  }

  User? get loggedInUser => _loggedInUser;

  bool isMyPost(Post post) {
    // ignore: unrelated_type_equality_checks
    return post.creatorUUID == _loggedInUser?.uuid;
  }
}
