import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthDatasource {
  final GoogleSignIn _googleSignIn;
  final FacebookLogin _facebookLogin;
  final FirebaseAuth _firebaseAuth;

  AuthDatasource(this._googleSignIn, this._facebookLogin, this._firebaseAuth);

  Future<User> loginWithGoogle() async {
    User user;
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      user = userCredential.user;
    }
    return user;
  }

  Future<User> loginWithFacebook() async {
    User user;
    final FacebookLoginResult facebookLoginResult = await _facebookLogin.logIn(['email']);
    if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
      final AuthCredential credential = FacebookAuthProvider.credential(
        facebookLoginResult.accessToken.token,
      );
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      user = userCredential.user;
    }
    return user;
  }

  Future logout() async {
    return _firebaseAuth.signOut();
  }

  Future<User> loginWithEmailPassword(String email, String password) async {
    final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }
}
