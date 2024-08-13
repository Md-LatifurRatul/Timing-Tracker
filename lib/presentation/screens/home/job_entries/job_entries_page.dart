import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/data/models/entry.dart';
import 'package:time_tracker_app/data/models/job.dart';
import 'package:time_tracker_app/data/services/database.dart';
import 'package:time_tracker_app/presentation/screens/home/job_entries/entry_page.dart';
import 'package:time_tracker_app/presentation/screens/home/jobs/edit_job_page.dart';
import 'package:time_tracker_app/presentation/screens/home/jobs/job_list_items_builder.dart';
import 'package:time_tracker_app/presentation/widgets/dismissible_entry_list_item.dart';
import 'package:time_tracker_app/presentation/widgets/plat_form_exception_alert_dialogue.dart';

class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({super.key, required this.database, required this.job});
  final Database database;
  final Job job;

  static Future<void> showJobEntriesPage(BuildContext context, Job job) async {
    final Database database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(database: database, job: job),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } on PlatformException catch (e) {
      PlatFormExceptionAlertDialogue(
        title: 'Operation failed',
        exeption: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Job>(
      stream: database.jobStream(jobId: job.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final job = snapshot.data!;
          final jobName = job.name;

          return Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              title: Text(jobName),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () => EditJobPage.showJobPage(context,
                      database: database, job: job),
                ),
                IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () => EntryPage.showEntryPage(
                        context: context, database: database, job: job)),
              ],
            ),
            body: _buildContent(context, job),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Error"),
            ),
            body: Center(
              child: Text('Something went wrong: ${snapshot.error}'),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Loading..."),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _buildContent(BuildContext context, Job job) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(job: job),
      builder: (context, snapshot) {
        return JobListItemsBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              job: job,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.showEntryPage(
                context: context,
                database: database,
                job: job,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
