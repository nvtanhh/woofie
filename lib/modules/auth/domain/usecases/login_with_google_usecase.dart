import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/data/repositories/auth_repository.dart';

@lazySingleton
class LoginWithGoogleUsecase {
  final AuthRepository _authRepository;

  LoginWithGoogleUsecase(this._authRepository);

  Future<User> call() {
    return _authRepository.loginWithGoogle();
  }
}
