import 'package:flutter/services.dart';
import 'package:time_tracker_app/presentation/widgets/platform_alert_dialogue.dart';

class PlatFormExceptionAlertDialogue extends PlatformAlertDialogue {
  PlatFormExceptionAlertDialogue({
    super.key,
    required super.title,
    required PlatformException exeption,
  }) : super(
          content: _message(exeption),
          defaultActionText: 'OK',
        );

  static String _message(PlatformException exeption) {
    return _errors[exeption.code] ?? exeption.message ?? '';
  }

  static final Map<String, String> _errors = {
    "email-already-in-use": 'The entered email is already in use',
    "operation-not-allowed": 'Operation is not allowed, try again!',
    " weak-password": 'The given password is weak',
    "invalid-email": 'Email is invalid',
    " user-disabled": 'User is disabled',
    "user-not-found": 'User is not found',
    " wrong-password": 'The Password is invalid',
  };
}
