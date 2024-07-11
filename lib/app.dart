import 'package:flutter/material.dart';
import 'package:time_tracker_app/data/services/auth.dart';
import 'package:time_tracker_app/presentation/screens/splash_screen.dart';

class TimeTracker extends StatelessWidget {
  const TimeTracker({super.key});

  @override
  Widget build(BuildContext context) {
    final Auth auth = Auth();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Time Tracker APP',
      home: SplashScreen(
        auth: auth,
      ),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
          backgroundColor: Colors.indigo,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
        ),
        primarySwatch: Colors.indigo,
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            minimumSize: const Size(60, 40),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
