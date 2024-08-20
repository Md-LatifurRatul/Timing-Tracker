import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/data/services/auth.dart';
import 'package:time_tracker_app/data/services/database.dart';
import 'package:time_tracker_app/presentation/screens/home/home_page.dart';
import 'package:time_tracker_app/presentation/screens/sign_in/sign_in_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return StreamBuilder<FirebaseUser?>(
      stream: auth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          FirebaseUser? user = snapshot.data;
          if (user == null) {
            return SignInScreen.create(context);
          }
          return Provider<FirebaseUser>.value(
            value: user,
            child: Provider<Database>(
                create: (_) => FirestoreDatabase(uid: user.uid),
                child: const HomePage()),
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
