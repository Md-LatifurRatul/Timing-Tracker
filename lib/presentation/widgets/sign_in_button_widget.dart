import 'package:flutter/material.dart';
import 'package:time_tracker_app/presentation/widgets/custom_elevated_button.dart';

class SignInButton extends StatelessWidget {
  const SignInButton(
      {super.key,
      required this.text,
      required this.color,
      required this.textColor,
      required this.onPressed});

  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      color: color,
      onPressed: onPressed ?? () {},
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 15),
      ),
    );
  }
}
