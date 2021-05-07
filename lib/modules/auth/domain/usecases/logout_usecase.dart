import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/data/repositories/auth_repository.dart';

@lazySingleton
class LogoutUsecase {
  final AuthRepository _authRepository;

  LogoutUsecase(this._authRepository);

  Future call() {
    return _authRepository.logout();
  }
}
