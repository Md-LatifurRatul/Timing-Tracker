import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_app/presentation/widgets/platform_alert_dialogue_action.dart';
import 'package:time_tracker_app/presentation/widgets/platform_widget.dart';

class PlatformAlertDialogue extends PlatformWidget {
  final String title;
  final String content;
  final String? cancelActionText;
  final String defaultActionText;

  Future<bool?> show(BuildContext context) async {
    return Platform.isAndroid
        ? await showDialog<bool>(
            context: context,
            barrierDismissible: true,
            builder: (context) => this,
          )
        : await showCupertinoDialog(
            context: context, builder: (context) => this);
  }

  const PlatformAlertDialogue({
    super.key,
    required this.title,
    required this.content,
    required this.defaultActionText,
    this.cancelActionText = 'Cancel',
  });

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(title),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    if (cancelActionText != null) {
      actions.add(
        PlatformAlertDialogueAction(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelActionText ?? ''),
        ),
      );
    }
    actions.add(
      PlatformAlertDialogueAction(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(defaultActionText),
      ),
    );
    return actions;
  }
}
