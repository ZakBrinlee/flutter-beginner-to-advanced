import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instantgram_clone_course/state/auth/constants/constants.dart';
import 'package:instantgram_clone_course/state/auth/models/auth_result.dart';
import 'package:instantgram_clone_course/state/posts/typedefs/user_id.dart';

class Authenticator {
  const Authenticator();

  User? get currentUser => FirebaseAuth.instance.currentUser;
  bool get isAlreadyLoggedIn => userId != null;
  UserId? get userId => currentUser?.uid;
  String? get displayName => currentUser?.displayName;
  String? get email => currentUser?.email;

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  Future<AuthResult> loginWithGoogle() async {
    final GoogleSignIn googleSignIn =
        GoogleSignIn(scopes: [Constants.emailScope]);

    var oauthCredentials;
    try {
      final signInAccount = await googleSignIn.signIn();

      if (signInAccount == null) {
        return AuthResult.aborted;
      }

      final googleAuth = await signInAccount.authentication;
      oauthCredentials = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
    } on Exception catch (e) {
      log('loginWithGoogle error: $e');
    }

    try {
      await FirebaseAuth.instance.signInWithCredential(oauthCredentials);
      return AuthResult.success;
    } catch (e) {
      return AuthResult.failure;
    }
  }
}
