import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/data/repositories/auth_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class GetUserWithUuidUsecase {
  final AuthRepository _authRepository;

  GetUserWithUuidUsecase(this._authRepository);

  Future<User> call(String uuid) {
    return _authRepository.getUser(uuid);
  }
}
