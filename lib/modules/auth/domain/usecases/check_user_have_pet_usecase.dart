import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/data/repositories/auth_repository.dart';

@lazySingleton
class CheckUserHavePetUsecase {
  final AuthRepository _authRepository;

  CheckUserHavePetUsecase(this._authRepository);
  Future<bool> call() {
    return _authRepository.checkUserHavePet();
  }
}
