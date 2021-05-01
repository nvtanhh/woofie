import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/data/datasources/auth_datasource.dart';

@lazySingleton
class AuthRepository {
  final AuthDatasource _authDatasource;

  AuthRepository(this._authDatasource);

  Future<User> loginWithGoogle() {
    return _authDatasource.loginWithGoogle();
  }

  Future<User> loginWithFacebook() {
    return _authDatasource.loginWithFacebook();
  }

  Future logout() {
    return _authDatasource.logout();
  }

  Future<User> loginWithEmailPassword(String email, String password) {
    return _authDatasource.loginWithEmailPassword(email, password);
  }
}
