import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/data/datasources/auth_datasource.dart';
import 'package:meowoof/modules/auth/data/datasources/hasura_datasource.dart';
import 'package:meowoof/modules/auth/domain/models/user.dart';

@lazySingleton
class AuthRepository {
  final AuthDatasource _authDatasource;
  final HasuraDatasource _hasuraDatasource;

  AuthRepository(this._authDatasource, this._hasuraDatasource);

  Future<firebase.User> loginWithGoogle() {
    return _authDatasource.loginWithGoogle();
  }

  Future<firebase.User> loginWithFacebook() {
    return _authDatasource.loginWithFacebook();
  }

  Future logout() {
    return _authDatasource.logout();
  }

  Future<firebase.User> loginWithEmailPassword(String email, String password) {
    return _authDatasource.loginWithEmailPassword(email, password);
  }

  Future<firebase.User> registerWithEmailPassword(String email, String password) {
    return _authDatasource.registerWithEmailPassword(email, password);
  }

  Future<bool> checkUserHavePet(int userId) {
    return _hasuraDatasource.checkUseHavePet(userId);
  }

  Future<User> getUser(String uid) {
    return _hasuraDatasource.getUser(uid);
  }
}
