import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/data/storages/user_storage.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class SaveUserToLocalUsecase {
  final UserStorage _userStorage;

  SaveUserToLocalUsecase(
    @Named("current_user_storage") this._userStorage,
  );

  Future call(User user) async {
    return _userStorage.set(user);
  }
}
