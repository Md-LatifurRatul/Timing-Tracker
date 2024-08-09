import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:time_tracker_app/data/services/auth.dart';

class SignInController {
  SignInController({required this.isLoading, required this.auth});
  final AuthBase auth;

  final ValueNotifier<bool> isLoading;

  Future<FirebaseUser?> _signIn(
      Future<FirebaseUser?> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
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
