import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/data/services/auth.dart';
import 'package:time_tracker_app/presentation/widgets/avatar_image.dart';
import 'package:time_tracker_app/presentation/widgets/platform_alert_dialogue.dart';

class AccounPage extends StatelessWidget {
  const AccounPage({super.key});

  Future<void> _signOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await const PlatformAlertDialogue(
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
        actions: [
          OutlinedButton(
            onPressed: () {
              _confirmSignOut(context);
            },
            child: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(130),
            child: _buildUserInfo(user)),
      ),
    );
  }

  Widget _buildUserInfo(FirebaseUser user) {
    return Column(
      children: [
        AvatarImage(photoUrl: user.photUrl, radius: 50),
        const SizedBox(
          height: 10,
        ),
        if (user.displayName != null)
          Text(
            user.displayName ?? '',
            style: const TextStyle(color: Colors.white),
          ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
