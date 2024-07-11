import 'package:flutter/material.dart';
import 'package:time_tracker_app/data/services/auth.dart';
import 'package:time_tracker_app/presentation/screens/sign_in/home_screen.dart';
import 'package:time_tracker_app/presentation/screens/sign_in/sign_in_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key, required this.auth});

  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser?>(
      stream: auth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          FirebaseUser? user = snapshot.data;
          if (user == null) {
            return SignInScreen(auth: auth);
          }
          return HomeScreen(
            auth: auth,
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
