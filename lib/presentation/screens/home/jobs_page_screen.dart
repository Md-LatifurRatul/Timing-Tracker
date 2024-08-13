import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/data/models/job.dart';
import 'package:time_tracker_app/data/services/database.dart';
import 'package:time_tracker_app/presentation/screens/home/job_entries/job_entries_page.dart';
import 'package:time_tracker_app/presentation/screens/home/jobs/edit_job_page.dart';
import 'package:time_tracker_app/presentation/screens/home/jobs/job_list_items_builder.dart';
import 'package:time_tracker_app/presentation/widgets/job_list_tile.dart';
import 'package:time_tracker_app/presentation/widgets/plat_form_exception_alert_dialogue.dart';

class JobsPageScreen extends StatefulWidget {
  const JobsPageScreen({super.key});

  @override
  State<JobsPageScreen> createState() => _JobsPageScreenState();
}

class _JobsPageScreenState extends State<JobsPageScreen> {
  Future<void> _deleteJob(Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on PlatformException catch (e) {
      if (mounted) {
        PlatFormExceptionAlertDialogue(title: 'Delete Failed', exeption: e)
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
          IconButton(
              onPressed: () => EditJobPage.showJobPage(context,
                  database: Provider.of<Database>(context, listen: false)),
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              )),
        ],
      ),
      body: _buildContents(),
    );
  }

  Widget _buildContents() {
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return JobListItemsBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            background: Container(
              color: Colors.red,
            ),
            onDismissed: (direction) => _deleteJob(job),
            key: Key('job-${job.id}'),
            direction: DismissDirection.endToStart,
            child: JobListTile(
              job: job,
              onTap: () => JobEntriesPage.showJobEntriesPage(context, job),
            ),
          ),
        );
      },
    );
  }
}
