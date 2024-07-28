import 'dart:async';

import 'package:time_tracker_app/data/models/email_sign_in_model.dart';
import 'package:time_tracker_app/data/services/auth.dart';

class EmailSignInBlocController {
  final AuthBase auth;
  EmailSignInBlocController({required this.auth});
  final StreamController<EmailSignInModel> _emailModelController =
      StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get emailModelStream => _emailModelController.stream;

  EmailSignInModel _emailSignInModel = EmailSignInModel();

  void dispose() {
    _emailModelController.close();
  }

  Future<void> emailSignInSubmit() async {
    updateWith(submitted: true, isLoading: true);

    try {
      if (_emailSignInModel.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(
            _emailSignInModel.email, _emailSignInModel.password);
      } else {
        await auth.createUserWithEmailAndPassword(
            _emailSignInModel.email, _emailSignInModel.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
      // print(e.toString());
    }
  }

  void toggleFormType() {
    final formType = _emailSignInModel.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
        email: '',
        password: '',
        formType: formType,
        isLoading: false,
        submitted: false);
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    _emailSignInModel = _emailSignInModel.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );
    _emailModelController.add(_emailSignInModel);
  }
}
