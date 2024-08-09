import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/data/services/auth.dart';
import 'package:time_tracker_app/presentation/screens/sign_in/email_sign_in_screen.dart';
import 'package:time_tracker_app/presentation/state_holders/sign_in_controller.dart';
import 'package:time_tracker_app/presentation/utility/assets_path.dart';
import 'package:time_tracker_app/presentation/widgets/plat_form_exception_alert_dialogue.dart';
import 'package:time_tracker_app/presentation/widgets/sign_in_button_widget.dart';
import 'package:time_tracker_app/presentation/widgets/social_sign_in_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen(
      {super.key, required this.signInController, required this.isLoading});
  final SignInController signInController;

  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInController>(
          create: (_) => SignInController(auth: auth, isLoading: isLoading),
          child: Consumer<SignInController>(
            builder: (context, signInController, _) => SignInScreen(
              signInController: signInController,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  void _showSignInError(BuildContext context, PlatformException exeption) {
    PlatFormExceptionAlertDialogue(title: 'Sign in failed', exeption: exeption)
        .show(context);
  }

  Future<void> _signInAnonymously() async {
    try {
      await widget.signInController.signInAnonymously();
    } on PlatformException catch (e) {
      // print(e.toString());
      if (mounted) {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await widget.signInController.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        // print(e.toString());
        if (mounted) {
          _showSignInError(context, e);
        }
      }
    } catch (e) {
      print('Sign in aborted: $e');
    }
  }

  Future<void> _signInWithFacebook() async {
    try {
      await widget.signInController.signInWithFacebook();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        // print(e.toString());
        if (mounted) {
          _showSignInError(context, e);
        }
      }
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
          SizedBox(
            height: 40,
            child: _buildHeading(),
          ),
          const SizedBox(
            height: 40,
          ),
          SocialSignInButton(
            assests: AssetsPath.googleLogoPng,
            text: "Sign in with Google",
            color: Colors.white,
            onPressed: widget.isLoading ? null : () => _signInWithGoogle(),
          ),
          const SizedBox(
            height: 8,
          ),
          SocialSignInButton(
            assests: AssetsPath.fbLogoPng,
            text: 'Sign in with Facebook',
            color: const Color(0xFF334D92),
            textColor: Colors.white,
            onPressed: widget.isLoading ? null : () => _signInWithFacebook(),
          ),
          const SizedBox(
            height: 8,
          ),
          SignInButton(
            text: 'Sign in with email',
            color: Colors.teal,
            textColor: Colors.white,
            onPressed: widget.isLoading
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
            onPressed: widget.isLoading ? null : () => _signInAnonymously(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeading() {
    if (widget.isLoading) {
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
