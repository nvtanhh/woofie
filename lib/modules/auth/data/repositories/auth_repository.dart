import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/data/datasources/auth_datasource.dart';
import 'package:meowoof/modules/auth/data/datasources/hasura_datasource.dart';

@lazySingleton
class AuthRepository {
  final AuthDatasource _authDatasource;
  final HasuraDatasource _hasuraDatasource;

  AuthRepository(this._authDatasource, this._hasuraDatasource);

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

  Future<User> registerWithEmailPassword(String email, String password) {
    return _authDatasource.registerWithEmailPassword(email, password);
  }

  Future<bool> checkUserHavePet() {
    return _hasuraDatasource.checkUseHavePet();
  }
}
