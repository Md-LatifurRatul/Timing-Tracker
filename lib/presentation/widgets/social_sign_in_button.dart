import 'package:flutter/material.dart';
import 'package:time_tracker_app/presentation/widgets/custom_elevated_button.dart';

class SocialSignInButton extends StatelessWidget {
  const SocialSignInButton(
      {super.key,
      required this.text,
      required this.color,
      this.textColor = Colors.black87,
      required this.onPressed,
      required this.assests});

  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;
  final String assests;

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      color: color,
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(assests),
          Text(
            text,
            style: TextStyle(color: textColor, fontSize: 15),
          ),
          const Opacity(opacity: 1),
        ],
      ),
    );
  }
}
