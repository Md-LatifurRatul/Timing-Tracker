import 'dart:async';
import 'package:time_tracker_app/data/services/auth.dart';

class SignInBlocController {
  SignInBlocController({required this.auth});
  final AuthBase auth;
  final StreamController<bool> _isLoadingController = StreamController<bool>();

  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  void _setIsLoading(bool isloading) => _isLoadingController.add(isloading);

  Future<FirebaseUser?> _signIn(
      Future<FirebaseUser?> Function() signInMethod) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      _setIsLoading(false);
      rethrow;
    }
  }

  Future<FirebaseUser?> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);

  Future<FirebaseUser?> signInWithGoogle() async =>
      await _signIn(auth.signInWithGoogle);
  Future<FirebaseUser?> signInWithFacebook() async =>
      await _signIn(auth.signInWithFacebook);
}
