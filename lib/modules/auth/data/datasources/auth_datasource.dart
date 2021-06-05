import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/data/storages/user_storage.dart';

@lazySingleton
class AuthDatasource {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;
  final FacebookAuth _facebookAuth;
  final UserStorage _userStorage;

  AuthDatasource(
    this._googleSignIn,
    this._firebaseAuth,
    this._facebookAuth,
    @Named("current_user_storage") this._userStorage,
  );

  Future<User?> loginWithGoogle() async {
    User? user;
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      user = userCredential.user;
    } else {
      throw Exception("Login fail");
    }
    return user;
  }

  Future<User?> loginWithFacebook() async {
    User? user;
    final LoginResult facebookLoginResult = await _facebookAuth.login();
    if (facebookLoginResult.status == LoginStatus.success) {
      final AuthCredential credential = FacebookAuthProvider.credential(facebookLoginResult.accessToken?.token ?? "");
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      user = userCredential.user;
    } else {
      throw Exception("Login fail");
    }
    return user;
  }

  Future logout() async {
    _userStorage.remove();
    await _firebaseAuth.signOut();
    return;
  }

  Future<User?> loginWithEmailPassword(String email, String password) async {
    final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  Future<User?> registerWithEmailPassword(String email, String password) async {
    final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }
}
