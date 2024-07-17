import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_app/presentation/widgets/platform_widget.dart';

class PlatformAlertDialogueAction extends PlatformWidget {
  final Widget child;
  final VoidCallback onPressed;

  const PlatformAlertDialogueAction(
      {super.key, required this.child, required this.onPressed});

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: child);
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      onPressed: onPressed,
      child: child,
    );
  }
}
