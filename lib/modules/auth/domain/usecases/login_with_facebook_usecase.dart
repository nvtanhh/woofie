import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/data/repositories/auth_repository.dart';

@lazySingleton
class LoginWithFacebookUsecase {
  final AuthRepository _authRepository;

  LoginWithFacebookUsecase(this._authRepository);

  Future<User?> call() {
    return _authRepository.loginWithFacebook();
  }
}
