import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/data/repositories/auth_repository.dart';

@lazySingleton
class LoginWithEmailPasswordUsecase {
  final AuthRepository _authRepository;

  LoginWithEmailPasswordUsecase(this._authRepository);
  Future<User?> call(String email, String password) {
    return _authRepository.loginWithEmailPassword(email, password);
  }
}
