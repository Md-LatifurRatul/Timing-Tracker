import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/data/models/job.dart';
import 'package:time_tracker_app/data/services/auth.dart';
import 'package:time_tracker_app/data/services/database.dart';
import 'package:time_tracker_app/presentation/widgets/plat_form_exception_alert_dialogue.dart';
import 'package:time_tracker_app/presentation/widgets/platform_alert_dialogue.dart';

class JobsPageScreen extends StatefulWidget {
  const JobsPageScreen({super.key});

  @override
  State<JobsPageScreen> createState() => _JobsPageScreenState();
}

class _JobsPageScreenState extends State<JobsPageScreen> {
  Future<void> _signOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut() async {
    final didRequestSignOut = await const PlatformAlertDialogue(
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      if (mounted) {
        _signOut(context);
      }
    }
  }

  Future<void> _createJob() async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.createJob(Job(name: 'Blogging', ratePerHour: 10));
    } on PlatformException catch (e) {
      if (mounted) {
        PlatFormExceptionAlertDialogue(title: 'Operation Failed', exeption: e)
            .show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    database.jobsStream();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Jobs"),
        actions: [
          OutlinedButton(
            onPressed: () {
              _confirmSignOut();
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
      ),
      body: _buildContents(),
      floatingActionButton: FloatingActionButton(
        onPressed: _createJob,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContents() {
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data ?? [];
          final children = jobs.map((job) => Text(job.name)).toList();

          return ListView(
            children: children,
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Some Error occurred'),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
