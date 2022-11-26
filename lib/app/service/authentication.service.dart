import 'package:caship/app/core/exception/authentication.exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final firebaseAuth = FirebaseAuth.instance;
  AuthenticationService();

  Future<void> signInWithGoogle() async {
    try {
      final googleAccount = await GoogleSignIn().signIn();
      final authentication = await googleAccount!.authentication;
      final credentials = GoogleAuthProvider.credential(
          idToken: authentication.idToken,
          accessToken: authentication.accessToken);
      await firebaseAuth.signInWithCredential(credentials);
    } catch (e) {
      throw SignInFailed();
    }
  }
}
