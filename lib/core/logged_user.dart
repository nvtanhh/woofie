import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/data/storages/user_storage.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class LoggedInUser {
  final UserStorage _userStorage;

  LoggedInUser(this._userStorage) {
    _loggedInUser = _userStorage.get();
  }

  late User? _loggedInUser;

  Future<void> setLoggedUser(User user) async {
    _loggedInUser = user;
    _userStorage.set(user);
  }

  User? get user => _loggedInUser;

  bool isMyPost(Post post) {
    // ignore: unrelated_type_equality_checks
    return post.creatorUUID == _loggedInUser?.uuid;
  }

  void saveToLocal({User? user}) {
    _userStorage.set(user ?? _loggedInUser!);
  }
}
