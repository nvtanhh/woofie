import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/data/repositories/auth_repository.dart';
import 'package:meowoof/modules/auth/domain/models/user.dart';

@lazySingleton
class GetUserUsecase {
  final AuthRepository _authRepository;

  GetUserUsecase(this._authRepository);

  Future<User> call(String uid) {
    return _authRepository.getUser(uid);
  }
}
