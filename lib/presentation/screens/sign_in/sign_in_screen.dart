import 'package:flutter/material.dart';
import 'package:time_tracker_app/data/services/auth.dart';
import 'package:time_tracker_app/presentation/screens/sign_in/email_sign_in_screen.dart';
import 'package:time_tracker_app/presentation/utility/assets_path.dart';
import 'package:time_tracker_app/presentation/widgets/sign_in_button_widget.dart';
import 'package:time_tracker_app/presentation/widgets/social_sign_in_button.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key, required this.auth});

  final AuthBase auth;

  Future<void> _signInAnonymously() async {
    try {
      await auth.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await auth.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithFacebook() async {
    try {
      await auth.signInWithFacebook();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Time Tracker APP"),
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Sign in",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          SocialSignInButton(
            assests: AssetsPath.googleLogoPng,
            text: "Sign in with Google",
            color: Colors.white,
            onPressed: _signInWithGoogle,
          ),
          const SizedBox(
            height: 8,
          ),
          SocialSignInButton(
            assests: AssetsPath.fbLogoPng,
            text: 'Sign in with Facebook',
            color: const Color(0xFF334D92),
            textColor: Colors.white,
            onPressed: _signInWithFacebook,
          ),
          const SizedBox(
            height: 8,
          ),
          SignInButton(
            text: 'Sign in with email',
            color: Colors.teal,
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => const EmailSignInScreen()));
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
            onPressed: _signInAnonymously,
          ),
        ],
      ),
    );
  }
}
