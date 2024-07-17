import 'dart:io';

import 'package:flutter/material.dart';

abstract class PlatformWidget extends StatelessWidget {
  const PlatformWidget({super.key});

  Widget buildMaterialWidget(BuildContext context);
  Widget buildCupertinoWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return buildMaterialWidget(context);
    }
    return buildCupertinoWidget(context);
  }
}
