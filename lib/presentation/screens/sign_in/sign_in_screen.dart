import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/data/services/auth.dart';
import 'package:time_tracker_app/presentation/screens/sign_in/email_sign_in_screen.dart';
import 'package:time_tracker_app/presentation/state_holders/sign_in_bloc_controller.dart';
import 'package:time_tracker_app/presentation/utility/assets_path.dart';
import 'package:time_tracker_app/presentation/widgets/plat_form_exception_alert_dialogue.dart';
import 'package:time_tracker_app/presentation/widgets/sign_in_button_widget.dart';
import 'package:time_tracker_app/presentation/widgets/social_sign_in_button.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key, required this.signInBloc});
  final SignInBlocController signInBloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<SignInBlocController>(
      create: (_) => SignInBlocController(auth: auth),
      dispose: (context, bloc) => bloc.dispose(),
      child: Consumer<SignInBlocController>(
        builder: (context, signInBloc, _) => SignInScreen(
          signInBloc: signInBloc,
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exeption) {
    PlatFormExceptionAlertDialogue(title: 'Sign in failed', exeption: exeption)
        .show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await signInBloc.signInAnonymously();
    } on PlatformException catch (e) {
      // print(e.toString());
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await signInBloc.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        // print(e.toString());

        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await signInBloc.signInWithFacebook();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        // print(e.toString());

        _showSignInError(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Time Tracker APP"),
      ),
      body: StreamBuilder<bool>(
        stream: signInBloc.isLoadingStream,
        initialData: false,
        builder: (context, snapshot) {
          return _buildContent(context, snapshot.data!);
        },
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 40,
            child: _buildHeading(isLoading),
          ),
          const SizedBox(
            height: 40,
          ),
          SocialSignInButton(
            assests: AssetsPath.googleLogoPng,
            text: "Sign in with Google",
            color: Colors.white,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          const SizedBox(
            height: 8,
          ),
          SocialSignInButton(
            assests: AssetsPath.fbLogoPng,
            text: 'Sign in with Facebook',
            color: const Color(0xFF334D92),
            textColor: Colors.white,
            onPressed: isLoading ? null : () => _signInWithFacebook(context),
          ),
          const SizedBox(
            height: 8,
          ),
          SignInButton(
            text: 'Sign in with email',
            color: Colors.teal,
            textColor: Colors.white,
            onPressed: isLoading
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => const EmailSignInScreen(),
                      ),
                    );
                  },
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            "or",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SignInButton(
            text: 'Go anonymous',
            color: Colors.lime,
            textColor: Colors.black,
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeading(bool isLoading) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return const Text(
      "Sign in",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
