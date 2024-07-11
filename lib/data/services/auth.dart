import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseUser {
  final String uid;
  FirebaseUser({required this.uid});
}

abstract class AuthBase {
  Future<FirebaseUser?> checkCurrentUser();
  Future<FirebaseUser?> signInAnonymously();
  Future<void> signOut();
  Future<FirebaseUser?> signInWithGoogle();
  Future<FirebaseUser?> signInWithFacebook();
  Stream<FirebaseUser?> get authStateChanges;
}

class Auth implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseUser? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return FirebaseUser(uid: user.uid);
  }

  @override
  Future<FirebaseUser?> checkCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<FirebaseUser?> signInAnonymously() async {
    UserCredential userCredential = await _firebaseAuth.signInAnonymously();

    return _userFromFirebase(userCredential.user);
  }

  @override
  Future<FirebaseUser?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw FirebaseAuthException(
            code: "ERROR_ABORTED_BY_USER", message: "Sign in aborted by user");
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.accessToken == null && googleAuth.idToken == null) {
        throw FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      return _userFromFirebase(userCredential.user);
    } catch (e) {
      print(e.toString());
      throw FirebaseAuthException(
          code: "GOOGLE_SIGN_IN_FAILED", message: "Google sign in failed");
    }
  }

  @override
  Future<FirebaseUser?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance
          .login(permissions: ['public_profile', 'email']);

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;

        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.tokenString);
        final UserCredential authResult =
            await _firebaseAuth.signInWithCredential(credential);
        return _userFromFirebase(authResult.user);
      } else if (result.status == LoginStatus.cancelled) {
        throw FirebaseAuthException(
            code: "ERROR_CANCELLED_BY_USER",
            message: "Sign in cancelled by user");
      } else {
        throw FirebaseAuthException(
            code: "ERROR_FACEBOOK_LOGIN_FAILED",
            message: result.message ?? "Facebook login failed");
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.message}');
      throw FirebaseAuthException(
          code: e.code, message: e.message ?? "Firebase sign in failed");
    } catch (e) {
      print('General Exception: $e');
      throw FirebaseAuthException(
          code: "FACEBOOK_UNKNOWN_ERROR", message: "An unknown error occurred");
    }
  }

  @override
  Stream<FirebaseUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebookLogin = FacebookAuth.instance;
    await facebookLogin.logOut();
    await _firebaseAuth.signOut();
  }
}
