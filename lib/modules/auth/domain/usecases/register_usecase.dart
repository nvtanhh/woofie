import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/data/datasources/auth_datasource.dart';

@lazySingleton
class RegisterUsecase {
  final AuthDatasource _authDatasource;

  RegisterUsecase(this._authDatasource);

  Future<User?> call(String email, String password, String name) {
    return _authDatasource.registerWithEmailPassword(email, password, name);
  }
}
