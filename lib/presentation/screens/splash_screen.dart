import 'package:flutter/material.dart';
import 'package:time_tracker_app/data/services/auth.dart';
import 'package:time_tracker_app/presentation/screens/sign_in/landing_screen.dart';
import 'package:time_tracker_app/presentation/widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.auth});

  final AuthBase auth;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) {
      return;
    }

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LandingScreen(
                  auth: widget.auth,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          AppLogo(),
          SizedBox(
            height: 20,
          ),
          CircularProgressIndicator(),
          SizedBox(
            height: 12,
          ),
          Text(
            "Version 1.1.0",
            style: TextStyle(color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
